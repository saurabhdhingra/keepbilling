import 'package:flutter/material.dart';
import 'package:keepbilling/screens/dumy.dart';
import 'package:keepbilling/screens/masterPages/export.dart';
import 'package:keepbilling/screens/profilePages/export.dart';
import 'package:keepbilling/screens/settings/export.dart';
import 'package:keepbilling/screens/transactionPages/export.dart';
import 'package:keepbilling/screens/masterPages/addPages/export.dart';
import 'package:keepbilling/screens/masterPages/quickLinkPages/export.dart';
import 'package:keepbilling/screens/transactionPages/quickLinkPages/export.dart';
import '../screens/masterPages/bank.dart';
import '../screens/reports/filtersPages/export.dart';

class SizeConfig {
  static getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}

List<String> quickLinks = [
  "Party List",
  "New Party",
  "Banks",
  "New Bank",
  "Item List",
  "New Item",
  "Quotations",
  "New Quotation",
  "Bill Prefix",
  "Sales",
  "New Sale",
  "Purchase List",
  "New Purchase",
  "Credit Notes",
  "Debit Notes",
  "Journal Vouchers",
  "New Journal Voucher",
  "Vouchers",
  "New Voucher",
  "Outstanding",
  "General Report",
  "Stock Summary",
  "Detailed Stock",
  "GST TAX Summary",
  "GST Detail",
  "TDS Report",
  "HSN Report",
  "Add Extra field",
  "Change Password",
  "Add Payment Term",
  "Change Reference Number"
];

Map quickLinksScreens = {
  "Party List": const PartyMaster(),
  "New Party": const AddPartyMaster(),
  "Banks": const BankMaster(),
  "New Bank": const AddBankMaster(),
  "Item List": const ItemMaster(),
  "New Item": const AddItemMasterQL(), //Change this after correction
  "Quotations": const QuotationMaster(),
  "New Quotation": const AddQuotationMasterQL(),
  "Bill Prefix": const BillMaster(),

  "Sales": const SaleTransaction(),
  "New Sale": const CreateBillQL(billType: 'S'),
  "Purchase List": const PurchaseTransaction(),
  "New Purchase": const CreateBillQL(billType: 'P'),
  "Credit Notes": const CreditNoteTransaction(),
  "Debit Notes": const DebitNoteTransaction(),
  "Journal Vouchers": const JournalVoucherTransaction(),
  "New Journal Voucher": const AddJVTransactionQL(),
  "Vouchers": const VoucherTransaction(),
  "New Voucher": const AddVoucherTransactionQL(),
  "Outstanding": const OutstandingTransaction(),

  "General Report": const GeneralFilters(),
  "Stock Summary": const StockSummaryFilters(),
  "Detailed Stock": const StockStatementFilters(),
  "GST TAX Summary": const GSTSummaryFilters(),
  "GST Detail": const GSTDetailedFilters(),
  "TDS Report": const TDSFilters(),
  "HSN Report": const HSNFilters(),

  "Add Extra field": const ExtraFieldsSetings(),
  "Change Password": const ChangePINSetings(),
  "Add Payment Term": const AddPaymentTermSettings(),
  "Change Reference Number": const ChangeRefNoSettings(),
};

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
      {"title": "License", "screen": const LicenseDetails()},
      {"title": "Transaction", "screen": const TransactionDetails()}
    ]
  },
];

final ScrollController controller0 = ScrollController();
final ScrollController controller1 = ScrollController();
final ScrollController controller2 = ScrollController();
final ScrollController controller3 = ScrollController();

final List<Map> settingsTabs = [
  {"title": "Change Reference Number", "screen": const ChangeRefNoSettings()},
  {
    "title": "Adjust Extra Fields in Bills",
    "screen": const ExtraFieldsSetings()
  },
  {"title": "Set Quick Links", "screen": const QuickLinksSettings()},
  {"title": "Add Payment Term", "screen": const AddPaymentTermSettings()},
  {"title": "Change Login PIN", "screen": const ChangePINSetings()},
];
