import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Record.dart';
import 'package:ledgerapp/Widgets/RecordCard.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:random_string/random_string.dart';

class dealerScreen extends StatefulWidget {
  static String tag = 'dealer-page';
  String divKey, dealerKey;

  dealerScreen({this.dealerKey, this.divKey});
  @override
  _dealerState createState() => _dealerState();
}

class _dealerState extends State<dealerScreen> {
  bool validated = true;
  String errtext = "";
  String entryedited = "";

  void addentry() async {}

  List<Record> records = [];

  void getData() {
    records.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Division Heads')
        .child(widget.divKey)
        .child('Dealers')
        .child(widget.dealerKey)
        .child('Records');
    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        Record newRecord = Record();
        newRecord.name = await value['Name'];
        newRecord.particular = await value['Particular'];
        newRecord.debit = await value['Debit'];
        newRecord.date = await value['Date'];
        newRecord.credit = await value['Credit'];
        print(newRecord.name);
        print(newRecord.credit);
        records.add(newRecord);
      });
      setState(() {
        print(records.length);
      });
    });
  }

  @override
  void initState() {
    getData();
    print(widget.divKey);
    print(widget.dealerKey);
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
        body: records.length == 0
            ? Center(
          child: Text(
            "No records to show",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
          ),
        )
            : ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              var item = records[index];
              return RecordCard(item: item,
              );
            }),
        );
  }
}
