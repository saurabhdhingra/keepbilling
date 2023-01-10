import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'exceptions.dart';

class ProfileService {
  final ApiService service = ApiService();

  Future fetchLicenseDetails(String userId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse("${service.backend}${service.license}"),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(
          <String, String>{
            "userid": userId,
            "product": "1",
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
  }

  Future fetchTransactions(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse("${service.backend}${service.transactions}"),
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
          "from_date": "",
          "to_date": ""
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    if (responseJson["type"] == "error") {
      [];
    } else {
      return responseJson["response_data"];
    }
  }

  Future fetchCompanyDetails(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse("${service.backend}${service.company}"),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, String>{
          "userid": userId,
          "companyid": companyId,
          "product": "1"
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
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
