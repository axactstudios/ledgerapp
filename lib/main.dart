import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'Screens/Distributor.dart';
import 'Screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    distributorScreen.tag: (context) => distributorScreen(),
    DealerLogin.tag: (context) => DealerLogin()
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
      home: HomePage(),
      routes: routes,
    );
  }
}
