import '../utils/functions.dart';

class Bill {
  Bill({
    required this.userid,
    required this.companyid,
    required this.cashId,
    required this.product,
    required this.billType,
    required this.party,
    required this.invoiceDate,
    required this.invoiceNo,
    required this.orderby,
    required this.orderNo,
    required this.orderDate,
    required this.despatchNo,
    required this.despatchThrough,
    required this.paymentTerms,
    required this.dueDate,
    required this.deliveryNote,
    required this.deliveryType,
    required this.extraF1,
    required this.extraF2,
    required this.extraF3,
    required this.extraF4,
    required this.ewaybillNo,
    required this.vendorCode,
    required this.grandTotal,
    required this.extraDiscount,
    required this.otherCharges,
    required this.round,
    required this.itemArray,
  });

  String userid;
  String companyid;
  String cashId;
  String product;
  String billType;
  String party;
  dynamic invoiceDate;
  String invoiceNo;
  String orderby;
  String orderNo;
  dynamic orderDate;
  String despatchNo;
  String despatchThrough;
  String paymentTerms;
  dynamic dueDate;
  String deliveryNote;
  String deliveryType;
  String ewaybillNo;
  String extraF1;
  String extraF2;
  String extraF3;
  String extraF4;
  String vendorCode;
  String grandTotal;
  String extraDiscount;
  String otherCharges;
  String round;
  Map itemArray;

  factory Bill.fromMap(Map<String, dynamic> json) => Bill(
        userid: json["userid"],
        companyid: json["companyid"],
        cashId: json["cash_id"],
        product: json["product"],
        billType: json["bill_type"],
        party: json["party"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
        invoiceNo: json["invoice_no"],
        orderby: json["orderby"],
        orderNo: json["order_no"],
        orderDate: DateTime.parse(json["order_date"]),
        despatchNo: json["despatch_no"],
        despatchThrough: json["despatch_through"],
        paymentTerms: json["payment_terms"],
        dueDate: DateTime.parse(json["due_date"]),
        deliveryNote: json["delivery_note"],
        deliveryType: json["delivery_type"],
        ewaybillNo: json["ewaybill_no"],
        extraF1: json["extra_field1"],
        extraF2: json["extra_field2"],
        extraF3: json["extra_field3"],
        extraF4: json["extra_field4"],
        vendorCode: json["vendor_code"],
        grandTotal: json["grand_total"],
        extraDiscount: json["extra_discount"],
        otherCharges: json["other_charges"],
        round: json["round"],
        itemArray: json["item_array"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "cash_id": cashId,
        "product": product,
        "bill_type": billType,
        "party": party,
        "invoice_date":
            invoiceDate == "" ? invoiceDate : formatDate(invoiceDate),
        "invoice_no": invoiceNo,
        "orderby": orderby,
        "order_no": orderNo,
        "order_date": orderDate == "" ? orderDate : formatDate(orderDate),
        "despatch_no": despatchNo,
        "despatch_through": despatchThrough,
        "payment_terms": paymentTerms,
        "due_date": dueDate == "" ? dueDate : formatDate(dueDate),
        "delivery_note": deliveryNote,
        "delivery_type": deliveryType,
        "ewaybill_no": ewaybillNo,
        "extra_field1": extraF1,
        "extra_field2": extraF2,
        "extra_field3": extraF3,
        "extra_field4": extraF4,
        "vendor_code": vendorCode,
        "grand_total": grandTotal,
        "extra_discount": extraDiscount,
        "other_charges": otherCharges,
        "round": round,
        "item_array": itemArray,
      };
}
