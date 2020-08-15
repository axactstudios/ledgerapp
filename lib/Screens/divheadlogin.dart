import 'package:flutter/material.dart';
import 'DealersList.dart';

class DivHeadLogin extends StatefulWidget {
  static String tag = 'divheadlogin-page';

  @override
  _DivHeadLoginState createState() => _DivHeadLoginState();
}

class _DivHeadLoginState extends State<DivHeadLogin> {
  // ignore: non_constant_identifier_names
  String CompanyKey = '', dealerKey = '';
  bool amazonVal = false;
  bool dellVal = false;
  bool tvsVal = false;
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pw = new TextEditingController(text: '');

  List<String> companies = [];

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
          print(emailC.text);
          if (amazonVal) {
            companies.add('Amazon');
          }
          if (dellVal) {
            companies.add('Dell');
          }
          if (tvsVal) {
            companies.add('TVS');
          }

          print(companies);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => dealerlistScreen(
                companies: companies,
              ),
            ),
          );
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
            Image(
                image: AssetImage('images/divhead.png'),
                height: 0.20 * pHeight),
            SizedBox(height: 12),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8),
            Text('Choose your Company here:',
                style: TextStyle(color: Colors.grey, fontSize: 0.02 * pHeight)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Checkbox(
                  value: amazonVal,
                  onChanged: (bool value) {
                    setState(() {
                      amazonVal = value;
                    });
                  },
                ),
                Text("AMAZON"),
                Checkbox(
                  value: dellVal,
                  onChanged: (bool value) {
                    setState(() {
                      dellVal = value;
                    });
                  },
                ),
                Text("DELL"),
                Checkbox(
                  value: tvsVal,
                  onChanged: (bool value) {
                    setState(() {
                      tvsVal = value;
                    });
                  },
                ),
                Text("TVS"),
              ],
            ),
            SizedBox(height: 8.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
