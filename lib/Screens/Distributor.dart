import 'package:flutter/material.dart';

import '../Classes/Constants.dart';

// ignore: camel_case_types
class distributorScreen extends StatefulWidget {
  static String tag = 'admin-page';
  @override
  _distributorState createState() => _distributorState();
}

// ignore: camel_case_types
class _distributorState extends State<distributorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        backgroundColor: Colors.white,
        title: Text(
          'DISTRIBUTOR',
          style: TextStyle(
              fontFamily: 'Jost',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "This is the Distributor's Section",
          style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
        ),
      ),
    );
  }
}
