class JournalVoucher {
  JournalVoucher({
    required this.userid,
    required this.companyid,
    required this.cashId,
    required this.product,
    required this.jvEntry,
  });

  String userid;
  String companyid;
  String cashId;
  String product;
  Map jvEntry;

  factory JournalVoucher.fromMap(Map<String, dynamic> json) => JournalVoucher(
        userid: json["userid"],
        companyid: json["companyid"],
        cashId: json["cash_id"],
        product: json["product"],
        jvEntry: json["JV_entry"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "cash_id": cashId,
        "product": product,
        "JV_entry": jvEntry,
      };
}
