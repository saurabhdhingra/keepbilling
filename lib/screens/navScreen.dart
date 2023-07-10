import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/dumy.dart';
import 'package:keepbilling/screens/selector.dart';
import 'package:keepbilling/screens/settings/changePIN.dart';
import 'package:keepbilling/screens/settings/quickLinks.dart';
import 'package:keepbilling/screens/support.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:keepbilling/widgets/navscreens/quickLinkGrid.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/dashboard.dart';
import '../model/cheque.dart';
import '../model/toDoTask.dart';
import '../provider/authenticationProvider.dart';
import '../widgets/navscreens/quickLink.dart';
import '../widgets/navscreens/quickView.dart';
import '../widgets/navscreens/rowText.dart';
import 'loadingScreens.dart';
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
  bool isQLLoading = false;

  String userId = "";
  String companyName = "";
  String companyId = "";
  String product = "";

  List<ToDoTask> toDoData = [];
  List<Cheque> chequeData = [];
  List quickLinks = [];
  Map<String, dynamic> quickViewData = {};

  late ToDoTask deletedItem;

  bool swipeStatus = false;

  DashboardService service = DashboardService();

  String subject = "";
  String query = "";

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

    //Get user credentials
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;

    //set swipeStatus
    SharedPreferences prefs = await SharedPreferences.getInstance();
    swipeStatus = prefs.getBool('swipeStatus') ?? false;
    companyName = prefs.getString('companyName') ?? "";

    //set Data
    try {
      toDoData = await service.fetchToDoList(userId, companyId, product);
      chequeData = await service.fetchChequeList(userId, companyId, product);
      quickViewData =
          await service.fetchAllAccounts(userId, companyId, product);
      quickLinks = await service.fetchQuickLinks(userId, companyId, product);
      if (quickLinks == [""]) {
        quickLinks = [];
      }
    } catch (e) {
      toDoData = [];
      chequeData = [];
      quickLinks = [];
      quickViewData = {
        "Cash": [
          {"name": "CashBal", "balance": 0}
        ],
        "Bank": [],
        "Purchase": {"Total": 0, "Outstanding": 0},
        "Sales": {"Total": 0, "Outstanding": 0},
        "Expenses": {"Total": 0},
        "Post Dated Cheque": {"Recievable": 0, "Payable": 0}
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    //stop Loading indicator
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  var period = const Duration(seconds: 10);

  Future updateQuickLinks() async {
    setState(() => isQLLoading = true);
    quickLinks = await service.fetchQuickLinks(userId, companyId, product);
    if (quickLinks == [""]) {
      quickLinks = [];
    }
    setState(() => isQLLoading = false);
  }

  final List<List> _screensData = [
    // [
    //   CupertinoIcons.arrow_up_circle,
    //   'Quick Links',
    // ],

    [
      CupertinoIcons.doc,
      'Reports',
    ],
    [
      CupertinoIcons.home,
      'Dashboard',
    ],
    [
      CupertinoIcons.settings,
      'Settings',
    ],
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    getData();
    Timer.periodic(period, (arg) async {
      toDoData = await service.fetchToDoList(userId, companyId, product);
      chequeData = await service.fetchChequeList(userId, companyId, product);
      quickViewData =
          await service.fetchAllAccounts(userId, companyId, product);
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return isLoading
        ? dashboardLoading(context)
        : Scaffold(
            body: selectedScreen(height, width),
            bottomNavigationBar: ScreenTypeLayout(
              mobile: ScrolltoHide(
                duration: const Duration(milliseconds: 200),
                height: height * 0.1,
                controller: getCurrentController(_currentIndex)!,
                child: BottomBar(
                  screens: _screensData,
                  setIndex: (int value) =>
                      setState(() => _currentIndex = value),
                  index: _currentIndex,
                ),
              ),
              tablet: ScrolltoHide(
                duration: const Duration(milliseconds: 200),
                height: height * 0.07,
                controller: getCurrentController(_currentIndex)!,
                child: BottomBar(
                  screens: _screensData,
                  setIndex: (int value) =>
                      setState(() => _currentIndex = value),
                  index: _currentIndex,
                ),
              ),
            ),
          );
  }

  Widget selectedScreen(double height, double width) {
    switch (_currentIndex) {
      // case 0:
      //   return quickLinksPage(height, width);
      case 0:
        return reportsPage();
      case 1:
        return homePage(height, width);
      case 2:
        return settingsPage();
      default:
        return homePage(height, width);
    }
  }

  // Widget quickLinksPage(double height, double width) {
  //   return ScreenTypeLayout(
  //     mobile: isQLLoading
  //         ? infoLoading(context)
  //         : Scaffold(
  //             backgroundColor: const Color.fromARGB(255, 243, 243, 243),
  //             body: SafeArea(
  //               child: SingleChildScrollView(
  //                 controller: controller0,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const TitleText(text: "Quick Links"),
  //                     ...quickLinks.map(
  //                       (e) {
  //                         return QuickLink(
  //                           icon: quickLinksIcons[e],
  //                           text: e,
  //                           screen: quickLinksScreens[e],
  //                           isButton: false,
  //                         );
  //                       },
  //                     ),
  //                     Divider(
  //                       thickness: 2,
  //                       height: height * 0.02,
  //                       indent: width * 0.05,
  //                       endIndent: width * 0.05,
  //                       color: Colors.black87,
  //                     ),
  //                     QuickLink(
  //                       icon: CupertinoIcons.arrow_up_circle,
  //                       text: "Set Quick Links",
  //                       screen: const DumyScreen(),
  //                       isButton: true,
  //                       function: () async {
  //                         var navigationResult = await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) =>
  //                                   const QuickLinksSettings()),
  //                         );
  //                         if (navigationResult == "updated") {
  //                           updateQuickLinks();
  //                         }
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //     tablet: isQLLoading
  //         ? infoLoading(context)
  //         : Scaffold(
  //             backgroundColor: const Color.fromARGB(255, 243, 243, 243),
  //             body: SafeArea(
  //               child: SingleChildScrollView(
  //                 controller: controller0,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const TitleText(text: "Quick Links"),
  //                     ...quickLinks.map(
  //                       (e) {
  //                         return QuickLink(
  //                           icon: quickLinksIcons[e],
  //                           text: e,
  //                           screen: quickLinksScreens[e],
  //                           isButton: false,
  //                         );
  //                       },
  //                     ),
  //                     Divider(
  //                       thickness: 2,
  //                       height: height * 0.02,
  //                       indent: width * 0.05,
  //                       endIndent: width * 0.05,
  //                       color: Colors.black87,
  //                     ),
  //                     QuickLink(
  //                       icon: CupertinoIcons.arrow_up_circle,
  //                       text: "Set Quick Links",
  //                       screen: const DumyScreen(),
  //                       isButton: true,
  //                       function: () async {
  //                         var navigationResult = await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) =>
  //                                   const QuickLinksSettings()),
  //                         );
  //                         if (navigationResult == "updated") {
  //                           updateQuickLinks();
  //                         }
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //   );
  // }

  Widget reportsPage() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleText(text: "Reports"),
              ...links[2]["subLinks"].map(
                (e) {
                  return QuickLink(
                    icon: e["icon"],
                    text: e["title"],
                    screen: e["screen"],
                    isButton: false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsPage() {
    return ScreenTypeLayout(
      mobile: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: controller3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(text: "Settings"),
                ...settingsTabs.map(
                  (e) {
                    return QuickLink(
                      icon: e["icon"],
                      text: e["title"],
                      screen: e["screen"],
                      isButton: false,
                    );
                  },
                ),
                QuickLink(
                  icon: Icons.password,
                  text: "Change Login PIN",
                  screen: const DumyScreen(),
                  isButton: true,
                  function: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Platform.isIOS
                            ? CupertinoAlertDialog(
                                title: const Text('Change Login PIN ?'),
                                content: const Text(
                                    'An OTP will be sent over text.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePINSetings()),
                                      );
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            : AlertDialog(
                                title: const Text('Change Login PIN ?'),
                                content: const Text(
                                    'An OTP will be sent over text.'),
                                actions: [
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePINSetings()),
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                      },
                    );
                  },
                ),
                QuickLink(
                  icon: CupertinoIcons.arrow_up_circle,
                  text: "Set Quick Links",
                  screen: const DumyScreen(),
                  isButton: true,
                  function: () async {
                    var navigationResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuickLinksSettings()),
                    );
                    if (navigationResult == "updated") {
                      updateQuickLinks();
                    }
                  },
                ),
                QuickLink(
                  icon: Icons.person_remove,
                  text: "Remove Account",
                  screen: const DumyScreen(),
                  isButton: true,
                  function: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Platform.isIOS
                            ? CupertinoAlertDialog(
                                title: const Text('Remove account ?'),
                                content: const Text(
                                    'You will have to add the account again by verifying it through OTP sent over text.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      removeUserData().then((value) {
                                        setSwipeStatus();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const SelectorPage())));
                                      });
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            : AlertDialog(
                                title: const Text('Remove account ?'),
                                content: const Text(
                                    'You will have to add the account again by verifying it through OTP sent over text.'),
                                actions: [
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      removeUserData().then((value) {
                                        setSwipeStatus();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const SelectorPage())));
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      tablet: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: controller3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(text: "Settings"),
                ...settingsTabs.map(
                  (e) {
                    return QuickLink(
                      icon: e["icon"],
                      text: e["title"],
                      screen: e["screen"],
                      isButton: false,
                    );
                  },
                ),
                QuickLink(
                  icon: Icons.password,
                  text: "Change Login PIN",
                  screen: const DumyScreen(),
                  isButton: true,
                  function: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Platform.isIOS
                            ? CupertinoAlertDialog(
                                title: const Text('Change Login PIN ?'),
                                content: const Text(
                                    'An OTP will be sent over text.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePINSetings()),
                                      );
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            : AlertDialog(
                                title: const Text('Change Login PIN ?'),
                                content: const Text(
                                    'An OTP will be sent over text.'),
                                actions: [
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePINSetings()),
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                      },
                    );
                  },
                ),
                QuickLink(
                  icon: CupertinoIcons.arrow_up_circle,
                  text: "Set Quick Links",
                  screen: const DumyScreen(),
                  isButton: true,
                  function: () async {
                    var navigationResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuickLinksSettings()),
                    );
                    if (navigationResult == "updated") {
                      updateQuickLinks();
                    }
                  },
                ),
                QuickLink(
                  icon: Icons.person_remove,
                  text: "Remove Account",
                  screen: const DumyScreen(),
                  isButton: true,
                  function: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Platform.isIOS
                            ? CupertinoAlertDialog(
                                title: const Text('Remove account ?'),
                                content: const Text(
                                    'You will have to add the account again by verifying it through OTP sent over text.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      removeUserData().then((value) {
                                        setSwipeStatus();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const SelectorPage())));
                                      });
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            : AlertDialog(
                                title: const Text('Remove account ?'),
                                content: const Text(
                                    'You will have to add the account again by verifying it through OTP sent over text.'),
                                actions: [
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      removeUserData().then((value) {
                                        setSwipeStatus();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const SelectorPage())));
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Home Page Starts
  //Home Page Starts
  Widget homePage(double height, double width) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return ScreenTypeLayout(
      mobile: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Text(
            companyName,
            style: GoogleFonts.alfaSlabOne(
              color: Colors.black87,
              fontSize: height * 0.018,
            ),
          ),
          elevation: 0,
          actions: [
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
        drawer: dashboardDrawer(height, theme, width, context, false),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: controller1,
            child: Column(
              children: [
                quickViewsBox(height, false),
                SizedBox(height: height * 0.02),
                // const RowText(
                //     text: "Quick Links", color: Color.fromRGBO(16, 196, 161, 1)),
                // quickLinksBox(height, width),
                toDoData.isEmpty
                    ? const SizedBox()
                    : SizedBox(height: height * 0.02),
                const RowText(
                    text: "To Do List", color: Color.fromRGBO(16, 196, 161, 1)),

                todoListBox(height, width, userId, companyId, false),
                const RowText(
                    text: "Cheques to be deposited",
                    color: Color.fromRGBO(16, 196, 161, 1)),
                chequesBox(height, width, false),
                ...quickLinksBox(height, width, false),
                SizedBox(height: height * 0.1),
              ],
            ),
          ),
        ),
      ),
      tablet: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Text(
            companyName,
            style: GoogleFonts.alfaSlabOne(
              color: Colors.black87,
              fontSize: height * 0.018,
            ),
          ),
          elevation: 0,
          actions: [
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
        drawer: dashboardDrawer(height, theme, width, context, true),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: controller1,
            child: Column(
              children: [
                quickViewsBox(height, true),
                SizedBox(height: height * 0.02),
                // const RowText(
                //     text: "Quick Links", color: Color.fromRGBO(16, 196, 161, 1)),
                // quickLinksBox(height, width),
                toDoData.isEmpty
                    ? const SizedBox()
                    : SizedBox(height: height * 0.02),
                const RowText(
                    text: "To Do List", color: Color.fromRGBO(16, 196, 161, 1)),

                todoListBox(height, width, userId, companyId, true),
                const RowText(
                    text: "Cheques to be deposited",
                    color: Color.fromRGBO(16, 196, 161, 1)),
                chequesBox(height, width, true),
                ...quickLinksBox(height, width, true),
                SizedBox(height: height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox chequesBox(height, width, bool isTablet) {
    return SizedBox(
      width: width * 0.95,
      child: Column(
        children: chequeData.isEmpty
            ? [
                ListTile(
                  title: Text(
                    "No Cheques to be deposited",
                    style: TextStyle(
                        fontSize: isTablet ? height * 0.02 : height * 0.018),
                  ),
                )
              ]
            : [
                ...chequeData.map(
                  (e) => ListTile(
                    title: Text(e.party),
                    subtitle: Text(e.amount),
                    trailing: Text(e.chqDate),
                  ),
                ),
              ],
      ),
    );
  }

  SizedBox quickViewsBox(height, bool isTablet) {
    return SizedBox(
      height: isTablet ? height * 0.22 : height * 0.25,
      child: QuickView(
        data: quickViewData,
        isTab: isTablet,
      ),
    );
  }

  SizedBox todoListBox(
      height, width, String userId, String companyId, bool isTablet) {
    return SizedBox(
      width: width * 0.95,
      child: Column(
        children: toDoData.isEmpty
            ? [
                ListTile(
                  title: Text(
                    "Todo list empty.",
                    style: TextStyle(
                        fontSize: isTablet ? height * 0.02 : height * 0.018),
                  ),
                )
              ]
            : [
                ...toDoData.map(
                  (e) => Dismissible(
                    key: Key(e.id),
                    background: Container(
                        color: Colors.green, child: const Icon(Icons.check)),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        deletedItem = toDoData.removeAt(toDoData.indexOf(e));
                      });

                      int delIndex = toDoData.indexOf(e);
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
                                            .deleteToDo(deletedItem.id, userId,
                                                companyId, product)
                                            .then((value) {
                                          if (value["type"] == "success") {
                                            if (swipeStatus == false) {
                                              setState(() {
                                                setSwipeStatus();
                                              });
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
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
                                          toDoData.insert(
                                              delIndex, deletedItem);
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
                                            .deleteToDo(deletedItem.id, userId,
                                                companyId, product)
                                            .then((value) {
                                          if (value["type"] == "success") {
                                            if (swipeStatus == false) {
                                              setState(() {
                                                setSwipeStatus();
                                              });
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
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
                                          toDoData.insert(
                                              delIndex, deletedItem);
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
                        e.descrip,
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

  List quickLinksBox(height, width, bool isTablet) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.04, 0, 0, 0),
            child: Text(
              "Quick Links",
              textAlign: TextAlign.start,
              style: GoogleFonts.mukta(
                color: const Color.fromRGBO(16, 196, 161, 1),
                fontSize: isTablet ? width * 0.04 : width * 0.055,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, width * 0.04, 0),
            child: IconButton(
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuickLinksSettings()),
                );
                if (navigationResult == "updated") {
                  updateQuickLinks();
                }
              },
              icon: Icon(Icons.edit, size: isTablet ? width * 0.035 : null),
            ),
          ),
        ],
      ),
      Padding(
        padding:
            EdgeInsetsDirectional.fromSTEB(width * 0.05, 0, width * 0.05, 0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          key: const PageStorageKey("New Collections"),
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: width * 0.4,
              childAspectRatio: isTablet ? 4.0 : 3.0,
              crossAxisSpacing: width * 0.05,
              mainAxisSpacing: isTablet ? width * 0.03 : width * 0.05),
          itemCount: quickLinks.length,
          itemBuilder: (context, i) => QuickLinkGrid(
            icon: quickLinksIcons[quickLinks[i]],
            text: quickLinks[i],
            screen: quickLinksScreens[quickLinks[i]],
            isButton: false,
            isTablet: isTablet,
          ),
        ),
      ),
    ];
    SizedBox(
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
              maxCrossAxisExtent: width * 0.4,
              childAspectRatio: 3.0,
              crossAxisSpacing: width * 0.05,
              mainAxisSpacing: width * 0.05),
          itemCount: quickLinks.length,
          itemBuilder: (context, i) => QuickLink(
            icon: quickLinksIcons[quickLinks[i]],
            text: quickLinks[i],
            screen: quickLinksScreens[quickLinks[i]],
            isButton: false,
          ),
        ),
      ),
    );
  }

  Drawer dashboardDrawer(
      height, ThemeData theme, width, BuildContext context, bool isTablet) {
    return Drawer(
      width: isTablet ? width * 0.6 : width * 0.8,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: isTablet ? height * 0.04 : height * 0.1),
            ...links.map(
              (e) => Theme(
                data: theme,
                child: ExpansionTile(
                  leading: Icon(
                    e["icon"],
                    size: isTablet ? width * 0.04 : width * 0.05,
                  ),
                  key: PageStorageKey<String>(e["title"]),
                  title: Text(e["title"],
                      style: GoogleFonts.mukta(
                          fontSize: isTablet ? height * 0.03 : height * 0.02)),
                  textColor: Colors.black87,
                  iconColor: Colors.black87,
                  childrenPadding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                  children: e["subLinks"]
                      .map<Widget>(
                        (i) => ListTile(
                          leading: Icon(
                            i["icon"],
                            size: isTablet ? width * 0.04 : width * 0.05,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => i["screen"]),
                              ),
                            );
                          },
                          title: Text(i["title"],
                              style:
                                  GoogleFonts.mukta(fontSize: height * 0.02)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.message,
                size: isTablet ? width * 0.04 : width * 0.05,
              ),
              title: Text("Send Feedback",
                  style: GoogleFonts.mukta(fontSize: height * 0.02)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Support()));
              },
            )
          ],
        ),
      ),
    );
  }
  //Home Page ends
  //Home Page ends
  //Home Page ends
}
