import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'DealerScreen.dart';
import 'Distributor.dart';
import 'DivisionHeadScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    /*final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );*/

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
          if (widget.type == 'admin' || widget.type == 'divisionHead') {
            final db = FirebaseDatabase.instance.reference().child("Admin");
            db.once().then((DataSnapshot snapshot) {
              snapshot.value.forEach((key, values) {
                print(values["Email"]);
                print(email.toString());
                if (values["Email"] == emailC.text &&
                    values["Password"] == pw.text) {
                  if(widget.type=='admin') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => distributorScreen(),
                      ),
                    );
                  }
                  else{
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                        builder: (context) => divisionheadScreen(),),);}
                }

              });
            });
          }else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DealerLogin(),),);
          }

        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            //logo,
            //SizedBox(height: 48.0),
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
