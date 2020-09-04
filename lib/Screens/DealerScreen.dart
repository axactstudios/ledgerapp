import 'package:flutter/material.dart';
import 'package:ledgerapp/Classes/Record.dart';
import 'package:ledgerapp/Screens/FilterRecords.dart';
import '../Classes/Constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:csv/csv.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_format/date_format.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import '../my_shared_preferences.dart';
import 'login.dart';

import '../Classes/Constants.dart';
import '../Classes/Constants.dart';

// ignore: must_be_immutable, camel_case_types
class dealerScreen extends StatefulWidget {
  static String tag = 'dealer-page';
  // ignore: non_constant_identifier_names
  String CompanyKey;
  String dealerkey;
  String dealerEmail;

  dealerScreen(this.CompanyKey, this.dealerkey, this.dealerEmail);
  @override
  _dealerState createState() => _dealerState();
}

// ignore: camel_case_types
class _dealerState extends State<dealerScreen> {
  final texteditingcontroller1 = TextEditingController();
  final texteditingcontroller2 = TextEditingController();
  final texteditingcontroller3 = TextEditingController();
  final texteditingcontroller4 = TextEditingController();
  final texteditingcontroller5 = TextEditingController();
  double width;
  bool validated = true;
  String errtext = "";
  String entryedited = "";
  var startdate;
  var enddate;
  double debit = 0;
  double credit = 0;
  double net = 0;

