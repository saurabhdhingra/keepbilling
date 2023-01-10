
class Cheque {
    Cheque({
        required this.chqDate,
        required this.type,
        required this.party,
        required this.invNo,
        required this.amount,
    });

    String chqDate;
    String type;
    String party;
    String invNo;
    String amount;

    factory Cheque.fromMap(Map<String, dynamic> json) => Cheque(
        chqDate: json["chq_date"],
        type: json["type"],
        party: json["party"],
        invNo: json["inv_no"],
        amount: json["amount"],
    );

    Map<String, dynamic> toMap() => {
        "chq_date": chqDate,
        "type": type,
        "party": party,
        "inv_no": invNo,
        "amount": amount,
    };
}
