import 'package:flutter/material.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:random_string/random_string.dart';

class dealerScreen extends StatefulWidget {
  static String tag = 'dealer-page';
  @override
  _dealerState createState() => _dealerState();
}

class _dealerState extends State<dealerScreen> {
  final texteditingcontroller1 = TextEditingController();
  final texteditingcontroller2 = TextEditingController();
  final texteditingcontroller3 = TextEditingController();
  final texteditingcontroller4 = TextEditingController();
  final texteditingcontroller5 = TextEditingController();

  bool validated = true;
  String errtext = "";
  String entryedited = "";

  void addentry() async{

  }

  void showalertdialog() {
    texteditingcontroller1.text = "";
    texteditingcontroller2.text = "";
    texteditingcontroller3.text = "";
    texteditingcontroller4.text = "";
    texteditingcontroller5.text = "";

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Entry Details",
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: texteditingcontroller5,
                        decoration: InputDecoration(
                          labelText: "Name",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kPrimaryColor)),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: texteditingcontroller1,
                        decoration: InputDecoration(
                          labelText: "Date",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kPrimaryColor)),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Date';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: texteditingcontroller2,
                        decoration: InputDecoration(
                          labelText: "Particular",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kPrimaryColor)),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Particular';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: texteditingcontroller3,
                        decoration: InputDecoration(
                          labelText: "Debit",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kPrimaryColor)),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Debit';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: texteditingcontroller4,
                        decoration: InputDecoration(
                          labelText: "Credit",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kPrimaryColor)),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Credit';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              final key = randomAlphaNumeric(15);
                              if (texteditingcontroller1.text.isEmpty) {
                                setState(() {
                                  errtext = "Can't Be Empty";
                                  validated = false;
                                });
                              }
                               else {
                                FirebaseDatabase.instance.reference()
                                    .child("Admin")
                                    .child("Division Head")
                                    .child("Dealers")
                                    .child('${texteditingcontroller5.text}')
                                    .child(key)
                                    .set({'Date': texteditingcontroller1.text,
                                         'Particular': texteditingcontroller2.text,
                                         'Debit': texteditingcontroller3.text,
                                         'Credit': texteditingcontroller4.text});

                                addentry();
                              }
                            },
                            color: new Color(0xFFE57373),
                            child: Text("ADD",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Raleway",
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: Colors.white,
        title: Text(
          'DEALER',
          style: TextStyle(
              fontFamily: 'Jost',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "This is the Dealer's Section",
          style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
        ),

      ),
        floatingActionButton: new FloatingActionButton(
            onPressed: showalertdialog,
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: new Color(0xFFE57373),

        )
    );

  }
}
