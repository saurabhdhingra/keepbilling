import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'exceptions.dart';

class MasterService {
  final ApiService service = ApiService();

  List<Map> decodeMapData(Map data) {
    List<Map> result = [];
    data.forEach((k, v) {
      result.add(v);
    });
    return result;
  }

  Uri fetchUri(String category) {
    switch (category) {
      case "party":
        return Uri.parse(service.backend + service.party);
      case "item":
        return Uri.parse(service.backend + service.item);
      case "quotation":
        return Uri.parse(service.backend + service.quotation);
      case "billprefix":
        return Uri.parse(service.backend + service.billprefix);
      case "bank":
        return Uri.parse(service.backend + service.bank);
      case "allgroup":
        return Uri.parse(service.backend + service.itemGroups);
      case "allunit":
        return Uri.parse(service.backend + service.units);
      default:
        return Uri.parse(service.backend);
    }
  }

  Uri addUri(String category) {
    switch (category) {
      case "party":
        return Uri.parse(service.backend + service.addParty);
      case "item":
        return Uri.parse(service.backend + service.addItem);
      case "quotation":
        return Uri.parse(service.backend + service.addQuotation);
      case "bank":
        return Uri.parse(service.backend + service.addBank);
      case "group":
      return Uri.parse(service.backend + service.addGroup);
       case "unit":
      return Uri.parse(service.backend + service.addUnit);

      default:
        return Uri.parse(service.backend);
    }
  }

  Uri editUri(String category) {
    switch (category) {
      case "party":
        return Uri.parse(service.backend + service.editParty);
      case "item":
        return Uri.parse(service.backend + service.editItem);
      case "quotation":
        return Uri.parse(service.backend + service.editQuotation);
      case "bank":
        return Uri.parse(service.backend + service.editBank);
      default:
        return Uri.parse(service.backend);
    }
  }

  Future fetchDataList(
      String userId, String companyId, String category, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            fetchUri(category),
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
        category != "quotation" &&
        responseJson["response_data"] != "") {
      return responseJson["response_data"] as List;
    } else if (responseJson["type"] == "success" &&
        category == "quotation" &&
        responseJson["response_data"] != "") {
      return decodeMapData(responseJson["response_data"]);
    } else if (responseJson["response_data"] == "") {
      return [];
    } else {
      return [];
    }
  }

  Future addMaster(Map data, String category) async {
    dynamic responseJson;
    try {
      print(data);
      final response = await http
          .post(
            addUri(category),
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

  Future editMaster(Map data, String category) async {
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
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out.');
    }

    return responseJson;
  }

  Future fetchCredDeb(
      String type, String userId, String companyId, String product) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.credDeb),
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
                "party_type": type
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
