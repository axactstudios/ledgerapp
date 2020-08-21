import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Screens/DealersList.dart';

class CompanyCard extends StatefulWidget {
  const CompanyCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final  item;

  @override
  _CompanyCardState createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => dealerlistScreen(widget.item)));
          },
          child: Container(
            height: 0.15 * pHeight,
            width: 0.75 * pWidth,
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
                    SizedBox(height: pHeight * 0.02),
                    Text(
                      widget.item,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: pHeight * 0.030,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor)),
                    ),
                    SizedBox(
                      height: pHeight * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
