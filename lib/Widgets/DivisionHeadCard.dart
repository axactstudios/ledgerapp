import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Division.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';
import 'package:ledgerapp/Screens/DivisionHeadDisplay.dart';
import 'package:ledgerapp/Screens/DealersList.dart';

class DivisionHeadCard extends StatefulWidget {
  final String divKey;
  const DivisionHeadCard({
    Key key,
    @required this.item,this.divKey
  }) : super(key: key);

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
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => dealerlistScreen(
                         widget.item.name
                      ),
                    ),
                  );


                }, ),
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