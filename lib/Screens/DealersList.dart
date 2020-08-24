import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Dealer.dart';
import 'package:ledgerapp/Widgets/DealerCard.dart';
import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable, camel_case_types
class dealerlistScreen extends StatefulWidget {
  static String tag = 'dealerlist-page';
  // ignore: non_constant_identifier_names
  List<String> companies = [];
  dealerlistScreen( this.companies);
  @override
  _dealerlistState createState() => _dealerlistState();
}

// ignore: camel_case_types
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
        dealers.clear();
      });
    });
  }

  String key = '';
  @override
  // ignore: must_call_super
  void initState() {
    print(widget.companies);
    for (int i = 0; i < widget.companies.length; i++) {
      key = widget.companies[i];
      getData(key);

      print(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kPrimaryColor),
          backgroundColor: Colors.white,
          title: Text(
            'DIVISION HEAD',
            style: GoogleFonts.lato(textStyle:TextStyle(

                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
            ),)
        ),
        body: dealers.length == 0
            ? Center(
                child: Text(
                  "No dealers to show",
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
                ),
              )
            : ListView.builder(
                itemCount: widget.companies.length,
                itemBuilder: (context, index) {
                  return Column(children: <Widget>[
                    SizedBox(height: 20,),
                    Text(
                      widget.companies[index],
                      style: GoogleFonts.raleway(textStyle:TextStyle( fontSize: 32), color: Colors.white,fontWeight: FontWeight.bold,
                      ),),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dealers.length,
                        itemBuilder: (context, index2) {
                          var item = dealers[index2];
                          return DealerCard(
                            item: item,
                            divKey: widget.companies[index],
                          );
                        }),
                  ]);
                }));
  }
}
