

class Item {
    Item({
        required this.userid,
        required this.companyid,
        required this.product,
        required this.itemName,
        required this.under,
        required this.itemStock,
        required this.hsnSac,
        required this.tax,
        required this.per,
        required this.opStock,
        required this.opRate,
        required this.sRate,
        required this.pRate,
        required this.itemType,
        required this.trackable,
        required this.stockLimit,
    });

    String userid;
    String companyid;
    String product;
    String itemName;
    String under;
    String itemStock;
    String hsnSac;
    String tax;
    String per;
    String opStock;
    String opRate;
    String sRate;
    String pRate;
    String itemType;
    String trackable;
    String stockLimit;

    factory Item.fromMap(Map<String, dynamic> json) => Item(
        userid: json["userid"],
        companyid: json["companyid"],
        product: json["product"],
        itemName: json["item_name"],
        under: json["under"],
        itemStock: json["item_stock"],
        hsnSac: json["hsn_sac"],
        tax: json["tax"],
        per: json["per"],
        opStock: json["op_stock"],
        opRate: json["op_rate"],
        sRate: json["s_rate"],
        pRate: json["p_rate"],
        itemType: json["item_type"],
        trackable: json["trackable"],
        stockLimit: json["stock_limit"],
    );

    Map<String, dynamic> toMap() => {
        "userid": userid,
        "companyid": companyid,
        "product": product,
        "item_name": itemName,
        "under": under,
        "item_stock": itemStock,
        "hsn_sac": hsnSac,
        "tax": tax,
        "per": per,
        "op_stock": opStock,
        "op_rate": opRate,
        "s_rate": sRate,
        "p_rate": pRate,
        "item_type": itemType,
        "trackable": trackable,
        "stock_limit": stockLimit,
    };
}
