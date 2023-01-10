import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keepbilling/screens/selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/dashboard.dart';
import '../model/cheque.dart';
import '../model/toDoTask.dart';
import '../widgets/navscreens/quickLink.dart';
import '../widgets/navscreens/quickView.dart';
import '../widgets/navscreens/rowText.dart';
import 'loadingScreens.dart';
import 'navScreens/export.dart';
import 'package:keepbilling/widgets/scrollToHide.dart';
import '../../utils/constants.dart';
import '../../utils/functions.dart';
import '../widgets/bottomBar.dart';

class NavScreen extends StatefulWidget {
  final int currentIndex;
  const NavScreen({Key? key, this.currentIndex = 1}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  bool isLoading = false;
  String userId = "";
  String userName = "";
  String companyId = "";
  List<ToDoTask> toDoData = [];
  List<Cheque> chequeData = [];
  List quickLinks = [];
  Map<String, dynamic> quickViewData = {};

  late ToDoTask deletedItem;

  bool swipeStatus = false;

  DashboardService service = DashboardService();

  removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userName');
  }

  setSwipeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('swipeStatus', true);
    swipeStatus = true;
  }

  Future getData() async {
    //show Loading indicator
    setState(() => isLoading = true);

    //set swipeStatus
    SharedPreferences prefs = await SharedPreferences.getInstance();
    swipeStatus = prefs.getBool('swipeStatus') ?? false;

    //Get user credentials
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    userName = prefs.getString('userName') ?? "";

    //set Data
    toDoData = await service.fetchToDoList(userId, companyId);
    chequeData = await service.fetchChequeList(userId, companyId);
    quickViewData = await service.fetchAllAccounts(userId, companyId);
    quickLinks = await service.fetchQuickLinks(userId, companyId);

    //stop Loading indicator
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  bool isDrawerOpen = false;
  final List<List> _screensData = [
    [
      CupertinoIcons.chat_bubble,
      'Contact\nSupport',
      const Settings(key: PageStorageKey('support'))
    ],
    [
      CupertinoIcons.home,
      'Dashboard',
      const DashboardPage(
        key: PageStorageKey('dashboard'),
      )
    ],
    [
      CupertinoIcons.settings,
      'Settings',
      const Settings(key: PageStorageKey('settings'))
    ],
  ];
  final List<Widget> _screens = [
    const Support(key: PageStorageKey('support')),
    const DashboardPage(
      key: PageStorageKey('dashboard'),
    ),
    const Settings(key: PageStorageKey('settings')),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    getData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return isLoading
        ? dashboardLoading(context)
        : Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ScrolltoHide(
        isDrawerOpen: isDrawerOpen,
        duration: const Duration(milliseconds: 200),
        height: height * 0.1,
        controller: getCurrentController(_currentIndex)!,
        child: BottomBar(
          screens: _screensData,
          setIndex: (int value) => setState(() => _currentIndex = value),
          index: _currentIndex,
        ),
      ),
    );
  }

  //Home Page Starts
  //Home Page Starts
  //Home Page Starts
  //Home Page Starts
  //Home Page Starts
  //Home Page Starts
  Widget homePage(double height, double width) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Text(
              userName,
              style: GoogleFonts.alfaSlabOne(
                color: Colors.black87,
                fontSize: height * 0.015,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => const SelectorPage()),
                ),
              );
            },
          )
        ],
      ),
      drawer: dashboardDrawer(height, theme, width, context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: controller1,
          child: Column(
            children: [
              quickViewsBox(height),
              SizedBox(height: height * 0.02),
              const RowText(
                  text: "Quick Links", color: Color.fromRGBO(16, 196, 161, 1)),
              quickLinksBox(height, width),
              toDoData.isEmpty
                  ? const SizedBox()
                  : SizedBox(height: height * 0.02),
              toDoData.isEmpty ? const SizedBox() : todoListHeading(width),
              toDoData.isEmpty
                  ? const SizedBox()
                  : todoListBox(height, width, userId, companyId),
              const RowText(
                  text: "Cheques to be deposited",
                  color: Color.fromRGBO(16, 196, 161, 1)),
              chequesBox(height, width),
              SizedBox(height: height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox chequesBox(height, width) {
    return SizedBox(
      height: height * 0.08 * chequeData.length,
      width: width * 0.95,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: chequeData.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, int index) {
          return ListTile(
            title: Text(chequeData[index].party),
            subtitle: Text(chequeData[index].amount),
            trailing: Text(chequeData[index].chqDate),
          );
        },
      ),
    );
  }

  SizedBox quickViewsBox(height) {
    return SizedBox(
      height: height * 0.25,
      child: QuickView(
        data: quickViewData,
      ),
    );
  }

  SizedBox todoListBox(height, width, String userId, String companyId) {
    return SizedBox(
      height: height * 0.064 * toDoData.length,
      width: width * 0.95,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: toDoData.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, int index) {
          return Dismissible(
            key: Key(toDoData[index].id),
            background:
                Container(color: Colors.green, child: const Icon(Icons.check)),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                deletedItem = toDoData.removeAt(index);
              });

              int delIndex = index;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Platform.isIOS
                      ? CupertinoAlertDialog(
                          title: const Text('Warning'),
                          content: const Text(
                              'Are you sure you wanna mark this as complete. This can\'t be undone!'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('Yes'),
                              onPressed: () async {
                                await service
                                    .deleteToDo(
                                        deletedItem.id, userId, companyId)
                                    .then((value) {
                                  if (value["type"] == "success") {
                                    if (swipeStatus == false) {
                                      setState(() {
                                        setSwipeStatus();
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(value["message"]),
                                      ),
                                    );
                                  }
                                });
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('Cancel'),
                              onPressed: () {
                                setState(() {
                                  toDoData.insert(delIndex, deletedItem);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )
                      : AlertDialog(
                          title: const Text('Warning'),
                          content: const Text(
                              'Are you sure you wanna mark this as complete. This can\'t be undone!'),
                          actions: [
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                await service
                                    .deleteToDo(
                                        deletedItem.id, userId, companyId)
                                    .then((value) {
                                  if (value["type"] == "success") {
                                    if (swipeStatus == false) {
                                      setState(() {
                                        setSwipeStatus();
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(value["message"]),
                                      ),
                                    );
                                  }
                                });
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                setState(() {
                                  toDoData.insert(delIndex, deletedItem);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                },
              );
            },
            child: ListTile(
              title: Text(
                toDoData[index].descrip,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row todoListHeading(width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: width * 0.04),
        SizedBox(
          width: width * 0.3,
          child: Text(
            "To Do List",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: const Color.fromRGBO(16, 196, 161, 1),
              fontSize: width * 0.055,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        swipeStatus
            ? const SizedBox()
            : SizedBox(
                width: width * 0.5,
                child: Text(
                  "Swipe to mark complete",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ],
    );
  }

  SizedBox quickLinksBox(height, width) {
    return SizedBox(
      height: height * 0.15,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
            width * 0.05, height * 0.02, width * 0.05, height * 0.02),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          key: const PageStorageKey("New Collections"),
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: width * 0.3,
              childAspectRatio: 3.0,
              crossAxisSpacing: width * 0.05,
              mainAxisSpacing: width * 0.05),
          itemCount: min(quickLinks.length, 6),
          itemBuilder: (context, i) => QuickLink(
            text: quickLinks[i],
            screen: quickLinksScreens[quickLinks[i]],
          ),
        ),
      ),
    );
  }

  Drawer dashboardDrawer(height, ThemeData theme, width, BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.1),

            ...links.map(
              (e) => Theme(
                data: theme,
                child: ExpansionTile(
                  key: PageStorageKey<String>(e["title"]),
                  title: Text(e["title"]),
                  textColor: Colors.black87,
                  iconColor: Colors.black87,
                  childrenPadding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                  children: e["subLinks"]
                      .map<Widget>(
                        (i) => ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => i["screen"]),
                              ),
                            );
                          },
                          title: Text(
                            i["title"],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            // ListTile(
            //   title: const Text("Logout"),
            //   onTap: () async {
            //     await removeUserData().then((value) {
            //       setSwipeStatus();
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: ((context) => const SelectorPage())));
            //     });
            //   },
            // )
          ],
        ),
      ),
    );
  }
  //Home Page ends
  //Home Page ends
  //Home Page ends
  //Home Page ends
  //Home Page ends
  //Home Page ends
}
