import 'package:flutter/material.dart';
import '../utils/constants.dart';

ScrollController? getCurrentController(int index) {
  switch (index) {
    case 0:
      return controller0;
    case 1:
      return controller1;
    case 2:
      return controller2;
    case 3  : return controller3;
    default:
      return null;
  }
}

String icon(String title) {
  switch (title) {
    case "Bank":
      return 'assets/bank.png';
    case "Cash":
      return 'assets/money.png';
    case "Expenses":
      return 'assets/expenses.png';
    case "Purchase":
      return 'assets/purchase.png';
    case "Sales":
      return 'assets/sales.png';
    case "Deposited":
      return 'assets/deposit.png';
    default:
      return 'assets/bank.png';
  }
}

List<Map> decodeMapData(Map data) {
  List<Map> result = [];
  data.forEach((k, v) {
    result.add(v);
  });
  return result;
}

Map itemArray(List items) {
  Map<String, Map> answer = {};
  for (int i = 0; i < items.length; i++) {
    answer["item$i"] = {
      "name": items[i]["item_name"],
      "qty": items[i]["qntty"],
      "descrip": items[i][""],
      "rate": items[i]["rate"],
      "amt": items[i]["amt"],
      "discount": items[i]["disc"],
      "tax": items[i]["gst"],
    };
  }
  return answer;
}

Map itemArrayQuot(List items) {
  Map<String, Map> answer = {};
  for (int i = 0; i < items.length; i++) {
    answer["item$i"] = items[i];
  }
  return answer;
}

Map jvArray(List<Map> items) {
  Map<String, Map> answer = {};
  for (int i = 0; i < items.length; i++) {
    answer["JV$i"] = items[i];
  }
  return answer;
}

int? getBankValue(Map data) {
  int? value = 0;
  for (var v in data.values) {
    value = value! + v.value as int;
  }
  return value;
}

String formatDate(DateTime selectedDate) {
  return '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
}
