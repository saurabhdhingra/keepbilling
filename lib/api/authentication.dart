import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'package:keepbilling/model/cheque.dart';
import 'package:keepbilling/model/toDoTask.dart';

import 'exceptions.dart';

class AuthenticationService {
  final ApiService service = ApiService();

  Future sendOTP(String username) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.sendOTP),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{"username": username},
            ),
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

  Future verifyOTP(String userName, String otp, int timekey) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.verifyOTP),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{
                "username": userName,
                "otp": otp,
                "timekey": timekey.toString()
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

    return responseJson;
  }

  Future login(String pin, String userid) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(service.backend + service.login),
            encoding: Encoding.getByName('gzip, deflate, br'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            },
            body: jsonEncode(
              <String, String>{"pin": pin, "userid": userid},
            ),
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
        throw FetchDataException('Error occured while communication with server'
            ' with status code : ${response.statusCode}');
    }
  }
}
