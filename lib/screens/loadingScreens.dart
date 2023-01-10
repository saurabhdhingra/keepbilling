import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/formPages/titleText.dart';

Widget infoLoading(BuildContext context) {
  var width = SizeConfig.getWidth(context);
  var height = SizeConfig.getHeight(context);
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.03, 0, 0, 0),
            child: Container(
              height: height * 0.05,
              width: width * 0.6,
              color: Colors.grey.shade300,
            ),
          ),
          SizedBox(height: height * 0.01),
          ...List.generate(
            11,
            (index) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.015),
              child: Container(
                height: height * 0.04,
                width: width * 0.9,
                color: Colors.grey.shade300,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget dashboardLoading(BuildContext context) {
  var width = SizeConfig.getWidth(context);
  var height = SizeConfig.getHeight(context);
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 243, 243, 243),
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.menu),
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
            child: Container(
              height: height * 0.25,
              width: width * 0.9,
              color: Colors.grey.shade300,
            ),
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.03, height * 0.02, 0, 0),
            child: Container(
              height: height * 0.025,
              width: width * 0.3,
              color: Colors.grey.shade300,
            ),
          ),
          ...List.generate(
            3,
            (index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.07, height * 0.02, 0, height * 0.02),
                child: Container(
                  height: height * 0.03,
                  width: width * 0.9,
                  color: Colors.grey.shade300,
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.03, height * 0.02, 0, 0),
            child: Container(
              height: height * 0.025,
              width: width * 0.3,
              color: Colors.grey.shade300,
            ),
          ),
          ...List.generate(
            3,
            (index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.07, height * 0.02, 0, height * 0.02),
                child: Container(
                  height: height * 0.03,
                  width: width * 0.9,
                  color: Colors.grey.shade300,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget reportsLoading(BuildContext context) {
  var width = SizeConfig.getWidth(context);
  var height = SizeConfig.getHeight(context);
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.03, 0, 0, 0),
            child: Container(
              height: height * 0.05,
              width: width * 0.8,
              color: Colors.grey.shade300,
            ),
          ),
          SizedBox(height: height * 0.01),
          SizedBox(
            height: height * 0.056 * (13),
            child: DataTable(
              columns: <DataColumn>[
                customDataColumn(height, width),
                customDataColumn(height, width),
                customDataColumn(height, width),
              ],
              rows: List.generate(
                12,
                (index) {
                  return customDataRow(height, width);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget filtersLoading(BuildContext context, int count) {
  var width = SizeConfig.getWidth(context);
  var height = SizeConfig.getHeight(context);
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleText(text: "Filters"),
          ...List.generate(
            count,
            (int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.03, 0, 0, 0),
                    child: Container(
                      height: height * 0.02,
                      width: width * 0.5,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.045),
                    child: Container(
                      height: height * 0.03,
                      width: width * 0.9,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

DataColumn customDataColumn(double height, double width) {
  return DataColumn(
    label: Expanded(
      child: Container(
        height: height * 0.03,
        width: width * 0.3,
        color: Colors.grey.shade300,
      ),
    ),
  );
}

DataRow customDataRow(double height, double width) {
  return DataRow(
    cells: <DataCell>[
      DataCell(
        Container(
          height: height * 0.025,
          width: width * 0.3,
          color: Colors.grey.shade200,
        ),
      ),
      DataCell(
        Container(
          height: height * 0.025,
          width: width * 0.3,
          color: Colors.grey.shade200,
        ),
      ),
      DataCell(
        Container(
          height: height * 0.025,
          width: width * 0.3,
          color: Colors.grey.shade200,
        ),
      ),
    ],
  );
}
