import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Classes/Company.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DealerLogin extends StatefulWidget {
  static String tag = 'dealerlogin-page';

  @override
  _DealerLoginState createState() => _DealerLoginState();
}

class _DealerLoginState extends State<DealerLogin> {
  // ignore: non_constant_identifier_names
  String CompanyKey = '', dealerKey = '';
  bool _passwordObscured;
  String dealerEmail;
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pw = new TextEditingController(text: '');
  String holder = '';
  String dropdownvalue = 'Amazon';
  List<String> users = ['Amazon', 'TVS', 'Dell'];
  List<Company> companies = [];
  String email,password;

  void getDropDownItem() {
    setState(() {
    //  CompanyKey = dropdownvalue;
      holder = dropdownvalue;
    });
  }

  void getCompanies() {
    companies.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Companies');
    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        Company newCompany = Company();
        newCompany.name = await key;
        print(key);
        print(newCompany.name);
        print("sgsfxbxhddhxfbd");
        companies.add(newCompany);
        CompanyKey = newCompany.name;
        print(CompanyKey);
        setState(() {
          print(companies.length);
        });
      });

    });
  }
  void verifyDealer() {
    for (int i = 0; i < companies.length; i++) {
      final db = FirebaseDatabase.instance
          .reference()
          .child("Admin")
          .child("Companies")
          .child(companies[i].name)
          .child("Dealers");
      db.once().then((DataSnapshot snap) {
        Map<dynamic, dynamic> values = snap.value;
        values.forEach((key, value) async {
           email = value['Email'];
          print(email);
          print(emailC.text);
           password = value['Password'].toString();
          print(password);
          print(pw.text);
          if (email == emailC.text && password == pw.text) {
            setState(() {
              dealerKey = key;
              dealerEmail = emailC.text;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    dealerScreen(CompanyKey, dealerKey, dealerEmail),
              ),
            );
          }
          else{
            print("Not found");
          }
        });
      });
    }
if(emailC.text!=email||password!=password){
  _onAlertWithStylePressed(context);
}


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

    getCompanies();
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
        prefixIcon:Icon( Icons.email),
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
        prefixIcon: Icon(Icons.lock),
        hintText: 'Password',
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
          print(emailC.text);
          print(pw.text);
         // getDropDownItem();
//          print('$holder');
          verifyDealer();

       /*   if ('$holder' == 'Amazon') {
            final db = FirebaseDatabase.instance
                .reference()
                .child("Admin")
                .child("Companies")
                .child("Amazon")
                .child("Dealers");
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
                  setState(() {
                    dealerKey = key;
                    dealerEmail=emailC.text;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => dealerScreen(CompanyKey, dealerKey,dealerEmail),
                    ),
                  );
                }
                else
                  {
                    _onAlertWithStylePressed(context);
                  }
              });
            });
          }
          if ('$holder' == 'TVS') {
            final db = FirebaseDatabase.instance
                .reference()
                .child("Admin")
                .child("Companies")
                .child("TVS")
                .child("Dealers");
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
                  setState(() {
                    dealerKey = key;
                    dealerEmail=emailC.text;});
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => dealerScreen(CompanyKey, dealerKey,dealerEmail),
                    ),
                  );
                }
                else
                {
                  _onAlertWithStylePressed(context);
                }
              });
            });
          }
          if ('$holder' == 'Dell') {
            final db = FirebaseDatabase.instance
                .reference()
                .child("Admin")
                .child("Companies")
                .child("Dell")
                .child("Dealers");
            db.once().then((DataSnapshot snap) {
              Map<dynamic, dynamic> values = snap.value;
              values.forEach((key, value) async {
                String email = value['Email'];
                print(email);
                print(emailC.text);
                String password = value['Password'].toString();
                print(password);
                print(pw.text);
                if (email == emailC.text && password == pw.text)
                {
                  setState(() {
                    dealerKey = key;
                    dealerEmail=emailC.text;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => dealerScreen(CompanyKey, dealerKey, dealerEmail),
                    ),
                  );
                }
                else
                {
                  _onAlertWithStylePressed(context);
                }
              });
            });
          }*/
        },
        padding: EdgeInsets.all(12),
        color: kPrimaryColor,
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
            Image(
                image: AssetImage('images/dealer.png'), height: 0.20 * pHeight),
            SizedBox(height:30),
//            Text('Choose your company here:',style:TextStyle(color:Colors.grey)),
//            SizedBox(height:10),
            /*Container(
                padding: EdgeInsets.all(12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownvalue,
                    isExpanded: true,
                    hint: Text('Choose your Company here'),
                    onChanged: (String value) {
                      setState(() {
                        dropdownvalue = value;
                        print(value);
                      });
                    },
                    items: users.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                  ),
                )
            ),*/
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
