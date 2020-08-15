import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Screens/DealersList.dart';

class DivisionHeadCard extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String CompanyKey;
  //final List companies;
  const DivisionHeadCard(
      {Key key,
      // ignore: non_constant_identifier_names
      @required this.item,
      // ignore: non_constant_identifier_names
      this.CompanyKey})
      : super(key: key);

  final Company item;

  @override
  _DivisionHeadCardState createState() => _DivisionHeadCardState();
}

class _DivisionHeadCardState extends State<DivisionHeadCard> {

  List<String> companies=[];
  @override
  void initState() {
    companies.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final pHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Text(
                  widget.item.name,
                  style: TextStyle(fontSize: pHeight * 0.03),
                ),
                onTap: () {
                  companies.clear();
                  companies.add(widget.item.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          dealerlistScreen(

                              companies
                          ),
                    ),
                  );

                }
              ),
              SizedBox(
                height: pHeight * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
