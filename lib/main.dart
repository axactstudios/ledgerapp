import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'package:ledgerapp/Screens/splashscreen.dart';
import 'Screens/Distributor.dart';
import 'Screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    SplashScreen.tag: (context) => SplashScreen(),
    HomePage.tag: (context) => HomePage(),
    distributorScreen.tag: (context) => distributorScreen(),
    DealerLogin.tag: (context) => DealerLogin(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axact Studios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      initialRoute: SplashScreen.tag,
      routes: routes,
    );
  }
}
