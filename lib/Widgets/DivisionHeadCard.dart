import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Division.dart';

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

  final DivisionHead item;

  @override
  _DivisionHeadCardState createState() => _DivisionHeadCardState();
}

class _DivisionHeadCardState extends State<DivisionHeadCard> {
  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 6,
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
                onTap: () {},
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
