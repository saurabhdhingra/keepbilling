import 'package:flutter/material.dart';
import 'package:keepbilling/screens/masterPages/export.dart';
import 'package:keepbilling/screens/profilePages/export.dart';
import 'package:keepbilling/screens/transactionPages/export.dart';
import 'package:keepbilling/screens/reportsPages/filtersPages/export.dart';

import '../screens/masterPages/bank.dart';

class SizeConfig {
  static getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}

Map quickLinksScreens = {
  "Party": const PartyMaster(),
  "Quotation": const QuotationMaster(),
  "Sales": const SaleTransaction(),
  "Purchase": const PurchaseTransaction(),
  "Voucher": const VoucherTransaction(),
};

final List<String> toDos = [
  "Update passook",
  "Call Mr. Bhavesh Shah",
  "File ITR",
  "Sign Quotation"
];

final List<Map<String, String>> cheques = [
  {"date": "01/10", "amount": "₹10,000"},
  {"date": "03/10", "amount": "₹4,000"},
  {"date": "18/09", "amount": "₹120,000"},
];

final List states = [
  "Unselected",
  "Andaman & Nicobar",
  "Andhra Pradesh",
  "AndhraPradesh(new)",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chandigarh",
  "Chattisgarh",
  "Dadra and Nagar Haveli",
  "Daman and Diu",
  "Delhi",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jammu & Kashmir",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Lakshadweep",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Odisha",
  "Pondichery",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal"
];

final List banks = [
  "ABHYUDAYA CO-OP BANK LTD",
  "ABU DHABI COMMERCIAL BANK",
  "AKOLA DISTRICT CENTRAL CO-OPERATIVE BANK",
  "HDFC"
];

final List<Map> links = [
  {
    "title": "Master",
    "subLinks": [
      {"title": "Party", "screen": const PartyMaster()},
      {"title": "Item", "screen": const ItemMaster()},
      {"title": "Bank", "screen": const BankMaster()},
      {"title": "Quotation", "screen": const QuotationMaster()},
      {"title": "Bill Prefix", "screen": const BillMaster()}
    ]
  },
  {
    "title": "Transaction",
    "subLinks": [
      {"title": "Purchase", "screen": const PurchaseTransaction()},
      {"title": "Sale", "screen": const SaleTransaction()},
      {"title": "Receipts", "screen": const RecieptsTransaction()},
      {"title": "Expense", "screen": const ExpensesTransaction()},
      {"title": "Voucher", "screen": const VoucherTransaction()},
      {"title": "Journal Voucher", "screen": const JournalVoucherTransaction()},
      // {"title": "Contra", "screen": const ContraTransaction()},
      {"title": "Outstanding", "screen": const OutstandingTransaction()},
      {"title": "Debit Note", "screen": const DebitNoteTransaction()},
      {"title": "Credit Note", "screen": const CreditNoteTransaction()},
    ]
  },
  {
    "title": "Reports",
    "subLinks": [
      {"title": "General", "screen": const GeneralFilters()},
      {"title": "Stock Summary", "screen": const StockSummaryFilters()},
      {"title": "Stock Statement", "screen": const StockStatementFilters()},
      {"title": "GST Summary", "screen": const GSTSummaryFilters()},
      {"title": "GST Detailed Report", "screen": const GSTDetailedFilters()},
      {"title": "HSN_SAC", "screen": const HSNFilters()},
      {"title": "TDS", "screen": const TDSFilters()},
    ]
  },
  {
    "title": "Profile",
    "subLinks": [
      {"title": "Licesense", "screen": const LicenseDetails()},
      {"title": "Transaction", "screen": const TransactionDetails()}
    ]
  },
];

final ScrollController controller0 = ScrollController();
final ScrollController controller1 = ScrollController();
final ScrollController controller2 = ScrollController();
final ScrollController controller3 = ScrollController();

final List<Map> settingsTabs = [
  {"title": "Change No."},
  {"title": "Add Extra Fields in Bills"},
  {"title": "Quotation T & C"},
  {"title": "Payment Terms"},
  {"title": "System Notification"},
];

List<Map> quickViews = [
  {
    "title": "Bank",
  },
  {
    "title": "Cash",
  },
  {
    "title": "Recievables",
  },
  {
    "title": "Pending",
  }
];
