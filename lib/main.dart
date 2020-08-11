import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'package:ledgerapp/Screens/login.dart';
import 'Screens/DealerScreen.dart';

import 'Screens/Distributor.dart';
import 'Screens/DivisionHeadScreen.dart';
import 'Screens/home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{

    HomePage.tag: (context) => HomePage(),
    divisionheadScreen.tag: (context) => divisionheadScreen(),
    distributorScreen.tag: (context) => distributorScreen(),
    dealerScreen.tag: (context) => dealerScreen(),
    DealerLogin.tag:(context)=>DealerLogin()
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
