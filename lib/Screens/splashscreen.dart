import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Screens/home_page.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    new Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
        backgroundColor: Colors.white,
        body:

        Column(
        mainAxisAlignment:MainAxisAlignment.center ,
        children: <Widget>[
        Expanded(
        flex:2,
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ Padding(
        padding: const EdgeInsets.all(20.0),
    child: Center(
    child: Image.asset(
    'images/ledger.png',
    height: pHeight * 0.20,
    width:pWidth*0.55
    ),
    ),
    ),
    SizedBox(height:20),
    Text('Ledger App',style:GoogleFonts.lato(textStyle:TextStyle(color:kPrimaryColor,fontSize:0.04*pHeight)))

    ],
    )
    ),
    Expanded(
    flex:1,
    child:Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    GFLoader(
    type:GFLoaderType.ios
    )
    ],

    )
    )


    ],
    ),
    );
  }
}
