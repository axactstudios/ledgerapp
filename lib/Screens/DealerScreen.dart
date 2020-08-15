import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Record.dart';
import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable, camel_case_types
class dealerScreen extends StatefulWidget {
  static String tag = 'dealer-page';
  // ignore: non_constant_identifier_names
  String CompanyKey;
  String dealerkey;

  dealerScreen(this.CompanyKey, this.dealerkey);
  @override
  _dealerState createState() => _dealerState();
}

// ignore: camel_case_types
class _dealerState extends State<dealerScreen> {
  final texteditingcontroller1 = TextEditingController();
  final texteditingcontroller2 = TextEditingController();
  final texteditingcontroller3 = TextEditingController();
  final texteditingcontroller4 = TextEditingController();
  final texteditingcontroller5 = TextEditingController();
  double width;
  bool validated = true;
  String errtext = "";
  String entryedited = "";
  Widget bodyData(width) => DataTable(
      columnSpacing: width /9,

      columns: <DataColumn>[
        DataColumn(
          label: Text('Date'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Date when record added',
        ),
        DataColumn(
          label: Text('Particular'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Add any text',
        ),
        DataColumn(
          label: Text('Debit'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Debitted amount',
        ),
        DataColumn(
          label: Text('Credit'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Amount creditted',
        ),
      ],
      rows: _rowList);

//  void addentry() async {}

  List<Record> records = [];
  List<DataRow> _rowList = [];

  void getData() {
    records.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Companies')
        .child(widget.CompanyKey)
        .child('Dealers')
        .child(widget.dealerkey)
        .child('Records');
    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        Record newRecord = Record();
        newRecord.name = await key;
        newRecord.particular = await value['Particular'];
        newRecord.debit = await value['Debit'];
        newRecord.date = await value['Date'];
        newRecord.credit = await value['Credit'];
        print(newRecord.name);
        print(newRecord.credit);
        records.add(newRecord);

        setState(() {
          print(records.length);
          _rowList.add(DataRow(cells: <DataCell>[
            DataCell(Text(newRecord.date)),
            DataCell(Text(newRecord.particular)),
            DataCell(Text(newRecord.debit)),
            DataCell(Text(newRecord.credit))
          ]));
        });
      });
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    getData();
    print(widget.CompanyKey);
    print(widget.dealerkey);
  }

//  void showalertdialog() {
//    texteditingcontroller1.text = "";
//    texteditingcontroller2.text = "";
//    texteditingcontroller3.text = "";
//    texteditingcontroller4.text = "";
//    texteditingcontroller5.text = "";
//
//    showDialog(
//        context: context,
//        builder: (context) {
//          return StatefulBuilder(builder: (context, setState) {
//            return AlertDialog(
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10.0),
//              ),
//              title: Text(
//                "Add Entry Details",
//              ),
//              content: SingleChildScrollView(
//                child: Column(
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextFormField(
//                        controller: texteditingcontroller5,
//                        decoration: InputDecoration(
//                          labelText: "Name",
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: kPrimaryColor)),
//                        ),
//                        // The validator receives the text that the user has entered.
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Enter your Name';
//                          }
//                          return null;
//                        },
//                      ),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextFormField(
//                        controller: texteditingcontroller1,
//                        decoration: InputDecoration(
//                          labelText: "Date",
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: kPrimaryColor)),
//                        ),
//                        // The validator receives the text that the user has entered.
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Enter Date';
//                          }
//                          return null;
//                        },
//                      ),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextFormField(
//                        controller: texteditingcontroller2,
//                        decoration: InputDecoration(
//                          labelText: "Particular",
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: kPrimaryColor)),
//                        ),
//                        // The validator receives the text that the user has entered.
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Enter Particular';
//                          }
//                          return null;
//                        },
//                      ),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextFormField(
//                        controller: texteditingcontroller3,
//                        decoration: InputDecoration(
//                          labelText: "Debit",
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: kPrimaryColor)),
//                        ),
//                        // The validator receives the text that the user has entered.
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Enter Debit';
//                          }
//                          return null;
//                        },
//                      ),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: TextFormField(
//                        controller: texteditingcontroller4,
//                        decoration: InputDecoration(
//                          labelText: "Credit",
//                          enabledBorder: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: kPrimaryColor)),
//                        ),
//                        // The validator receives the text that the user has entered.
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Enter Credit';
//                          }
//                          return null;
//                        },
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(
//                        top: 10.0,
//                      ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          RaisedButton(
//                            onPressed: () {
//                              final key = randomAlphaNumeric(15);
//                              if (texteditingcontroller1.text.isEmpty) {
//                                setState(() {
//                                  errtext = "Can't Be Empty";
//                                  validated = false;
//                                });
//                              } else {
//                                FirebaseDatabase.instance
//                                    .reference()
//                                    .child("Admin")
//                                    .child('Division Heads')
//                                    .child(widget.divKey)
//                                    .child("Dealers")
//                                    .child(widget.dealerKey)
//                                    .child('Records')
//                                    .child(key)
//                                    .set({
//                                  'Name': texteditingcontroller5.text,
//                                  'Date': texteditingcontroller1.text,
//                                  'Particular': texteditingcontroller2.text,
//                                  'Debit': texteditingcontroller3.text,
//                                  'Credit': texteditingcontroller4.text
//                                });
//
//                                addentry();
//                          }
//                              getData();
//                              Navigator.pop(context);
//                            },
//                            color: new Color(0xFFE57373),
//                            child: Text("ADD",
//                                style: TextStyle(
//                                  fontSize: 18.0,
//                                  fontFamily: "Raleway",
//                                )),
//                          )
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            );
//          });
//        });
//  }

  @override
  Widget build(BuildContext context) {
    double pWidth = MediaQuery.of(context).size.width;
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
        body: records.length == 0
            ? Center(
                child: Text(
                  "No records to show",
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
                ),
              )
            : bodyData(pWidth));
//        floatingActionButton: new FloatingActionButton(
//          onPressed: showalertdialog,
//          elevation: 0.0,
//          child: new Icon(Icons.add),
//          backgroundColor: new Color(0xFFE57373),
//        ));
  }
}
