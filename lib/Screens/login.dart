import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'DivisionHeadDisplay.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  String type;
  LoginPage(this.type);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pw = new TextEditingController(text: '');
  String divKey = '';
  @override
  Widget build(BuildContext context) {
    double pHeight = MediaQuery.of(context).size.height;
    final email = TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final password = TextFormField(
      controller: pw,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
          if (widget.type == 'admin') {
            final db = FirebaseDatabase.instance.reference().child("Admin");
            db.once().then((DataSnapshot snapshot) async {
              String email = await snapshot.value['Email'];
              String password = await snapshot.value['Password'];
              if (email == emailC.text && password == pw.text) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => divisionheadlistScreen(),
                  ),
                );
              }
            });
          } else if (widget.type == 'divisionHead') {
            final db = FirebaseDatabase.instance
                .reference()
                .child('Admin')
                .child('Division Heads');
            db.once().then((DataSnapshot snap) {
              Map<dynamic, dynamic> values = snap.value;
              values.forEach((key, value) async {
                String email = value['Email'];
                print(email);
                print(emailC.text);
                String password = value['Password'].toString();
                print(password);
                print(pw.text);
                if (email == emailC.text && password == pw.text) {
                  print('Match Found');
                  setState(() {
                    divKey = key;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        // builder: (context) => dealerlistScreen(divKey),
                        ),
                  );
                }
              });
            });
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DealerLogin(),
              ),
            );
          }
        },
        padding: EdgeInsets.all(12),
        color: kPrimaryColor,
        child: Text('Log In', style: GoogleFonts.lato(textStyle:TextStyle(color: Colors.white)),)
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style:GoogleFonts.lato(textStyle:TextStyle(color: Colors.black54),
        ),),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            (widget.type == 'admin')
                ? Image(
                    image: AssetImage('images/admin.png'),
                    height: pHeight * 0.20)
                : Image(
                    image: AssetImage('images/divhead.png'),
                    height: pHeight * 0.20),
            //SizedBox(height: 48.0),
            SizedBox(height: 20),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
