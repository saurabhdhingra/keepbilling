import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'package:keepbilling/model/bill.dart';

import '../model/journalVoucher.dart';
import '../model/voucher.dart';
import 'exceptions.dart';

class TransactionsService {
  final ApiService service = ApiService();

  Future fetchBills(String billType, String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "bill_type": billType,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as List;
  }

  Future fetchOutstanding(
      String billType, String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "bill_type": billType,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as List;
  }

  Future fetchLedgerList(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as List;
  }

  Future fetchDataList(String category, String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as List;
  }

  Future fetchExtraFieldData(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as Map;
  }

  Future fetchBillById(String companyId, Map data) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
          "product": "1",
          "bill_type": data["s_invoice_no"] == null ? "P" : "S",
          "invoice_no": data["s_invoice_no"] ?? data["p_invoice_no"],
          "invoice_date": data["inv_date"],
          "party_id": data["party_id"],
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as Map;
  }

  Future fetchSaleInvNo(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as String;
  }

  Future fetchJVInvNo(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"] as String;
  }

  Future addVoucher(Voucher voucher) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.addVoucher),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(voucher.toMap()),
      );
      print(voucher.toMap());
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future editTransaction(Map data, String category) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        editUri(category),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(data),
      );

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future addJournalVoucher(JournalVoucher journalVoucher) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.addJournalVoucher),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(journalVoucher.toMap()),
      );

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future createBill(Bill bill) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.createBill),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(bill.toMap()),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
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
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
