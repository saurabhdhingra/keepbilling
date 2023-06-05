import 'package:flutter/material.dart';
// import 'package:keepbilling/screens/authentication/login.dart';
import 'package:keepbilling/provider/authenticationProvider.dart';
import 'package:keepbilling/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthenticationProvider()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
