import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keepbilling/utils/functions.dart';

import '../../../utils/constants.dart';

class QuickView extends StatelessWidget {
  final Map data;
  const QuickView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return SizedBox(
      height: height * 0.25,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              {
                return card(
                  height,
                  width,
                  true,
                  false,
                  Colors.blue,
                  "Bank",
                  listChild(data["Bank"], height, width, true),
                );
              }
            case 1:
              {
                return card(
                  height,
                  width,
                  false,
                  false,
                  const Color.fromRGBO(16, 196, 161, 1),
                  "Cash",
                  listChild(data["Cash"], height, width, false),
                );
              }
            case 2:
              {
                return card(
                  height,
                  width,
                  false,
                  false,
                  Colors.blue,
                  "Purchase",
                  doubleTextChild(data["Purchase"], height, width,
                      "Total Purchase", "Purchase Outstanding"),
                );
              }
            case 3:
              {
                return card(
                  height,
                  width,
                  false,
                  false,
                  const Color.fromRGBO(16, 196, 161, 1),
                  "Sales",
                  doubleTextChild(data["Sales"], height, width, "Total Sales",
                      "Sales Outstanding"),
                );
              }
            case 4:
              {
                return card(
                  height,
                  width,
                  false,
                  false,
                  Colors.blue,
                  "Expenses",
                  singleTextChild(data["Expenses"], height, "Total Expense"),
                );
              }
            case 5:
              {
                return card(
                  height,
                  width,
                  false,
                  true,
                  const Color.fromRGBO(16, 196, 161, 1),
                  "Deposited",
                  doubleTextChild(data["Deposited"], height, width,
                      "Cheque Recievable", "Cheque Payable"),
                );
              }
            default:
              {
                return card(
                  height,
                  width,
                  false,
                  true,
                  const Color.fromRGBO(16, 196, 161, 1),
                  "Deposited",
                  listChild(data["Bank"], height, width, true),
                );
              }
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: width * 0.03,
          );
        },
      ),
    );
  }

  Widget card(double height, double width, bool isFirst, bool isLast,
      Color color, String title, Widget child) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          isFirst ? width * 0.05 : 0, 0, isLast ? width * 0.05 : 0, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, width * 0.02),
        width: width * 0.9,
        height: height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(height * 0.02),
          ),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  width * 0.02, height * 0.01, width * 0.02, 0),
              height: height * 0.05,
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(height * 0.02),
                  topRight: Radius.circular(height * 0.02),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image(
                    image: AssetImage(
                      icon(title),
                    ),
                    height: height * 0.03,
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.alfaSlabOne(
                      color: color == Colors.blue
                          ? const Color.fromRGBO(16, 196, 161, 1)
                          : Colors.blue,
                      fontSize: height * 0.028,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            SizedBox(
              height: height * 0.12,
              child: Align(
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
              child: GestureDetector(
                child: Text(
                  "Expand",
                  style: GoogleFonts.alfaSlabOne(
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listChild(List data, double height, double width, bool showIndex) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.3,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                showIndex
                    ? '${index + 1}. ${data[index]["name"]}      ${data[index]["balance"]}'
                    : '${data[index]["name"]}       ${data[index]["balance"]}',
                style: GoogleFonts.alfaSlabOne(
                  color: Colors.white,
                  fontSize: height * 0.02,
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget singleTextChild(Map data, double height, String key) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        "${data[key].round()} ",
        style: GoogleFonts.alfaSlabOne(
          color: Colors.white,
          fontSize: height * 0.05,
        ),
      ),
    );
  }

  Widget doubleTextChild(
      Map data, double height, double width, String key1, String key2) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                child: Text(
                  key1,
                  style: GoogleFonts.alfaSlabOne(
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, width * 0.05, 0),
                child: SizedBox(
                  width: width * 0.26,
                  height: height * 0.032,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data[key1].toString(),
                      style: GoogleFonts.alfaSlabOne(
                        color: Colors.white,
                        fontSize: height * 0.03,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                child: Text(
                  key2,
                  style: GoogleFonts.alfaSlabOne(
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, width * 0.05, 0),
                child: SizedBox(
                  width: width * 0.26,
                  height: height * 0.032,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data[key2].round().toString(),
                      style: GoogleFonts.alfaSlabOne(
                        color: Colors.white,
                        fontSize: height * 0.03,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
