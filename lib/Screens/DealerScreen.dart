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

// ignore: must_be_immutable, camel_case_types
class dealerScreen extends StatefulWidget {
  static String tag = 'dealer-page';
  // ignore: non_constant_identifier_names
  String CompanyKey;
  String dealerkey;
  String dealerEmail;

  dealerScreen(this.CompanyKey, this.dealerkey,this.dealerEmail);
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
      columnSpacing: width/8,

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
          label: Text('Credit', ),
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

        setState(() {
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
                "Sort the records",
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
                                        startdate, enddate, records, widget.dealerEmail)),
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
      width:pWidth,
      height:pHeight,
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
                icon: Icon(
                  Icons.import_export,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  getCsv();
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
                Container(height:pHeight*0.8,width:pWidth,child: bodyData(pWidth*0.8)),

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
    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();
    row.add('Date');
    row.add('Particulars');
    row.add('Debit');
    row.add('Credit');
    rows.add(row);
    for (int i = 0; i <records.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(records[i].date);
      row.add(records[i].particular);
      row.add(records[i].debit);
      row.add(records[i].credit);
      rows.add(row);
    }

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
        '${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()} -- ${DateTime.now().hour.toString()}-${DateTime.now().minute.toString()} ';

    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/documents";
    File f = new File('/storage/emulated/0/Ledger Exports/$filename.csv');

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    await f.writeAsString(csv);
    Fluttertoast.showToast(
        msg: 'File exported : ${f.path}',
        textColor: Colors.black,
        backgroundColor: Colors.white);
    print('CSV Saved');

    final MailOptions mailOptions = MailOptions(
      body: 'Here is your ledger, $widget.dealerKey',
      subject: 'Ledger',
      recipients: [widget.dealerEmail],
      isHTML: true,
      attachments: [
        f.path,
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  getCsv() async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();
    row.add('Date');
    row.add('Particulars');
    row.add('Debit');
    row.add('Credit');
    rows.add(row);
    for (int i = 0; i < records.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(records[i].date);
      row.add(records[i].particular);
      row.add(records[i].debit);
      row.add(records[i].credit);
      rows.add(row);
    }

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
        '${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()} -- ${DateTime.now().hour.toString()}-${DateTime.now().minute.toString()} ';

    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/documents";
    File f = new File('/storage/emulated/0/Ledger Exports/$filename.csv');

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    Fluttertoast.showToast(
        msg: 'File exported : ${f.path}',
        textColor: Colors.black,
        backgroundColor: Colors.white);
    print('CSV Saved');
  }

}
