import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Widgets/DivisionHeadCard.dart';
import 'package:ledgerapp/Widgets/DivisionHeadCardAdmin.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';
import '../my_shared_preferences.dart';
import 'login.dart';

// ignore: must_be_immutable, camel_case_types
class divisionheadlistScreen extends StatefulWidget {
  static String tag = 'divisionheadlist-page';
  // ignore: non_constant_identifier_names
  String CompanyKey;
  String dealerKey;

  @override
  _divisionheadlistState createState() => _divisionheadlistState();
}

// ignore: camel_case_types
class _divisionheadlistState extends State<divisionheadlistScreen> {
  List<Company> companies= [];
  void getData() {
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
        print(newCompany.name);
        companies.add(newCompany);
      });
      setState(() {
        print(companies.length);
      });
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    getData();
    print(widget.CompanyKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              MySharedPreferences sharedPrefs = new MySharedPreferences();
              await sharedPrefs.clear();
              await Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.exit_to_app , color: Colors.black,),
          ),
        ],
        title: Text(
          'ADMIN',
          style: TextStyle(
              fontFamily: 'Jost',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: companies.length == 0
          ? Center(
              child: Text(
                "No division heads to show",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                var item = companies[index];
                return DivisionHeadAdminCard(
                  item: item,
                  CompanyKey: widget.CompanyKey,
                );
              }),
    );
  }
}
