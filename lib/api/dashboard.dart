import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'package:keepbilling/model/cheque.dart';
import 'package:keepbilling/model/toDoTask.dart';

import 'exceptions.dart';

class DashboardService {
  final ApiService service = ApiService();
  List<ToDoTask> decodeToDoData(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<ToDoTask>((json) => ToDoTask.fromMap(json)).toList();
  }

  List<Cheque> decodeChequeData(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Cheque>((json) => Cheque.fromMap(json)).toList();
  }

  Future fetchAllAccounts(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.quickViews),
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
            "product": "1"
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"].cast<String, dynamic>();
  }

  Future fetchChequeList(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.chequeList),
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
            "product": "1"
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return decodeChequeData(responseJson["response_data"]);
  }

    Future fetchQuickLinks(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.quickLinks),
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
            "product": "1"
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson["response_data"];
  }

  Future fetchToDoList(String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.todoList),
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
            "product": "1"
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return decodeToDoData(responseJson["response_data"]);
  }

  Future deleteToDo(String todoId, String userId, String companyId) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.editToDoList),
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
            "todo_id": todoId,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
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
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
