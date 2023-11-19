import 'package:flutter/material.dart';
import 'package:keepbilling/screens/masterPages/bank.dart';
import 'package:keepbilling/screens/transactionPages/expense.dart';
import 'package:keepbilling/screens/transactionPages/purchase.dart';
import 'package:keepbilling/screens/transactionPages/sale.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:keepbilling/widgets/navscreens/rowText.dart';

import '../../../utils/constants.dart';

class QuickView extends StatelessWidget {
  final Map data;
  final bool isTab;
  const QuickView({
    Key? key,
    required this.data,
    required this.isTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return SizedBox(
      height: height * 0.25,
      child: Padding(
        padding:
            EdgeInsetsDirectional.fromSTEB(width * 0.05, 0, width * 0.05, 0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          key: const PageStorageKey("Quick Links"),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: width * 0.45,
            childAspectRatio: isTab ? 4.0 : 3.0,
            crossAxisSpacing: width * 0.02,
            mainAxisSpacing: isTab ? width * 0.03 : width * 0.05,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                {
                  return card(
                    height,
                    width,
                    "Total Balance",
                    "Cash and Bank ",
                    const Color.fromARGB(255, 214, 214, 214),
                    const BankMaster(),
                    true,
                    context,
                  );
                }
              case 1:
                {
                  return card(
                    height,
                    width,
                    data["Expenses"]["Total"].toInt().toString(),
                    "Expenses",
                    const Color.fromARGB(255, 214, 214, 214),
                    const ExpensesTransaction(),
                    true,
                    context,
                  );
                }

              case 2:
                {
                  return card(
                    height,
                    width,
                    data["Sales"]["Total"].toInt().toString(),
                    "Sales",
                    const Color.fromARGB(255, 214, 214, 214),
                    const SaleTransaction(),
                    true,
                    context,
                  );
                }
              case 3:
                {
                  return card(
                    height,
                    width,
                    data["Purchase"]["Total"].toInt().toString(),
                    "Purchase",
                    const Color.fromARGB(255, 214, 214, 214),
                    const PurchaseTransaction(),
                    true,
                    context,
                  );
                }
              case 4:
                {
                  return card(
                    height,
                    width,
                    data["Post Dated Cheque"]["Recievable"].toInt().toString(),
                    "Cheque Recievable",
                    const Color.fromARGB(167, 16, 196, 160),
                    const SizedBox(),
                    false,
                    context,
                  );
                }
              case 5:
                {
                  return card(
                    height,
                    width,
                    data["Post Dated Cheque"]["Payable"].toInt().toString(),
                    "Cheque Payable",
                    const Color.fromARGB(160, 244, 67, 54),
                    const SizedBox(),
                    false,
                    context,
                  );
                }
              default:
                {
                  return card(
                    height,
                    width,
                    data["Bank"] + data["Cash"],
                    "ABC",
                    const Color.fromARGB(255, 214, 214, 214),
                    const ExpensesTransaction(),
                    true,
                    context,
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget card(double height, double width, String title, String subtitle,
      Color color, Widget screen, bool isButton, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.005, vertical: height * 0.002),
      child: GestureDetector(
        onTap: () {
          if (isButton) {
            if (title == "Total Balance") {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialogBankAndCash(
                        height,
                        width,
                        data["Cash"][0]["balance"].toInt().toString(),
                        data["Bank"],
                        isTab,
                        context);
                  });
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (constext) => screen));
            }
          }
        },
        child: Container(
          height: height * 0.07,
          width: width * 0.4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(height * 0.02),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: height * 0.018,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                isButton
                    ? Icon(
                        Icons.chevron_right,
                        size: isTab ? width * 0.04 : width * 0.045,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget dialogBankAndCash(double height, double width, String cashData,
    List bankData, bool isTab, BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.04)), //this right here
    child: SizedBox(
      height: height * 0.6,
      width: width * 0.85,
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            const RowText(text: "Cash Balance"),
            SizedBox(height: height * 0.01),
            Padding(
                padding: EdgeInsets.fromLTRB(width * 0.04, 0, 0, 0),
                child:
                    Text(cashData, style: TextStyle(fontSize: height * 0.018))),
            SizedBox(height: height * 0.02),
            const RowText(text: "Banks"),
            SizedBox(
              height: height * 0.35,
              child: ListView.builder(
                itemCount: bankData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: isTab
                        ? EdgeInsets.fromLTRB(width * 0.04, 0, 0, 0)
                        : EdgeInsets.zero,
                    child: ListTile(
                      title: Text(bankData[index]["name"],
                          style: TextStyle(
                              fontSize: isTab ? width * 0.03 : width * 0.04)),
                      subtitle: Text(
                          bankData[index]["balance"].toInt().toString(),
                          style: TextStyle(
                              fontSize: isTab ? width * 0.025 : width * 0.035)),
                    ),
                  );
                },
              ),
            ),
            SubmitButton(
                text: "Done",
                onSubmit: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    ),
  );
}

// class QuickView extends StatelessWidget {
//   final Map data;
//   final bool isTab;
//   const QuickView({
//     Key? key,
//     required this.data,
//     required this.isTab,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var height = SizeConfig.getHeight(context);
//     var width = SizeConfig.getWidth(context);
//     return SizedBox(
//       height: height * 0.25,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           switch (index) {
//             case 0:
//               {
//                 return card(
//                   height,
//                   width,
//                   true,
//                   false,
//                   Colors.blue,
//                   "Bank and Cash",
//                   bankAndCash(data["Cash"] + data["Bank"], height, width),
//                   context,
//                   const BankMaster(),
//                 );
//               }
//             case 1:
//               {
//                 return card(
//                     height,
//                     width,
//                     false,
//                     false,
//                     const Color.fromRGBO(16, 196, 161, 1),
//                     "Purchase",
//                     doubleTextChild(data["Purchase"], height, width, "Total",
//                         "Outstanding"),
//                     context,
//                     const PurchaseTransaction());
//               }
//             case 2:
//               {
//                 return card(
//                     height,
//                     width,
//                     false,
//                     false,
//                     Colors.blue,
//                     "Sales",
//                     doubleTextChild(
//                         data["Sales"], height, width, "Total", "Outstanding"),
//                     context,
//                     const SaleTransaction());
//               }
//             case 3:
//               {
//                 return card(
//                     height,
//                     width,
//                     false,
//                     false,
//                     const Color.fromRGBO(16, 196, 161, 1),
//                     "Expenses",
//                     singleTextChild(data["Expenses"], height, "Total"),
//                     context,
//                     const ExpensesTransaction());
//               }
//             case 4:
//               {
//                 return card(
//                   height,
//                   width,
//                   false,
//                   true,
//                   Colors.blue,
//                   "Post Dated Cheque",
//                   doubleTextChild(data["Post Dated Cheque"], height, width,
//                       "Recievable", "Payable"),
//                   context,
//                   null,
//                 );
//               }
//             default:
//               {
//                 return card(
//                   height,
//                   width,
//                   false,
//                   true,
//                   const Color.fromRGBO(16, 196, 161, 1),
//                   "ABC",
//                   bankAndCash(data["Bank"] + data["Cash"], height, width),
//                   context,
//                   null,
//                 );
//               }
//           }
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(
//             width: width * 0.03,
//           );
//         },
//       ),
//     );
//   }

  // Widget card(
  //   double height,
  //   double width,
  //   bool isFirst,
  //   bool isLast,
  //   Color color,
  //   String title,
  //   Widget child,
  //   BuildContext context,
  //   Widget? screen,
  // ) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (screen != null) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => screen));
  //       }
  //     },
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(
  //           isFirst ? width * 0.04 : 0, 0, isLast ? width * 0.05 : 0, 0),
  //       child: Container(
  //         padding: EdgeInsets.fromLTRB(0, 0, 0, width * 0.02),
  //         width: isTab ? width * 0.45 : width * 0.9,
  //         height: isTab ? height * 0.27 : height * 0.3,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(height * 0.02),
  //           ),
  //           color: color,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               padding: EdgeInsets.fromLTRB(
  //                   width * 0.02, height * 0.01, width * 0.02, 0),
  //               height: height * 0.05,
  //               width: width * 0.9,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(height * 0.02),
  //                   topRight: Radius.circular(height * 0.02),
  //                 ),
  //                 color: Colors.white,
  //               ),
  //               child: Row(
  //                 children: [
  //                   Image(
  //                     image: AssetImage(
  //                       icon(title),
  //                     ),
  //                     height: height * 0.03,
  //                   ),
  //                   SizedBox(
  //                     width: width * 0.03,
  //                   ),
  //                   SizedBox(
  //                     height: isTab ? height * 0.03 : height * 0.032,
  //                     child: FittedBox(
  //                       child: Text(
  //                         title,
  //                         style: GoogleFonts.alfaSlabOne(
  //                           color: color == Colors.blue
  //                               ? const Color.fromRGBO(16, 196, 161, 1)
  //                               : Colors.blue,
  //                           fontSize: height * 0.028,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: isTab ? height * 0.015 : height * 0.03),
  //             SizedBox(
  //               height: height * 0.14,
  //               child: Align(
  //                 alignment: Alignment.topCenter,
  //                 child: child,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget bankAndCash(List data, double height, double width) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: ListView.builder(
  //               physics: const NeverScrollableScrollPhysics(),
  //               padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
  //               shrinkWrap: true,
  //               itemCount: min(data.length, 4),
  //               itemBuilder: (BuildContext context, int index) {
  //                 return Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     SizedBox(
  //                       height: isTab ? height * 0.026 : height * 0.032,
  //                       width: isTab ? width * 0.28 : width * 0.32,
  //                       child: Text(
  //                         '  ${data[index]["name"]}',
  //                         overflow: TextOverflow.ellipsis,
  //                         style: GoogleFonts.alfaSlabOne(
  //                           color: Colors.white,
  //                           fontSize: height * 0.023,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: isTab ? height * 0.028 : height * 0.032,
  //                       child: FittedBox(
  //                         child: Text(
  //                           '${data[index]["balance"]}   ',
  //                           style: GoogleFonts.alfaSlabOne(
  //                             color: Colors.white,
  //                             fontSize: height * 0.025,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget singleTextChild(Map data, double height, String key) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: SizedBox(
  //       height: isTab ? height * 0.06 : height * 0.065,
  //       child: FittedBox(
  //         child: Text(
  //           "${data[key].round()} ",
  //           style: GoogleFonts.alfaSlabOne(
  //             color: Colors.white,
  //             fontSize: height * 0.05,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget doubleTextChild(
  //     Map data, double height, double width, String key1, String key2) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             SizedBox(
  //               height: height * 0.032,
  //               child: FittedBox(
  //                 child: Text(
  //                   "  $key1",
  //                   style: GoogleFonts.alfaSlabOne(
  //                     color: Colors.white,
  //                     fontSize: height * 0.023,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: height * 0.032,
  //               child: FittedBox(
  //                 child: Text(
  //                   "${data[key1].round()}  ",
  //                   style: GoogleFonts.alfaSlabOne(
  //                     color: Colors.white,
  //                     fontSize: height * 0.03,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             SizedBox(
  //               height: height * 0.032,
  //               child: FittedBox(
  //                 child: Text(
  //                   "  $key2",
  //                   style: GoogleFonts.alfaSlabOne(
  //                     color: Colors.white,
  //                     fontSize: height * 0.023,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: height * 0.032,
  //               child: FittedBox(
  //                 child: Text(
  //                   "${data[key2].round()}  ",
  //                   style: GoogleFonts.alfaSlabOne(
  //                     color: Colors.white,
  //                     fontSize: height * 0.03,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
//  

