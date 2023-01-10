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
      String toDate) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "sundry_creditor": sundryCreditor,
            "sundry_debitor": sundryDebitor,
            "item_id": itemId,
            "from_date": fromDate,
            "to_date": toDate,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return {
      "purchaseData": responseJson["response_data_Purchase"],
      "saleData": responseJson["response_data_sale"]
    };
  }

  Future fetchStockSummary(
    String userId,
    String companyId,
    String itemName,
    String stockLimit,
    String stockSign,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "item_name": itemName,
            "stock_limit": stockLimit,
            "stock_sign": stockSign,
          },
        ),
      );
      responseJson = returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
  }

  Future fetchStockStatement(
    String userId,
    String companyId,
    String itemName,
    String fromDate,
    String toDate,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
          "product": "1",
          "from_date": fromDate,
          "to_date": toDate,
          "item": itemName,
        }),
      );
      responseJson = returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
  }

  Future fetchGSTStatement(
    String userId,
    String companyId,
    String party,
    String gstType,
    String fromDate,
    String toDate,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "party": party,
            "gst_type": gstType,
            "from_date": fromDate,
            "to_date": toDate,
          },
        ),
      );
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
    String toDate,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "party": party,
            "gst_type": gstType,
            "from_date": fromDate,
            "to_date": toDate,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
  }

  Future fetchHSNReport(
    String userId,
    String companyId,
    String hsn,
    String fromDate,
    String toDate,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "hsn": hsn,
            "from_date": fromDate,
            "to_date": toDate,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
  }

  Future fetchTDSReport(
    String userId,
    String companyId,
    String party,
    String gstType,
    String fromDate,
    String toDate,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
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
            "product": "1",
            "party": party,
            "gst_type": gstType,
            "from_date": fromDate,
            "to_date": toDate,
          },
        ),
      );
      responseJson = returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    if (responseJson["type"] == "success") {
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
