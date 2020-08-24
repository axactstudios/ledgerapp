import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Screens/companies.dart';
import 'DealersList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DivHeadLogin extends StatefulWidget {
  static String tag = 'divheadlogin-page';

  @override
  _DivHeadLoginState createState() => _DivHeadLoginState();
}

class _DivHeadLoginState extends State<DivHeadLogin> {
  // ignore: non_constant_identifier_names
  String CompanyKey = '', dealerKey = '';String divname='';
//  bool amazonVal = false;
//  bool dellVal = false;
//  bool tvsVal = false;
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pw = new TextEditingController(text: '');
  bool _passwordObscured;
  List<String> companies = [];

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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double pHeight = MediaQuery.of(context).size.height;
    final email = TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.email),
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
//            print(emailC.text);
//            if (amazonVal) {
//              companies.add('Amazon');
//            }
//            if (dellVal) {
//              companies.add('Dell');
//            }
//            if (tvsVal) {
//              companies.add('TVS');
//            }
//
//            print(companies);

            final db = FirebaseDatabase.instance
                .reference()
                .child("Admin")
                .child("Division Heads");
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
                  companies=List<String>.from(await value['Companies']);
                  setState(() {
                    dealerKey = key;
                    divname=key;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => companiesList(companies),
                    ),
                  );
                }
                else
                {
                  _onAlertWithStylePressed(context);
                }
              });
            });


          },
          padding: EdgeInsets.all(12),
          color: kPrimaryColor,
          child: Text('Log In', style: GoogleFonts.lato(textStyle:TextStyle(color: Colors.white)),
          ),)
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style:GoogleFonts.lato(textStyle:TextStyle(color: Colors.black54),
        ),) ,
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Image(
                image: AssetImage('images/divhead.png'),
                height: 0.20 * pHeight),
            SizedBox(height: 50),
            email,
            SizedBox(height: 8),
            password,
            SizedBox(height: 50),
//            Text('Choose your Company here:',
//                style: TextStyle(color: Colors.grey, fontSize: 0.02 * pHeight)),
//            SizedBox(height: 8),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                Checkbox(
//                  value: amazonVal,
//                  onChanged: (bool value) {
//                    setState(() {
//                      amazonVal = value;
//                    });
//                  },
//                ),
//                Text("AMAZON"),
//                Checkbox(
//                  value: dellVal,
//                  onChanged: (bool value) {
//                    setState(() {
//                      dellVal = value;
//                    });
//                  },
//                ),
//                Text("DELL"),
//                Checkbox(
//                  value: tvsVal,
//                  onChanged: (bool value) {
//                    setState(() {
//                      tvsVal = value;
//                    });
//                  },
//                ),
//                Text("TVS"),
//              ],
//            ),
            SizedBox(height: 8.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
