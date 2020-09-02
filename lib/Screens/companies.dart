import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Company.dart';

import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Widgets/CompanyCard.dart';

import '../my_shared_preferences.dart';
import '../my_shared_preferences.dart';
import 'login.dart';

class companiesList extends StatefulWidget {
  List<String> Companies = [];

  companiesList(this.Companies);

  @override
  _companiesListState createState() => _companiesListState();
}

class _companiesListState extends State<companiesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: Container(),
            actions: [
              IconButton(
                onPressed: () async {
                  MySharedPreferences sharedPrefs = new MySharedPreferences();
                  await sharedPrefs.clear();
                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(Icons.exit_to_app),
              ),
            ],
            title: Text('Companies',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold)))),
        body: widget.Companies.length == 0
            ? Center(child: Text('No companies to show'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.Companies.length,
                itemBuilder: (context, index) {
                  var item = widget.Companies[index];

                  return CompanyCard(
                    item: item,
                  );
                }));
  }
}
