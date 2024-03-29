import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'package:ledgerapp/Screens/divheadlogin.dart';

import '../Classes/Constants.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    double pHeight = MediaQuery.of(context).size.height;
    double pWidth = MediaQuery.of(context).size.width;

    /*   final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/alucard.jpg'),
        ),
      ),
    );*/

//    final welcome = Padding(
//      padding: EdgeInsets.all(8.0),
//      child: Text(
//        'Welcome Client',
//        style: TextStyle(fontSize: 28.0, color: Colors.white),
//      ),
//    );
//
//    final lorem = Padding(
//      padding: EdgeInsets.all(8.0),
//      child: Text(
//        'Hello',
//        style: TextStyle(fontSize: 16.0, color: Colors.white),
//      ),
//    );
//
//    final body = Container(
//      width: MediaQuery.of(context).size.width,
//      padding: EdgeInsets.all(28.0),
//      decoration: BoxDecoration(
//        gradient: LinearGradient(colors: [
//          Colors.blue,
//          Colors.lightBlueAccent,
//        ]),
//      ),
//      child: Column(
//        children: <Widget>[welcome, lorem],
//      ),
//    );

    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: Text(
            'Welcome',
            style: TextStyle(
                fontFamily: 'Jost',
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()));
                  },
                  child: Container(
                    height: 0.25 * pHeight,
                    width: 0.85 * pWidth,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              Image(
                                  image: AssetImage('images/admin.png'),
                                  height: 0.14 * pHeight),
                              SizedBox(height: 8),
                              Text(
                                'Admin',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 0.03 * pHeight,
                                )),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DivHeadLogin()));
                  },
                  child: Container(
                    height: 0.25 * pHeight,
                    width: 0.85 * pWidth,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Image(
                                  image: AssetImage('images/divhead.png'),
                                  height: 0.14 * pHeight),
                              SizedBox(height: 8),
                              Text(
                                'Division Head',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 0.03 * pHeight,
                                        fontFamily: 'Nunito')),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(DealerLogin.tag);
                  },
                  child: Container(
                    height: 0.25 * pHeight,
                    width: 0.85 * pWidth,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Image(
                                  image: AssetImage('images/dealer.png'),
                                  height: 0.14 * pHeight),
                              SizedBox(height: 8),
                              Text(
                                'Dealer',
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 0.03 * pHeight,
                                        fontFamily: 'Nunito')),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ]),
        ));
  }
}
