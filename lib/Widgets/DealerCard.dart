import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Dealer.dart';

class DealerCard extends StatefulWidget {
  const DealerCard({
    Key key,
    @required this.item,
  }) : super(key: key);

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
              Text(
                widget.item.name,
                style: TextStyle(fontSize: pHeight * 0.03),
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
