import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'package:keepbilling/model/bill.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/journalVoucher.dart';
import '../model/voucher.dart';
import 'exceptions.dart';

class TransactionsService {
  final ApiService service = ApiService();

  Future fetchBills(
      String billType, String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.bills}all"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
                "bill_type": billType,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"] as List;
    } else if (responseJson["response_data"] == "") {
      return [];
    }
  }

  Future fetchOutstanding(
      String billType, String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.bills}outstanding"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
                "bill_type": billType,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"] as List;
    } else if (responseJson["response_data"] == "") {
      return [];
    }
  }

  Future fetchLedgerList(
      String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.ledgers),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"] as List;
    } else if (responseJson["response_data"] == "") {
      return [];
    }
  }

  Future fetchDataList(
      String category, String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.bills + category),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }
    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"] as List;
    } else if (responseJson["response_data"] == "") {
      return [];
    }
  }

  Future fetchExtraFieldData(
      String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.bills}extra_field"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }
    if (responseJson["response_data"] == "") {
      return {};
    } else {
      return responseJson["response_data"] as Map;
    }
  }

  Future fetchBillById(String companyId, Map data, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.billById}"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(<String, String>{
              "userid": data["user_id"],
              "companyid": companyId,
              "product": product,
              "bill_type": data["s_invoice_no"] == null ? "P" : "S",
              "invoice_no": data["s_invoice_no"] ?? data["p_invoice_no"],
              "invoice_date": data["inv_date"],
              "party_id": data["party_id"],
            }),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson["response_data"] as Map;
  }

  Future fetchSaleInvNo(String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.bills}invoice_no"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson["response_data"] as String;
  }

  Future fetchJVInvNo(String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.bills}jv_no"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson["response_data"] as String;
  }

  Future addVoucher(Voucher voucher) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.addVoucher),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(voucher.toMap()),
          )
          .timeout(const Duration(seconds: 10));
      print(voucher.toMap());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Future editTransaction(Map data, String category) async {
    dynamic responseJson;
    try {
      print(data);
      final response = await http
          .post(
            editUri(category),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Future addJournalVoucher(JournalVoucher journalVoucher) async {
    dynamic responseJson;
    try {
      print(journalVoucher.toMap());
      final response = await http
          .post(
            Uri.parse(service.backend + service.addJournalVoucher),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(journalVoucher.toMap()),
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Future addPayment(Map data) async {
    dynamic responseJson;
    String username = 'keepup';
  String password = 'Superior#123';
  String basicAuth =
      'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    try {
      print(data);
      final response = await http
          .post(
            Uri.parse(service.backend + service.addPayment),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'authorization': basicAuth,
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Future createBill(Bill bill) async {
    dynamic responseJson;
    try {
      print(bill.toMap());
      final response = await http
          .post(
            Uri.parse(service.backend + service.createBill),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(bill.toMap()),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Uri editUri(String category) {
    switch (category) {
      case "bill":
        return Uri.parse(service.backend + service.editBill);
      case "voucher":
        return Uri.parse(service.backend + service.editVoucher);
      case "jv":
        return Uri.parse(service.backend + service.editJV);

      default:
        return Uri.parse(service.backend);
    }
  }

  Future fetchBillPDF(String billType, String userId, String companyId,
      String billID, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse("${service.backend}${service.bills}bill_pdf"),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
                "bill_type": billType,
                "bill_id": billID,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Future fetchOutstandingList(String userId, String companyId, String product,
      String billType, String partyId) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.outstanding),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "userid": userId,
                "companyid": companyId,
                "product": product,
                "bill_type": billType,
                "party_id": partyId,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }
    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"]["bill"];
    } else if (responseJson["response_data"] == "") {
      return [];
    }
  }

  static Future<File> loadPDF(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);

        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw FetchDataException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communication with server' ' with status code : ${response.statusCode}');
    }
  }
}
