import '../utils/functions.dart';

class Voucher {
    Voucher({
        required this.userid,
        required this.companyid,
        required this.cashId,
        required this.product,
        required this.party,
        required this.voucherDate,
        required this.ledger,
        required this.amount,
        required this.gstApplicable,
        required this.gstPercent,
        required this.totalAmount,
        required this.narration,
    });

    String userid;
    String companyid;
    String cashId;
    String product;
    String party;
    dynamic voucherDate;
    String ledger;
    String amount;
    String gstApplicable;
    String gstPercent;
    String totalAmount;
    String narration;

    factory Voucher.fromMap(Map<String, dynamic> json) => Voucher(
        userid: json["userid"],
        companyid: json["companyid"],
        cashId: json["cash_id"],
        product: json["product"],
        party: json["party"],
        voucherDate: DateTime.parse(json["voucher_date"]),
        ledger: json["ledger"],
        amount: json["amount"],
        gstApplicable: json["gst_applicable"],
        gstPercent: json["gst_percent"],
        totalAmount: json["total_amount"],
        narration: json["narration"],
    );

    Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "cash_id": cashId,
        "product": product,
        "party": party,
        "voucher_date": voucherDate == "" ? voucherDate : formatDate(voucherDate),
        "ledger": ledger,
        "amount": amount,
        "gst_applicable": gstApplicable,
        "gst_percent": gstPercent,
        "total_amount": totalAmount,
        "narration": narration,
    };
}
