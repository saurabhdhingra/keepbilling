import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'exceptions.dart';

class ReportsService {
  final ApiService service = ApiService();

  Future fetchGeneralReport(
      String userId,
      String companyId,
      String sundryCreditor,
      String sundryDebitor,
      String itemId,
      String fromDate,
      String toDate,String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.generalReport),
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
                "sundry_creditor": sundryCreditor,
                "sundry_debitor": sundryDebitor,
                "item_id": itemId,
                "from_date": fromDate,
                "to_date": toDate,
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
        responseJson["response_data_Purchase"] != "" &&
        responseJson["response_data_sale"] != "") {
      return {
        "purchaseData": responseJson["response_data_Purchase"],
        "saleData": responseJson["response_data_sale"]
      };
    } else {
      return {"purchaseData": [], "saleData": []};
    }
  }

  Future fetchStockSummary(
    String userId,
    String companyId,
    String itemName,
    String stockLimit,
    String stockSign,String product
  ) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.stockSummary),
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
                "item_name": itemName,
                "stock_limit": stockLimit,
                "stock_sign": stockSign,
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

    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"];
    } else {
      return [];
    }
  }

  Future fetchStockStatement(
    String userId,
    String companyId,
    String itemName,
    String fromDate,
    String toDate,String product
  ) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.stockStatement),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(<String, String>{
              "userid": userId,
              "companyid": companyId,
              "product": product,
              "from_date": fromDate,
              "to_date": toDate,
              "item": itemName,
            }),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"];
    } else {
      return [];
    }
  }

  Future fetchGSTStatement(
    String userId,
    String companyId,
    String party,
    String gstType,
    String fromDate,
    String toDate,String product
  ) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.gstSummary),
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
                "party": party,
                "gst_type": gstType,
                "from_date": fromDate,
                "to_date": toDate,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
      print(responseJson["final_gst"]);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return {
      "inward": responseJson["inward"],
      "outward": responseJson["outward"],
      "final": responseJson["final_gst"]
    };
  }

  Future fetchGSTdetailedStatement(
    String userId,
    String companyId,
    String party,
    String gstType,
    String fromDate,
    String toDate,String product
  ) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.gstDetailed),
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
                "party": party,
                "gst_type": gstType,
                "from_date": fromDate,
                "to_date": toDate,
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
      return responseJson["response_data"];
    } else {
      return [];
    }
  }

  Future fetchHSNReport(
    String userId,
    String companyId,
    String hsn,
    String fromDate,
    String toDate,String product
  ) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.tdsReport),
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
                "hsn": hsn,
                "from_date": fromDate,
                "to_date": toDate,
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
      return responseJson["response_data"];
    } else {
      return [];
    }
  }

  Future fetchTDSReport(
    String userId,
    String companyId,
    String party,
    String gstType,
    String fromDate,
    String toDate,String product
  ) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.tdsReport),
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
                "party": party,
                "gst_type": gstType,
                "from_date": fromDate,
                "to_date": toDate,
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
    if (responseJson["type"] == "success" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"];
    } else {
      return [];
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
