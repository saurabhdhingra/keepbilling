import '../utils/functions.dart';

class Quotation {
  Quotation({
    required this.userid,
    required this.companyid,
    required this.product,
    required this.party,
    required this.buildDate,
    required this.subject,
    required this.grandtotal,
    required this.otherCharges,
    required this.extraComment,
    required this.grandQty,
    required this.itemArray,
  });

  String userid;
  String companyid;
  String product;
  String party;
  dynamic buildDate;
  String subject;
  String grandtotal;
  String otherCharges;
  String extraComment;
  String grandQty;
  Map itemArray;

  factory Quotation.fromMap(Map<String, dynamic> json) => Quotation(
        userid: json["userid"],
        companyid: json["companyid"],
        product: json["product"],
        party: json["party"],
        buildDate: DateTime.parse(json["build_date"]),
        subject: json["subject"],
        grandtotal: json["grandtotal"],
        otherCharges: json["otherCharges"],
        extraComment: json["extra_comment"],
        grandQty: json["grand_qty"],
        itemArray: json["item_array"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "product": product,
        "party": party,
        "build_date": buildDate == "" ? "" : formatDate(buildDate),
        "subject": subject,
        "grandtotal": grandtotal,
        "otherCharges": otherCharges,
        "extra_comment": extraComment,
        "grand_qty": grandQty,
        "item_array": itemArray,
      };
}
