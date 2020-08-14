import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Dealer.dart';
import 'package:ledgerapp/Widgets/DealerCard.dart';
import 'divheadlogin.dart';

import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

class dealerlistScreen extends StatefulWidget {
  static String tag = 'dealerlist-page';
  String CompanyKey;
  List<String> companies=[];
  String dealerKey;
  dealerlistScreen( this.CompanyKey, this.companies);
  @override
  _dealerlistState createState() => _dealerlistState();
}
class _dealerlistState extends State<dealerlistScreen> {


  List<Dealer> dealers = [];

  void getData(key) {
    print(key);
  dealers.clear();
  final db = FirebaseDatabase.instance
      .reference()
      .child('Admin')
      .child('Companies')
      .child(key)
      .child('Dealers');

  db.once().then((DataSnapshot snap) async {
  Map<dynamic, dynamic> values = await snap.value;
  values.forEach((key, value) async {
  Dealer newDealer = Dealer();
  newDealer.name = await key;
  print(newDealer.name);

  dealers.add(newDealer);
  });
  setState(() {
  print(dealers.length);

  });
  });
  }

String key='';
  @override
  void initState() {
    for(int i=0;i<widget.companies.length;i++) {
      key=widget.companies[i];
      getData(key);
      print(widget.CompanyKey);
      print(key);
    }
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
            : {for(int i = 0 ; i < widget.companies.length ; i++){
          Text(
            widget.companies[i],
            style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
          ),
          ListView.builder(
              itemCount: dealers.length,
              itemBuilder: (context, index) {
                var item = dealers[index];
                return DealerCard(item: item,
                  divKey: widget.companies[i],
                );
              }),
        }}
    );
  }
}




