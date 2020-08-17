import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'DivisionHeadDisplay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  bool _passwordObscured;

  _onAlertWithStylePressed(context) {
    // Reusable alert style
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 100),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        constraints: BoxConstraints.expand(width: 500)
    );

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: "TRY AGAIN",
      desc: "Email and Password do not match.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: kPrimaryColor,
          radius: BorderRadius.circular(10.0),
        ),
      ],
    ).show();
  }

  @override
  void initState() {
    _passwordObscured=true;

  }
  @override
  Widget build(BuildContext context) {
    double pHeight = MediaQuery.of(context).size.height;
    final email = TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final password = TextFormField(
      controller: pw,
      autofocus: false,
      obscureText: _passwordObscured,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon:Icon(Icons.lock),
        suffixIcon:IconButton(
            icon:Icon(
                _passwordObscured?Icons.visibility_off:Icons.visibility,
                color:Colors.grey
            ),
            onPressed:(){
              setState(() {
                _passwordObscured=!_passwordObscured;
              });
            }
        ) ,
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
              else
              {
                _onAlertWithStylePressed(context);
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
