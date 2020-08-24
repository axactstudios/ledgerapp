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
  String company;
  dealerlistScreen( this.company);
  @override
  _dealerlistState createState() => _dealerlistState();
}

// ignore: camel_case_types
class _dealerlistState extends State<dealerlistScreen> {
  List<Dealer> dealers = [];
  List<Dealer> newDealers = List();
  List<Dealer> filteredDealers = List();
String dealerEmail;

  void getData() {
    dealers.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Companies')
        .child(widget.company)
        .child('Dealers');

    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        Dealer newDealer = Dealer();
        newDealer.name = await key;
        newDealer.email=await value['Email'];
        print(newDealer.name);
        print(newDealer.email);
         setState(() {
           dealerEmail=newDealer.email;
         });
        dealers.add(newDealer);
      });
      setState(() {
        print(dealers.length);
        dealers.clear();

        newDealers = dealers;
        filteredDealers = dealers;
      });
    });
  }

  String key = '';

  @override
  // ignore: must_call_super
  void initState() {
    print(widget.company);
print(dealerEmail);

    getData();
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
              style: GoogleFonts.lato(textStyle: TextStyle(

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
            : Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    prefixIcon: Icon(Icons.search, color: Colors.white
                      ,),
                    hintText: 'Enter dealer name',
                    hintStyle: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white))
                ),
                onChanged: (string) {
                  setState(() {
                    filteredDealers = newDealers.where((d) =>
                        d.name.toLowerCase().contains(string.toLowerCase()))
                        .toList();
                  });
                }
            ),

            ListView.builder(
                shrinkWrap: true,
                itemCount: filteredDealers.length,
                itemBuilder: (context, index2) {
                  var item = filteredDealers[index2];
                  var email=filteredDealers[index2];

                  return DealerCard(
                    item: item,
                    CompanyKey: widget.company,
                    email: email,
                  );
                }),


          ],
        ));
  }
}
