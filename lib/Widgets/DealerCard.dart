import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Dealer.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';

class DealerCard extends StatefulWidget {
  final String divKey;
  const DealerCard({Key key, @required this.item, this.divKey})
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
                  style:GoogleFonts.lato(textStyle:TextStyle(fontSize: pHeight * 0.03),
                  ),),
                onTap: () {
                  print(widget.divKey);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => dealerScreen(
                        widget.divKey,
                        widget.item.name,
                      ),
                    ),
                  );
                },
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
