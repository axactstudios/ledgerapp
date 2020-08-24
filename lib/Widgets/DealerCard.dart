import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Classes/Dealer.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';

class DealerCard extends StatefulWidget {
  final String CompanyKey;
  const DealerCard({Key key, @required this.item, this.CompanyKey})
      : super(key: key);

  final Dealer item;

  @override
  _DealerCardState createState() => _DealerCardState();
}

class _DealerCardState extends State<DealerCard> {
  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => dealerScreen(
                widget.CompanyKey,
                widget.item.name,
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 15,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 10,),
                Text(
                  widget.item.name,
                  style:GoogleFonts.lato(textStyle:TextStyle(fontSize: pHeight * 0.025), color: kPrimaryColor, fontWeight: FontWeight.bold
                  ),textAlign:  TextAlign.center,),
                SizedBox(
                  height: pHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
