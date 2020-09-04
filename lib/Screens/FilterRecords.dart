import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ledgerapp/Classes/Constants.dart';
import 'package:ledgerapp/Classes/Record.dart';
import '../Classes/Constants.dart';
import 'DealerScreen.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

class filterRecord extends StatefulWidget {
  String startdate, enddate;
  String dealerEmail;
  double net;

  List<Record> records = [];

  filterRecord(
      this.startdate, this.enddate, this.records, this.net, this.dealerEmail);

  @override
  _filterRecordState createState() => _filterRecordState();
}

class _filterRecordState extends State<filterRecord> {
  List<Record> filtered = [];
  int i;
  List<DataRow> _rowList = [];

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
  double opening = 0;
  void filterrecords() async {
    print('${widget.startdate}    ${widget.enddate}');
    DateTime startDate = new DateFormat("dd-MM-yyyy").parse(widget.startdate);
    DateTime endDate = new DateFormat("dd-MM-yyyy").parse(widget.enddate);

    for (i = 0; i < widget.records.length; i++) {
      DateTime date =
          new DateFormat("dd-MM-yyyy").parse(widget.records[i].date);
      if ((date == startDate || date == endDate) ||
          ((date.isAfter(startDate)) && (date.isBefore(endDate)))) {
        await filtered.add(widget.records[i]);
        opening = await opening - double.parse(widget.records[i].debit);
        opening = await opening + double.parse(widget.records[i].credit);
      }
    }
    opening = await widget.net - opening;
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
          iconTheme: IconThemeData(color: kPrimaryColor),
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
                        child: bodyData(pWidth * 0.8)),
                  ],
                ),
              ));
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
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      var item = filtered[index];
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
        backgroundColor: Colors.red,
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
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          var item = filtered[index];
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