  void convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    formatDate(todayDate, [yyyy, '/', mm, '/', dd]);
  }

  void startDatePicker() async {
    var order1 = await getDate();
    String date;
    setState(() {
      if (order1.month < 10) {
        if (order1.day < 10) {
          date = '0${order1.day}-0${order1.month}-${order1.year}';
        } else {
          date = '${order1.day}-0${order1.month}-${order1.year}';
        }
      } else {
        if (order1.day < 10) {
          date = '0${order1.day}-0${order1.month}-${order1.year}';
        } else {
          date = '${order1.day}-0${order1.month}-${order1.year}';
        }
      }
      startdate = date;

      print("----------------------------------$order1");
      Navigator.pop(context);
      showalertdialog();
    });
  }

  void endDatePicker() async {
    var order2 = await getDate();
    String date;
    setState(() {
      print("----------------------------------$order2");
      if (order2.month < 10) {
        if (order2.day < 10) {
          date = '0${order2.day}-0${order2.month}-${order2.year}';
        } else {
          date = '${order2.day}-0${order2.month}-${order2.year}';
        }
      } else {
        if (order2.day < 10) {
          date = '0${order2.day}-0${order2.month}-${order2.year}';
        } else {
          date = '${order2.day}-0${order2.month}-${order2.year}';
        }
      }
      print(date);
      enddate = date;
      print(date.compareTo('25-08-2020'));
      Navigator.pop(context);
      showalertdialog();
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  Widget bodyData(width) => DataTable(
      columnSpacing: width / 8,
      columns: <DataColumn>[
        DataColumn(
          label: Text('Date'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Date when record added',
        ),
        DataColumn(
          label: Text('Particular'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Add any text',
        ),
        DataColumn(
          label: Text('Debit'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Debitted amount',
        ),
        DataColumn(
          label: Text(
            'Credit',
          ),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Amount creditted',
        ),
      ],
      rows: _rowList);

//  void addentry() async {}

  List<Record> records = [];
  List<DataRow> _rowList = [];

  void getData() {
    records.clear();
    final db = FirebaseDatabase.instance
        .reference()
        .child('Admin')
        .child('Companies')
        .child(widget.CompanyKey)
        .child('Dealers')
        .child(widget.dealerkey)
        .child('Records');
    db.once().then((DataSnapshot snap) async {
      Map<dynamic, dynamic> values = await snap.value;
      values.forEach((key, value) async {
        Record newRecord = Record();
        newRecord.name = await key;
        newRecord.particular = await value['Particular'];
        newRecord.debit = await value['Debit'];
        newRecord.date = await value['Date'];
        newRecord.credit = await value['Credit'];
        print(newRecord.name);
        print(newRecord.credit);
        records.add(newRecord);
        var myDebit = double.parse(newRecord.debit);
        assert(myDebit is double);
        print(myDebit);
        var myCredit = double.parse(newRecord.credit);
        assert(myCredit is double);
        print(myCredit);

        setState(() {
          print(records.length);
          debit = debit + myDebit;
          credit = credit + myCredit;
          net = credit - debit;
          print(records.length);
          _rowList.add(DataRow(cells: <DataCell>[
            DataCell(Text(newRecord.date)),
            DataCell(Text(newRecord.particular)),
            DataCell(Text(newRecord.debit)),
            DataCell(Text(newRecord.credit))
          ]));
        });
      });
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    getData();
    print(widget.CompanyKey);
    print(widget.dealerkey);
    print(widget.dealerEmail);
  }

  void showalertdialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Set Range",
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              startDatePicker();
                            },
                            color: kPrimaryColor,
                            child: startdate == null
                                ? Text("Select Start Date",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Raleway",
                                      color: Colors.white,
                                    ))
                                : Text(
                                    "$startdate",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Raleway",
                                      color: Colors.white,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              endDatePicker();
                            },
                            color: kPrimaryColor,
                            child: enddate == null
                                ? Text("Select End Date",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Raleway",
                                      color: Colors.white,
                                    ))
                                : Text(
                                    "$enddate",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Raleway",
                                      color: Colors.white,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => filterRecord(
                                        startdate,
                                        enddate,
                                        records,
                                        net,
                                        widget.dealerEmail)),
                              );
                            },
                            color: kPrimaryColor,
                            child: Text("SORT",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Raleway",
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double pWidth = MediaQuery.of(context).size.width;
    double pHeight = MediaQuery.of(context).size.height;
    return Container(
      width: pWidth,
      height: pHeight,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: kPrimaryColor),
            backgroundColor: Colors.white,
            title: Text(
              'DEALER',
              style: TextStyle(
                  fontFamily: 'Jost',
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    MySharedPreferences sharedPrefs = new MySharedPreferences();
                    await sharedPrefs.clear();
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(Icons.exit_to_app , color: Colors.black,),
                ),

              IconButton(
                icon: Icon(
                  Icons.import_export,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  _generatePdfAndView(context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.mail_outline,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  sendEmail();
                },
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: records.length == 0
              ? Center(
                  child: Text(
                    "No records to show",
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 24),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Text("Outstanding :",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            SizedBox(
                              height: 2,
                              width: 15,
                            ),
                            Text(net.toString(),
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                          ],
                        ),
                      ),
                      Container(
                          height: pHeight * 0.8,
                          width: pWidth,
                          child: bodyData(pWidth * 0.8)),
                      FloatingActionButton.extended(
                        onPressed: () {
                          showalertdialog();
                        },
                        icon: Icon(Icons.sort),
                        label: Text("Sort"),
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                )),
    );
  }

  sendEmail() async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Column(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                pdfLib.Padding(
                  padding: pdfLib.EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: pdfLib.Row(children: [
                    pdfLib.Text(
                      'Transactions Record',
                      style: pdfLib.TextStyle(
                        fontSize: 35,
                        color: PdfColors.black,
                      ),
                    ),
                  ]),
                ),
                pdfLib.SizedBox(
                  height: 15,
                ),
                pdfLib.Padding(
                  padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: pdfLib.Row(
                      mainAxisAlignment:
                      pdfLib.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfLib.Text(
                          'Date',
                          style: pdfLib.TextStyle(
                            fontSize: 25,
                            color: PdfColors.black,
                          ),
                        ),
                        pdfLib.Text(
                          'Particular',
                          style: pdfLib.TextStyle(
                            fontSize: 25,
                            color: PdfColors.black,
                          ),
                        ),
                        pdfLib.Text(
                          'Debit',
                          style: pdfLib.TextStyle(
                            fontSize: 25,
                            color: PdfColors.black,
                          ),
                        ),
                        pdfLib.Text(
                          'Credit',
                          style: pdfLib.TextStyle(
                            fontSize: 20,
                            color: PdfColors.black,
                          ),
                        ),
                      ]),
                ),
                pdfLib.SizedBox(
                  height: 10,
                  child: pdfLib.Divider(color: PdfColors.black),
                ),
                pdfLib.ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      var item = records[index];
                      return pdfLib.Padding(
                        padding:
                        pdfLib.EdgeInsets.only(top: 2.0, bottom: 2.0),
                        child: pdfLib.Row(
                            mainAxisAlignment:
                            pdfLib.MainAxisAlignment.spaceBetween,
                            children: [
                              pdfLib.Text(
                                item.date,
                                style: pdfLib.TextStyle(
                                  fontSize: 15,
                                  color: PdfColors.black,
                                ),
                              ),
                              pdfLib.Text(
                                item.particular,
                                style: pdfLib.TextStyle(
                                  fontSize: 15,
                                  color: PdfColors.black,
                                ),
                              ),
                              pdfLib.Text(
                                item.debit,
                                style: pdfLib.TextStyle(
                                  fontSize: 15,
                                  color: PdfColors.black,
                                ),
                              ),
                              pdfLib.Text(
                                item.credit,
                                style: pdfLib.TextStyle(
                                  fontSize: 15,
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                      );
                    }),
                pdfLib.SizedBox(
                  height: 10,
                  child: pdfLib.Divider(color: PdfColors.black),
                ),
              ])
        ]));

    String dirt;

    new Directory('/storage/emulated/0/Ledger Exports')
        .create(recursive: true)
        .then((Directory dir) {
      print("My directory path ${dir.path}");
      dirt = dir.path;
      setState(() {
        print('----------------${dir.path} is the destination---------------');
      });
    });

    Map<Permission, PermissionState> permission =
    await PermissionsPlugin.requestPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.READ_EXTERNAL_STORAGE
    ]);

