import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Widgets/DivisionHeadCard.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

class divisionheadlistScreen extends StatefulWidget {
  static String tag = 'divisionheadlist-page';
  String divKey;
  String dealerKey;
  divisionheadlistScreen( this.divKey);
  @override
  _divisionheadlistState createState() => _divisionheadlistState();
}
class _divisionheadlistState extends State<divisionheadlistScreen> {


  List<DivisionHead> divisionhead = [];
  void getData() {
    divisionhead.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Division Heads');


    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        DivisionHead newDivisionHead = DivisionHead();
        newDivisionHead.name = await key;
        print(newDivisionHead.name);

        divisionhead.add(newDivisionHead);
      });
      setState(() {
        print(divisionhead.length);

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
          'ADMIN',
          style: TextStyle(
              fontFamily: 'Jost',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body: divisionhead.length == 0
          ? Center(
        child: Text(
          "No division heads to show",
          style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
        ),
      )
          : ListView.builder(
          itemCount: divisionhead.length,
          itemBuilder: (context, index) {
            var item = divisionhead[index];
            return DivisionHeadCard(item: item,
              divKey: widget.divKey,
            );
          }),
    );
  }
}




