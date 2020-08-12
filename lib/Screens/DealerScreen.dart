import 'package:flutter/material.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller1,
                    autofocus: true,
                    onChanged: (_val) {
                      entryedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  TextField(
                    controller: texteditingcontroller2,
                    autofocus: true,
                    onChanged: (_val) {
                      entryedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  TextField(
                    controller: texteditingcontroller3,
                    autofocus: true,
                    onChanged: (_val) {
                      entryedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  TextField(
                    controller: texteditingcontroller4,
                    autofocus: true,
                    onChanged: (_val) {
                      entryedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
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
                                  .child("'${texteditingcontroller1.text}'")
                                  .child('${texteditingcontroller2.text}')
                                  .set({'Record Field 1': texteditingcontroller3.text, 'Record Field 2': texteditingcontroller4.text});

                              addentry();
                            }
                          },
                          color: Colors.transparent,
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
            child: new Icon(Icons.add_box),
            backgroundColor: new Color(0xFFE57373),

        )
    );

  }
}
