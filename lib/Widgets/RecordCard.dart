import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Record.dart';

class RecordCard extends StatefulWidget {
  const RecordCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Record item;

  @override
  _RecordCardState createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Date: ',
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                  Text(
                    widget.item.date,
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Particulars: ',
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                  Text(
                    widget.item.particular,
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Debit: ',
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                  Text(
                    widget.item.debit,
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Credit: ',
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                  Text(
                    widget.item.credit,
                    style: TextStyle(fontSize: pHeight * 0.025),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
