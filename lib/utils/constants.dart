import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static getDevice(context) {
    if (MediaQuery.of(context).size.width > 600) {
      return false;
    } else {
      return true;
    }
  }
}

List<String> quickLinks = [
  "Unselected",
  "Party List",
  // "New Party",
  "Banks",
  // "New Bank",
  "Item List",
  "New Item",
  "Quotations",
  "New Quotation",
  // "Bill Prefix",
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

Map quickLinksIcons = {
  "Unselected": Icons.abc,
  "Party List": Icons.business,
  // "New Party": Icons.business,
  "Banks": Icons.corporate_fare_outlined,
  // "New Bank": Icons.corporate_fare_outlined,
  "Item List": Icons.emoji_objects,
  "New Item": Icons.emoji_objects,
  "Quotations": CupertinoIcons.text_justifyleft,
  "New Quotation": CupertinoIcons.text_justifyleft,
  // "Bill Prefix": Icons.abc,
  "Sales": CupertinoIcons.cube_box,
  "New Sale": CupertinoIcons.cube_box,
  "Purchase List": CupertinoIcons.purchased,
  "New Purchase": CupertinoIcons.purchased,
  "Credit Notes": Icons.credit_card_outlined,
  "Debit Notes": Icons.money_off,
  "Journal Vouchers": CupertinoIcons.doc_plaintext,
  "New Journal Voucher": CupertinoIcons.doc_plaintext,
  "Vouchers": CupertinoIcons.tickets,
  "New Voucher": CupertinoIcons.tickets,
  "Outstanding": CupertinoIcons.doc_append,
  "General Report": Icons.all_inbox,
  "Stock Summary": CupertinoIcons.list_bullet,
  "Detailed Stock": CupertinoIcons.list_bullet_below_rectangle,
  "GST TAX Summary": CupertinoIcons.collections,
  "GST Detail": CupertinoIcons.collections_solid,
  "TDS Report": CupertinoIcons.list_bullet_indent,
  "HSN Report": CupertinoIcons.list_dash,
  "Add Extra field": Icons.receipt_long,
  "Change Password": Icons.password,
  "Add Payment Term": Icons.horizontal_split,
  "Change Reference Number": Icons.confirmation_number_outlined,
};

Map quickLinksScreens = {
  "Party List": const PartyMaster(),
  // "New Party": const AddPartyMaster(),
  "Banks": const BankMaster(),
  // "New Bank": const AddBankMaster(),
  "Item List": const ItemMaster(),
  "New Item": const AddItemMasterQL(), //Change this after correction
  "Quotations": const QuotationMaster(),
  "New Quotation": const AddQuotationMasterQL(),
  // "Bill Prefix": const BillMaster(),

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

final List<Map> links = [
  {
    "title": "Master",
    "icon": Icons.dashboard_rounded,
    "subLinks": [
      {"title": "Party", "screen": const PartyMaster(), "icon": Icons.business},
      {
        "title": "Item",
        "screen": const ItemMaster(),
        "icon": Icons.emoji_objects
      },
      {
        "title": "Bank",
        "screen": const BankMaster(),
        "icon": Icons.corporate_fare_outlined
      },
      {
        "title": "Quotation",
        "screen": const QuotationMaster(),
        "icon": CupertinoIcons.text_justifyleft
      },
      // {"title": "Bill Prefix", "screen": const BillMaster(), "icon": Icons.abc}
    ]
  },
  {
    "title": "Transaction",
    "icon": Icons.payments_rounded,
    "subLinks": [
      {
        "title": "Purchase",
        "screen": const PurchaseTransaction(),
        "icon": CupertinoIcons.purchased
      },
      {
        "title": "Sale",
        "screen": const SaleTransaction(),
        "icon": CupertinoIcons.cube_box
      },
      {
        "title": "Receipts",
        "screen": const RecieptsTransaction(),
        "icon": CupertinoIcons.news
      },
      {
        "title": "Expense",
        "screen": const ExpensesTransaction(),
        "icon": CupertinoIcons.money_dollar_circle
      },
      {
        "title": "Voucher",
        "screen": const VoucherTransaction(),
        "icon": CupertinoIcons.tickets
      },
      {
        "title": "Journal Voucher",
        "screen": const JournalVoucherTransaction(),
        "icon": CupertinoIcons.doc_plaintext
      },
      {
        "title": "Outstanding",
        "screen": const OutstandingTransaction(),
        "icon": CupertinoIcons.doc_append
      },
      {
        "title": "Debit Note",
        "screen": const DebitNoteTransaction(),
        "icon": Icons.money_off
      },
      {
        "title": "Credit Note",
        "screen": const CreditNoteTransaction(),
        "icon": Icons.credit_card_outlined
      },
    ]
  },
  {
    "title": "Reports",
    "icon": CupertinoIcons.table,
    "subLinks": [
      {
        "title": "General",
        "screen": const GeneralFilters(),
        "icon": Icons.all_inbox
      },
      {
        "title": "Stock Summary",
        "screen": const StockSummaryFilters(),
        "icon": CupertinoIcons.list_bullet
      },
      {
        "title": "Stock Statement",
        "screen": const StockStatementFilters(),
        "icon": CupertinoIcons.list_bullet_below_rectangle
      },
      {
        "title": "GST Summary",
        "screen": const GSTSummaryFilters(),
        "icon": CupertinoIcons.collections
      },
      {
        "title": "GST Detailed Report",
        "screen": const GSTDetailedFilters(),
        "icon": CupertinoIcons.collections_solid
      },
      {
        "title": "HSN_SAC",
        "screen": const HSNFilters(),
        "icon": CupertinoIcons.list_dash
      },
      {
        "title": "TDS",
        "screen": const TDSFilters(),
        "icon": CupertinoIcons.list_bullet_indent
      },
    ]
  },
  {
    "title": "Profile",
    "icon": CupertinoIcons.person_crop_circle,
    "subLinks": [
      {
        "title": "License",
        "screen": const LicenseDetails(),
        "icon": CupertinoIcons.doc_person
      },
      {
        "title": "Transaction",
        "screen": const TransactionDetails(),
        "icon": CupertinoIcons.list_bullet_indent
      }
    ]
  },
];

final ScrollController controller0 = ScrollController();
final ScrollController controller1 = ScrollController();
final ScrollController controller2 = ScrollController();
final ScrollController controller3 = ScrollController();

final List<Map> settingsTabs = [
  {
    "title": "Change Reference Number",
    "screen": const ChangeRefNoSettings(),
    "icon": Icons.confirmation_number_outlined
  },
  {
    "title": "Adjust Extra Fields in Bills",
    "screen": const ExtraFieldsSetings(),
    "icon": Icons.receipt_long,
  },
  {
    "title": "Add Payment Term",
    "screen": const AddPaymentTermSettings(),
    "icon": Icons.horizontal_split,
  },
  // {
  //   "title": "Change Login PIN",
  //   "screen": const ChangePINSetings(),
  //   "icon": Icons.password,
  // },
];

//Notes in Settings
const String changeRefnoNote =
    "NOTE: Enter number with which you want to start generating record.\n\nEx 1: Starting no. required is 1 than enter 1 in the above input box\n\nEx 2: Starting no. required is 10 than enter 10 in the above input box";
