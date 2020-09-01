import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Screens/DealersList.dart';
import 'package:ledgerapp/Screens/DealersListAdmin.dart';

class DivisionHeadAdminCard extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String CompanyKey;
  //final List companies;
  const DivisionHeadAdminCard(
      {Key key,
        // ignore: non_constant_identifier_names
        @required this.item,
        // ignore: non_constant_identifier_names
        this.CompanyKey})
      : super(key: key);

  final Company item;

  @override
  _DivisionHeadAdminCardState createState() => _DivisionHeadAdminCardState();
}

class _DivisionHeadAdminCardState extends State<DivisionHeadAdminCard> {

  List<String> companies=[];
  @override
  void initState() {
    companies.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final pHeight = MediaQuery.of(context).size.height;
    double pWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(


        onTap: () {
          companies.clear();
          companies.add(widget.item.name);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  dealerlistadminScreen(
                      companies
                  ),
            ),
          );

        },

        child: Container(
          height: 0.25 * pHeight,
          width: 0.85 * pWidth,
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
                  SizedBox(height:pHeight*0.01),
                  Container(alignment:Alignment.center,
                      child: Text(widget.item.name,
                        textAlign:TextAlign.center,
                        style: GoogleFonts.lato(textStyle:
                        TextStyle(color:kPrimaryColor,fontSize: 0.04*pHeight, fontWeight: FontWeight.bold),
                        ),
                      )
                  ),
                  SizedBox(height:pHeight*0.01)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
