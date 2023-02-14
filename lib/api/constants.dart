class ApiService {
  String get backend => "https://app.bmscomputers.com/APIs/";

  //Authentication APIs
  String get login => "login.php?type=pin";
  String get sendOTP => "login.php?type=sendotp";
  String get verifyOTP => "login.php?type=verifyotp";

  //Dashboard
  String get chequeList => "dashboard.php?type=cheqdeposit";
  String get todoList => "todo.php?type=all";
  String get editToDoList => "todo.php?type=edittodo";
  String get quickViews => "dashboard.php?type=allcounts";
  String get quickLinks => "dashboard.php?type=user_quicklinks";

  //Master Pages
  String get party => "party.php?type=all";
  String get credDeb => "party.php?type=cred_deb";
  String get item => "item.php?type=all";
  String get bank => "bank.php?type=all";
  String get quotation => "quotation.php?type=all";
  String get billprefix => "billprefix.php?type=all";
  String get itemGroups => "item.php?type=allgroup";
  String get units => "item.php?type=allunit";

  //Add on master pages
  String get addParty => "party.php?type=addparty";
  String get addItem => "item.php?type=additem";
  String get addBank => "bank.php?type=addbank";
  String get addQuotation => "quotation.php?type=addquot";

  //Edit on Master Pages
  String get editBank => "bank.php?type=edit_bank";
  String get editParty => "party.php?type=editparty";
  String get editItem => "item.php?type=edit_item";
  String get editQuotation => "quotation.php?type=editquot";

  //Transaction Pages
  String get bills => "bills.php?type=";
  String get ledgers => "ledger.php?type=all";
  String get billById => "bills.php?type=getbill_byid";

  //Add on transaction pages
  String get createBill => "bills.php?type=addbill";
  String get addJournalVoucher => "bills.php?type=add_JV";
  String get addVoucher => "bills.php?type=add_voucher";

  //Edit on transaction pages
  String get editBill => "bills.php?type=editdbill";
  String get editVoucher => "bills.php?type=edit_voucher";
  String get editJV => "bills.php?type=edit_JV";

  //Bill PDF generation
  String get pdf => "bills.php?type=bill_pdf";

  //Reports pages
  String get generalReport => "reports.php?type=general_report";
  String get stockStatement => "reports.php?type=stock_statement";
  String get stockSummary => "reports.php?type=stock_summary";
  String get hsnReport => "reports.php?type=hsnreport";
  String get gstSummary => "reports.php?type=gstsummary_report";
  String get gstDetailed => "reports.php?type=gstdetail_report";
  String get tdsReport => "reports.php?type=tds_report";

  //Profile Pages
  String get license => "profile.php?type=licence_detail";
  String get transactions => "profile.php?type=licence_transaction";
  String get company => "profile.php?type=company_detail";

  //Settings Pages
  String get refrenceNo => "settings.php?type=referenceno";
  String get setQuickLinks => "settings.php?type=set_quicklinks";
  String get setPaymentTerms => "settings.php?type=set_payment_terms";
  String get extraFields => "settings.php?type=set_extrafields";
  String get otpChangePin => "settings.php?type=otpfor_pin";
  String get verifyChange => "settings.php?type=verify_pinotp";

  //Send Feedback
  String get contact => "connect.php?type=contactsupport";
}
