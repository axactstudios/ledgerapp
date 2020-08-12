import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';


class DealerLogin extends StatefulWidget {
  static String tag = 'dealerlogin-page';

  @override
  _DealerLoginState createState() => _DealerLoginState();
}

class _DealerLoginState extends State<DealerLogin> {
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pw = new TextEditingController(text: '');
  String holder='';
  String dropdownvalue='Division Head 1';
   List<String> users=[
     'Division Head 1',
     'Division Head 2',
     'Division Head 3'
   ];
   void getDropDownItem(){
     setState(() {
       holder=dropdownvalue;
     });
   }
  @override
  Widget build(BuildContext context) {

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
          print(emailC.text);
          getDropDownItem();
          print('$holder');

          if ('$holder' == 'Division Head 1') {
            final db = FirebaseDatabase.instance.reference().child("Admin").child("Division Heads").child(
                "Division Head 1").child("Dealers");
            db.once().then((DataSnapshot snap) {
              Map<dynamic, dynamic> values = snap.value;
              values.forEach((key, value) async {
                String email = value['Email'];
                print(email);
                print(emailC.text);
                String password = value['Password'].toString();
                print(password);
                print(pw.text);
                if (email == emailC.text &&
                    password == pw.text) {
                  Navigator.of(context).pushNamed(dealerScreen.tag);
                }
              });
            }
            );
          }
          if ('$holder' == 'Division Head 2') {
            final db = FirebaseDatabase.instance.reference().child("Admin").child("Division Heads").child(
                "Division Head 2").child("Dealers");
            db.once().then((DataSnapshot snap) {
              Map<dynamic, dynamic> values = snap.value;
              values.forEach((key, value) async {
                String email = value['Email'];
                print(email);
                print(emailC.text);
                String password = value['Password'].toString();
                print(password);
                print(pw.text);
                if (email == emailC.text &&
                    password == pw.text) {
                  Navigator.of(context).pushNamed(dealerScreen.tag);
                }
              });
            }
            );
          }
          if ('$holder' == 'Division Head 3') {
            final db = FirebaseDatabase.instance.reference().child("Admin").child("Division Heads").child(
                "Division Head 3").child("Dealers");
            db.once().then((DataSnapshot snap) {
              Map<dynamic, dynamic> values = snap.value;
              values.forEach((key, value) async {
                String email = value['Email'];
                print(email);
                print(emailC.text);
                String password = value['Password'].toString();
                print(password);
                print(pw.text);
                if (email == emailC.text &&
                    password == pw.text) {
                  Navigator.of(context).pushNamed(dealerScreen.tag);
                }
              });
            }
            );
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
           Container(padding:EdgeInsets.all(12.0),
           child:DropdownButtonHideUnderline(
             child: DropdownButton<String>(
               value:dropdownvalue,
                 isExpanded: true,
                 hint:Text('Choose your division head'),
               onChanged: ( String value){
                 setState(() {
                   dropdownvalue=value;
                   print(value);
                 });
                 },
                 items:users.map<DropdownMenuItem<String>>((String value){

                     return DropdownMenuItem<String>(
                         value:value,
                         child:Text(value)
                     );
                   }).toList(),




             ),
           )),
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
