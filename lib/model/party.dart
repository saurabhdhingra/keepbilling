// To parse this JSON data, do
//
//     final payment = paymentFromMap(jsonString);



class Party {
  Party({
    required this.userid,
    required this.companyid,
    required this.product,
    required this.partyName,
    required this.partyAddress,
    required this.state,
    required this.pincode,
    required this.partyPhone,
    required this.partyMobile,
    required this.partyEmail1,
    required this.partyEmail2,
    required this.gstType,
    required this.partyGst,
    required this.pan,
    required this.pType,
    required this.openingBal,
    required this.deliveryAdd,
    required this.partnerlimit,
    required this.tds,
    required this.tdspercent,
    required this.paymentType,
    required this.payValue,
    required this.thirdParty,
  });

  String userid;
  String companyid;
  String product;
  String partyName;
  String partyAddress;
  String state;
  String pincode;
  String partyPhone;
  String partyMobile;
  String partyEmail1;
  String partyEmail2;
  String gstType;
  String partyGst;
  String pan;
  String pType;
  String openingBal;
  String deliveryAdd;
  String partnerlimit;
  String tds;
  String tdspercent;
  String paymentType;
  String payValue;
  String thirdParty;

  factory Party.fromMap(Map<String, dynamic> json) => Party(
        userid: json["userid"],
        companyid: json["companyid"],
        product: json["product"],
        partyName: json["party_name"],
        partyAddress: json["party_address"],
        state: json["state"],
        pincode: json["pincode"],
        partyPhone: json["party_phone"],
        partyMobile: json["party_mobile"],
        partyEmail1: json["party_email1"],
        partyEmail2: json["party_email2"],
        gstType: json["gst_type"],
        partyGst: json["party_gst"],
        pan: json["pan"],
        pType: json["p_type"],
        openingBal: json["opening_bal"],
        deliveryAdd: json["delivery_add"],
        partnerlimit: json["partnerlimit"],
        tds: json["tds"],
        tdspercent: json["tdspercent"],
        paymentType: json["payment_type"],
        payValue: json["pay_value"],
        thirdParty: json["third_party"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "product": product,
        "party_name": partyName,
        "party_address": partyAddress,
        "state": state,
        "pincode": pincode,
        "party_phone": partyPhone,
        "party_mobile": partyMobile,
        "party_email1": partyEmail1,
        "party_email2": partyEmail2,
        "gst_type": gstType,
        "party_gst": partyGst,
        "pan": pan,
        "p_type": pType,
        "opening_bal": openingBal,
        "delivery_add": deliveryAdd,
        "partnerlimit": partnerlimit,
        "tds": tds,
        "tdspercent": tdspercent,
        "payment_type": paymentType,
        "pay_value": payValue,
        "third_party": thirdParty,
      };
}
