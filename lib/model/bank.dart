class Bank {
  Bank({
    required this.userid,
    required this.companyid,
    required this.product,
    required this.bankName,
    required this.accountName,
    required this.accountNo,
    required this.bankBranch,
    required this.acType,
    required this.bankIfsc,
    required this.bankMicr,
    required this.balance,
    required this.bankDefault,
  });

  String userid;
  String companyid;
  String product;
  String bankName;
  String accountName;
  String accountNo;
  String bankBranch;
  String acType;
  String bankIfsc;
  String bankMicr;
  String balance;
  String bankDefault;

  factory Bank.fromMap(Map<String, dynamic> json) => Bank(
        userid: json["userid"],
        companyid: json["companyid"],
        product: json["product"],
        bankName: json["bank_name"],
        accountName: json["account_name"],
        accountNo: json["account_no"],
        bankBranch: json["bank_branch"],
        acType: json["ac_type"],
        bankIfsc: json["bank_ifsc"],
        bankMicr: json["bank_micr"],
        balance: json["balance"],
        bankDefault: json["default"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "product": product,
        "bank_name": bankName,
        "account_name": accountName,
        "account_no": accountNo,
        "bank_branch": bankBranch,
        "ac_type": acType,
        "bank_ifsc": bankIfsc,
        "bank_micr": bankMicr,
        "balance": balance,
        "default": bankDefault,
      };
}
