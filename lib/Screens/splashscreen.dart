import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';
import 'package:ledgerapp/Screens/home_page.dart';
import 'package:ledgerapp/Screens/login.dart';

import '../my_shared_preferences.dart';
import 'DealersList.dart';
import 'DivisionHeadDisplay.dart';

class SplashScreen extends StatefulWidget {

  static String tag = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MySharedPreferences prefs = MySharedPreferences();

  @override
  void initState() {
    setScreen();
    super.initState();
  }

  Future setScreen(){
    return Future.delayed(Duration(seconds: 3), () {
      prefs.getText("userType").then((userType) {
        print('userType: $userType');
        userType == null ? userType = "" : userType = userType;

        switch (userType) {
          case "Admin":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => divisionheadlistScreen(),
              ),
            );
            break;

          case "Dealer":
            prefs.getList("DealerDetails").then((list) {
              list.forEach((element) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        dealerScreen(list[0], list[1], list[2]),
                  ),
                );
              });
            });
            break;

          case "DivisionHead":
            prefs.getText("DivKey").then((divKey) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => dealerlistScreen(divKey),
              ),
            ));
            break;

          case "":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
            break;
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Image.asset('images/ledger.png',
                          height: pHeight * 0.20, width: pWidth * 0.55),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Ledger App',
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: kPrimaryColor, fontSize: 0.04 * pHeight)))
                ],
              )),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[GFLoader(type: GFLoaderType.ios)],
              ))
        ],
      ),
    );
  }
}
