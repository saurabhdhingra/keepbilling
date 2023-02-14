import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:keepbilling/api/constants.dart';
import 'exceptions.dart';

class SettingsService {
  final ApiService service = ApiService();

  Future sendFeedback(
    String userId,
    String companyId,
    String subject,
    String description,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.contact),
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
            "subject": subject,
            "description": description
          },
        ),
      );
      
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future changeReferenceNo(
    String userId,
    String companyId,
    String cashId,
    String type,
    String number,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.refrenceNo),
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
            "cash_id": cashId,
            "product": "1",
            "type": type,
            "No": number,
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future setQuickLinks(
    String userId,
    String companyId,
    String cashId,
    String fav1,
    String fav2,
    String fav3,
    String fav4,
    String fav5,
    String fav6,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.setQuickLinks),
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
            "cash_id": cashId,
            "product": "1",
            "fav1": fav1,
            "fav2": fav2,
            "fav3": fav3,
            "fav4": fav4,
            "fav5": fav5,
            "fav6": fav6,
          },
        ),
      );

      responseJson = returnResponse(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future adjustExtrafields(
    String userId,
    String companyId,
    String cashId,
    String extra1,
    String extra2,
    String extra3,
    String extra4,
    String flag1,
    String flag2,
    String flag3,
    String flag4,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.extraFields),
        encoding: Encoding.getByName('gzip, deflate, br'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, String>{
          "userid": userId,
          "companyid": companyId,
          "cash_id": cashId,
          "product": "1",
          "extra_1": extra1,
          "extra_1_switch": flag1,
          "extra_2": extra2,
          "extra_2_switch": flag2,
          "extra_3": extra3,
          "extra_3_switch": flag3,
          "extra_4": extra4,
          "extra_4_switch": flag4,
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future setPaymentTerm(
    String userId,
    String companyId,
    String cashId,
    String term,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.setPaymentTerms),
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
            "cash_id": cashId,
            "product": "1",
            "term": term
          },
        ),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future sendOTPforPIN(
    String userId,
    String companyId,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.otpChangePin),
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
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future verifyOTPandChangePIN(
    String userId,
    String companyId,
    String otp,
    String oldPIN,
    String newPIN,
    String timeKey,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(service.backend + service.verifyChange),
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
            "otp": otp,
            "old_pin": oldPIN,
            "new_pin": newPIN,
            "timekey": timeKey
          },
        ),
      );
      responseJson = returnResponse(response);
      print(responseJson);
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
