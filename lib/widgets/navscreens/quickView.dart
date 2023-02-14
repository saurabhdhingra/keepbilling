import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keepbilling/screens/dumy.dart';
import 'package:keepbilling/screens/masterPages/bank.dart';
import 'package:keepbilling/screens/transactionPages/expense.dart';
import 'package:keepbilling/screens/transactionPages/purchase.dart';
import 'package:keepbilling/screens/transactionPages/sale.dart';
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
        itemCount: 5,
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
                  "Bank and Cash",
                  bankAndCash(data["Cash"] + data["Bank"], height, width),
                  context,
                  const BankMaster(),
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
                    "Purchase",
                    doubleTextChild(data["Purchase"], height, width, "Total",
                        "Outstanding"),
                    context,
                    const PurchaseTransaction());
              }
            case 2:
              {
                return card(
                    height,
                    width,
                    false,
                    false,
                    Colors.blue,
                    "Sales",
                    doubleTextChild(
                        data["Sales"], height, width, "Total", "Outstanding"),
                    context,
                    const SaleTransaction());
              }
            case 3:
              {
                return card(
                    height,
                    width,
                    false,
                    false,
                    const Color.fromRGBO(16, 196, 161, 1),
                    "Expenses",
                    singleTextChild(data["Expenses"], height, "Total"),
                    context,
                    const ExpensesTransaction());
              }
            case 4:
              {
                return card(
                  height,
                  width,
                  false,
                  true,
                  Colors.blue,
                  "Post Dated Cheque",
                  doubleTextChild(data["Post Dated Cheque"], height, width,
                      "Recievable", "Payable"),
                  context,
                  null,
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
                  "ABC",
                  bankAndCash(data["Bank"] + data["Cash"], height, width),
                  context,
                  null,
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

  Widget card(
    double height,
    double width,
    bool isFirst,
    bool isLast,
    Color color,
    String title,
    Widget child,
    BuildContext context,
    Widget? screen,
  ) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        }
      },
      child: Padding(
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
                    SizedBox(
                      height: height * 0.032,
                      child: FittedBox(
                        child: Text(
                          title,
                          style: GoogleFonts.alfaSlabOne(
                            color: color == Colors.blue
                                ? const Color.fromRGBO(16, 196, 161, 1)
                                : Colors.blue,
                            fontSize: height * 0.028,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                height: height * 0.14,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bankAndCash(List data, double height, double width) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                shrinkWrap: true,
                itemCount: min(data.length, 4),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.032,
                        child: FittedBox(
                          child: Text(
                            '  ${data[index]["name"]}',
                            style: GoogleFonts.alfaSlabOne(
                              color: Colors.white,
                              fontSize: height * 0.023,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.032,
                        child: FittedBox(
                          child: Text(
                            '${data[index]["balance"]}   ',
                            style: GoogleFonts.alfaSlabOne(
                              color: Colors.white,
                              fontSize: height * 0.025,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget singleTextChild(Map data, double height, String key) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: height * 0.065,
        child: FittedBox(
          child: Text(
            "${data[key].round()} ",
            style: GoogleFonts.alfaSlabOne(
              color: Colors.white,
              fontSize: height * 0.05,
            ),
          ),
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
              SizedBox(
                height: height * 0.032,
                child: FittedBox(
                  child: Text(
                    "  $key1",
                    style: GoogleFonts.alfaSlabOne(
                      color: Colors.white,
                      fontSize: height * 0.023,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.032,
                child: FittedBox(
                  child: Text(
                    "${data[key1].round()}  ",
                    style: GoogleFonts.alfaSlabOne(
                      color: Colors.white,
                      fontSize: height * 0.03,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.032,
                child: FittedBox(
                  child: Text(
                    "  $key2",
                    style: GoogleFonts.alfaSlabOne(
                      color: Colors.white,
                      fontSize: height * 0.023,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.032,
                child: FittedBox(
                  child: Text(
                    "${data[key2].round()}  ",
                    style: GoogleFonts.alfaSlabOne(
                      color: Colors.white,
                      fontSize: height * 0.03,
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
