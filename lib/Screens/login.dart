import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Screens/DealersList.dart';
import 'package:ledgerapp/Screens/dealerlogin.dart';
import 'package:ledgerapp/my_shared_preferences.dart';
import 'DealerScreen.dart';
import 'DivisionHeadDisplay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  String type = '';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = new TextEditingController(text: '');
  TextEditingController passwordController =
      new TextEditingController(text: '');
  String divKey = '';
  bool _passwordObscured;
  String CompanyKey = '', dealerKey = '';
  List<Company> companies = [];
  MySharedPreferences prefs = MySharedPreferences();
  String userType="userType";

  void getCompanies() {
    final db =
        FirebaseDatabase.instance.reference().child('Admin').child('Companies');
    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        Company newCompany = Company();
        newCompany.name = await key;
        setState(() {
          companies.add(newCompany);
        });
        CompanyKey = newCompany.name;
        print(CompanyKey);
        setState(() {
          print(companies.length);
        });
      });
    });
  }

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
        constraints: BoxConstraints.expand(width: 500));

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

  _loginUser() {
    var loginSuccess = false;

    final db = FirebaseDatabase.instance.reference().child("Admin");

    db.once().then((DataSnapshot snapshot) async {
      String adminEmail = await snapshot.value['Email'];
      String adminPassword = await snapshot.value['Password'];

      //Admin Login Check
      if (adminEmail == emailController.text &&
          adminPassword == passwordController.text) {
        loginSuccess = true;
        prefs.saveText(userType, "Admin");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => divisionheadlistScreen(),
          ),
        );
      }

      for (int i = 0; i < companies.length; i++) {
        //Dealers Login Check
        print('dealer: ' + companies[i].name);
        db
            .child('Companies')
            .child(companies[i].name)
            .child('Dealers')
            .once()
            .then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, value) async {
            String dealerEmail = value['Email'];
            String dealerPassword = value['Password'].toString();
            print(
                'Dealer email: $dealerEmail ,Dealer password: $dealerPassword');
            String name = await value['Name'];

            if (dealerEmail == emailController.text &&
                dealerPassword == passwordController.text) {
              print('dealer with similar creds found');

              divKey = key;
              loginSuccess = true;

              print('divKey : $divKey');
              print('name : $name');
              dealerKey = name;
              dealerEmail = emailController.text;
              CompanyKey = companies[i].name;

              prefs.saveText(userType, "Dealer");
              prefs.setList("DealerDetails",[CompanyKey,dealerKey,dealerEmail]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      dealerScreen(CompanyKey, dealerKey, dealerEmail),
                ),
              );
            }
          });
        });
      }

      //Division head Login Check
      db.child('Division Heads').once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          String divHeadEmail = value['Email'];
          String divHeadPassword = value['Password'].toString();
          print(
              'Div-Head email: $divHeadEmail ,Div-Head password: $divHeadPassword');

          if (divHeadEmail == emailController.text &&
              divHeadPassword == passwordController.text) {
            print('Division Head with similar creds found');
            divKey = key;
            loginSuccess = true;

            print('divKey : $divKey');

            prefs.saveText(userType, "DivisionHead");
            prefs.saveText(divKey, "DivKey");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => dealerlistScreen(divKey),
              ),
            );
          }
        });
      });
    }).then((value) {
      print('login success:' + loginSuccess.toString());
      loginSuccess == false ? _onAlertWithStylePressed(context) : null;
    });
  }

  @override
  void initState() {
    _passwordObscured = true;
    getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    double pHeight = MediaQuery.of(context).size.height;
    final email = TextFormField(
      controller: emailController,
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
      controller: passwordController,
      autofocus: false,
      obscureText: _passwordObscured,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
            icon: Icon(
                _passwordObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey),
            onPressed: () {
              setState(() {
                _passwordObscured = !_passwordObscured;
              });
            }),
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
          onPressed: _loginUser,
          padding: EdgeInsets.all(12),
          color: kPrimaryColor,
          child: Text(
            'Log In',
            style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
          )),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: GoogleFonts.lato(
          textStyle: TextStyle(color: Colors.black54),
        ),
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