//store file in documents folder

    String filename =
        '${widget.dealerEmail} ${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()} -- ${DateTime.now().hour.toString()}-${DateTime.now().minute.toString()} ';

    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/documents";
    File f = new File('/storage/emulated/0/Ledger Exports/$filename.pdf');

    await f.writeAsBytes(pdf.save());

    final MailOptions mailOptions = MailOptions(
      body: 'Here is your ledger',
      subject: 'Ledger',
      recipients: [widget.dealerEmail],
      isHTML: true,
      attachments: [
        f.path,
      ],
    );

    await FlutterMailer.send(mailOptions);
    Fluttertoast.showToast(
        msg: "Email Sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
              pdfLib.Column(
                  mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: pdfLib.Row(children: [
                        pdfLib.Text(
                          'Transactions Record',
                          style: pdfLib.TextStyle(
                            fontSize: 35,
                            color: PdfColors.black,
                          ),
                        ),
                      ]),
                    ),
                    pdfLib.SizedBox(
                      height: 15,
                    ),
                    pdfLib.Padding(
                      padding: pdfLib.EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfLib.Text(
                              'Date',
                              style: pdfLib.TextStyle(
                                fontSize: 25,
                                color: PdfColors.black,
                              ),
                            ),
                            pdfLib.Text(
                              'Particular',
                              style: pdfLib.TextStyle(
                                fontSize: 25,
                                color: PdfColors.black,
                              ),
                            ),
                            pdfLib.Text(
                              'Debit',
                              style: pdfLib.TextStyle(
                                fontSize: 25,
                                color: PdfColors.black,
                              ),
                            ),
                            pdfLib.Text(
                              'Credit',
                              style: pdfLib.TextStyle(
                                fontSize: 20,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                    ),
                    pdfLib.SizedBox(
                      height: 10,
                      child: pdfLib.Divider(color: PdfColors.black),
                    ),
                    pdfLib.ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          var item = records[index];
                          return pdfLib.Padding(
                            padding:
                                pdfLib.EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: pdfLib.Row(
                                mainAxisAlignment:
                                    pdfLib.MainAxisAlignment.spaceBetween,
                                children: [
                                  pdfLib.Text(
                                    item.date,
                                    style: pdfLib.TextStyle(
                                      fontSize: 15,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pdfLib.Text(
                                    item.particular,
                                    style: pdfLib.TextStyle(
                                      fontSize: 15,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pdfLib.Text(
                                    item.debit,
                                    style: pdfLib.TextStyle(
                                      fontSize: 15,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pdfLib.Text(
                                    item.credit,
                                    style: pdfLib.TextStyle(
                                      fontSize: 15,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ]),
                          );
                        }),
                    pdfLib.SizedBox(
                      height: 10,
                      child: pdfLib.Divider(color: PdfColors.black),
                    ),
                  ])
            ]));

    String dirt;

    new Directory('/storage/emulated/0/Ledger Exports')
        .create(recursive: true)
        .then((Directory dir) {
      print("My directory path ${dir.path}");
      dirt = dir.path;
      setState(() {
        print('----------------${dir.path} is the destination---------------');
      });
    });

    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.requestPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.READ_EXTERNAL_STORAGE
    ]);

//store file in documents folder

    String filename =
        '${widget.dealerEmail} ${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()} -- ${DateTime.now().hour.toString()}-${DateTime.now().minute.toString()} ';

    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/documents";
    File f = new File('/storage/emulated/0/Ledger Exports/$filename.pdf');

    await f.writeAsBytes(pdf.save());
    Fluttertoast.showToast(
        msg: "PDF Saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
    //Navigator.of(context).push(MaterialPageRoute(
    //builder: (_) => PdfViewerPage(path: path),
    //));
  }
}
