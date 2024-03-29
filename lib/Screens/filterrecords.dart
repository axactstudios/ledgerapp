import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ledgerapp/Classes/Record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerapp/Classes/Constants.dart';

class filterRecord extends StatefulWidget {
  String startdate, enddate;String dealerEmail;
  List<Record> records = [];
  double net;
  filterRecord(this.startdate, this.enddate, this.records,this.net,this.dealerEmail);


  @override
  _filterRecordState createState() => _filterRecordState();
}

class _filterRecordState extends State<filterRecord> {
  List<Record> filtered = [];
  int i;
  List<DataRow> _rowList = [];
  double opening=0;


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
          tooltip: 'Debited amount',
        ),
        DataColumn(
          label: Text('Credit'),
          numeric: false,
          onSort: (i, b) {},
          tooltip: 'Amount credited',
        ),
      ],
      rows: _rowList);

  void filterrecords() async {
    print('${widget.startdate}    ${widget.enddate}');
    DateTime startDate = new DateFormat("dd-MM-yyyy").parse(widget.startdate);
    DateTime endDate = new DateFormat("dd-MM-yyyy").parse(widget.enddate);

    for (i = 0; i < widget.records.length; i++) {
      DateTime date =
      new DateFormat("dd-MM-yyyy").parse(widget.records[i].date);
      if ((date == startDate || date == endDate) ||
          ((date.isAfter(startDate)) && (date.isBefore(endDate)))) {
        filtered.add(widget.records[i]);

      try{
        opening =  opening - double.parse(widget.records[i].debit);
        opening =  opening + double.parse(widget.records[i].credit);
      }catch(e){print(e);};

      }
    }
    print(widget.net);

    try{
      opening =  widget.net - opening;
    }catch(e){print(e);}

    for (int i = 0; i < filtered.length; i++) {
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(Text(filtered[i].date)),
        DataCell(Text(filtered[i].particular)),
        DataCell(Text(filtered[i].debit)),
        DataCell(Text(filtered[i].credit))
      ]));
    }

    setState(() {
      print(filtered.length);
    });
  }


  @override
  void initState() {
    filterrecords();
    print(widget.dealerEmail);
  }

  @override
  Widget build(BuildContext context) {
    double pWidth = MediaQuery.of(context).size.width;
    double pHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Filtered Records',
            style: GoogleFonts.lato(
                textStyle: TextStyle(color: kPrimaryColor, fontSize: 24)),
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
        body: filtered.length == 0
            ? Center(
            child: Text("No records to show",
                style:
                GoogleFonts.lato(textStyle: TextStyle(fontSize: 24))))
            : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text("Opening Balance :",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(
                      height: 2,
                      width: 15,
                    ),
                    Text(opening.toString(),
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Text("Outstanding :",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(
                      height: 2,
                      width: 15,
                    ),
                    Text(widget.net.toString(),
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),
              Container(
                  height: pHeight * 0.7,
                  width: pWidth,
                  child: bodyData(pWidth)),
            ],
          ),
        ));
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
    for (int i = 0; i < filtered.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(filtered[i].date);
      row.add(filtered[i].particular);
      row.add(filtered[i].debit);
      row.add(filtered[i].credit);
      rows.add(row);
    }

    String dirt;

    new Directory('/storage/emulated/0/LedgerApp Exports')
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
    File f = new File('/storage/emulated/0/LedgerApp Exports/$filename.csv');

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    Fluttertoast.showToast(
        msg: 'File exported : ${f.path}',
        textColor: Colors.black,
        backgroundColor: Colors.white);
    print('CSV Saved');
  }

  sendEmail() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();
    row.add('Date');
    row.add('Particulars');
    row.add('Debit');
    row.add('Credit');
    rows.add(row);
    for (int i = 0; i < filtered.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(filtered[i].date);
      row.add(filtered[i].particular);
      row.add(filtered[i].debit);
      row.add(filtered[i].credit);
      rows.add(row);
    }

    String dirt;

    new Directory('/storage/emulated/0/LedgerApp Exports')
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
    File f = new File('/storage/emulated/0/LedgerApp Exports/$filename.csv');

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    await f.writeAsString(csv);
    Fluttertoast.showToast(
        msg: 'File exported : ${f.path}',
        textColor: Colors.black,
        backgroundColor: Colors.white);
    print('CSV Saved');

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
  }
}
