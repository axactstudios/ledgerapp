import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Dealer.dart';
import 'package:ledgerapp/Widgets/DealerCard.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

class dealerlistScreen extends StatefulWidget {
  static String tag = 'dealerlist-page';
  String divKey, dealerKey;

  dealerlistScreen({this.dealerKey, this.divKey});
  @override
  _dealerlistState createState() => _dealerlistState();
}
class _dealerlistState extends State<dealerlistScreen> {


  List<Dealer> dealers = [];
  void getData() {
    dealers.clear();
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
        Dealer newDealer = Dealer();
        newDealer.name = await value['Name'];
        print(newDealer.name);

        dealers.add(newDealer);
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
    print(widget.dealerKey);
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
        body: dealers.length == 0
            ? Center(
          child: Text(
            "No dealers to show",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
          ),
        )
            : ListView.builder(
            itemCount: dealers.length,
            itemBuilder: (context, index) {
              var item = dealers[index];
              return DealerCard(item: item);
            }),
        );
  }
}




