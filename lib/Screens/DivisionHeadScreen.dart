import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/dealers.dart';

import '../Classes/Constants.dart';

class divisionheadScreen extends StatefulWidget {
  String divKey;
  divisionheadScreen(this.divKey);
  static String tag = 'divisionhead-page';
  @override
  _divisionheadState createState() => _divisionheadState();
}

class _divisionheadState extends State<divisionheadScreen> {
  List<Dealer> dealers=[];
  void getData(){
    dealers.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Division Heads')
        .child(widget.divKey)
        .child('Dealers');
      db.once().then((DataSnapshot snap) async{
        Map<dynamic, dynamic> values = await snap.value;
        values.forEach((key, value) async {
          Dealer newdealers = Dealer();
          newdealers.dealername=await value[key];
          dealers.add(newdealers);
          });
        setState(() {
          print(dealers.length);
        });
      });
  }
  @override
  void initState() {
    getData();
    print(widget.divKey);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: Colors.white,
        title: Text(
          'DIVISION HEAD',
          style: TextStyle(
              fontFamily: 'Jost',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body:  dealers.length == 0
          ? Center(
        child: Text(
          "No records to show",
          style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
        ),
      )
          : ListView.builder(
          itemCount: dealers.length,
          itemBuilder: (context, index) {

          }),
    );
  }
}
