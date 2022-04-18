import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:karaj/bindings/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static Future<File> saveDocument({
    @required String name,
    @required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

class DynamicContracts extends StatefulWidget {
  @override
  _DynamicContractsState createState() => _DynamicContractsState();
}

class _DynamicContractsState extends State<DynamicContracts> {
  List<pw.Widget> _widgetsList = <pw.Widget>[];
  var myFont;
  var myStyle;
  Map<String, dynamic> contentsVars = {
    "dayName": "الخميس",
    "date": "15 / 12 / 2020",
  };

  @override
  void initState() {
    beforeStart();
    super.initState();
  }

  beforeStart() async {
    var data = await rootBundle.load("assets/font.ttf");
    myFont = pw.Font.ttf(data);
    myStyle = pw.TextStyle(font: myFont);
    startUp();
  }

  Future<void> startUp() async {
    final pdf = pw.Document(deflate: zlib.encode);

    FirebaseFirestore.instance
        .collection("testing")
        .doc("contracts")
        .collection("contracts")
        .doc("WNEMnK2lD46s4foxUZYa")
        .collection("components")
        .orderBy("id", descending: false)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        _widgetsList.clear();
        pdf.addPage(pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            textDirection: pw.TextDirection.rtl,
            build: (pw.Context context) {
              for (var element in value.docs) {
                Map<String, dynamic> doc = element.data();
                print(doc["id"]);
                if (doc["type"] == "text") {
                  _widgetsList.add(_buildText(doc));
                } else if (doc["type"] == "table") {
                  _widgetsList.add(_buildTable(doc));
                }
              }
              _widgetsList.add(pw.Container(height: 25.0, width: Get.width));
              return _widgetsList;
            })); //

        final pdfFile =
            await PdfApi.saveDocument(name: 'testing.pdf', pdf: pdf);

        await OpenFile.open(pdfFile.path);
      }
    });
  }

  pw.Widget _buildText(Map<String, dynamic> doc) {
    String content = _getVarContent(doc["content"]);
    print(" content : $content");
    if (doc["center"] == true) {
      return pw.Center(
        child: pw.Text(content ?? "",
            style: myStyle, textDirection: pw.TextDirection.rtl),
      );
    } else {
      return pw.Container(
          width: Get.width,
          child: pw.Text(content ?? "",
              style: myStyle, textDirection: pw.TextDirection.rtl));
    }
  }

  pw.Widget _buildTable(Map<String, dynamic> doc) {
    List<dynamic> head = doc["head"];
    List<List<dynamic>> bodyList = [];
    List<dynamic> body = doc["body"];
    bodyList.add(body);
    return pw.Table.fromTextArray(
      // border: null,
      cellAlignment: pw.Alignment.centerRight,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.grey,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerLeft,
      },
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        font: myFont,
      ),
      cellStyle: pw.TextStyle(
        //  color: _darkColor,
        fontSize: 10,
        font: myFont,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            //      color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        head.length,
        (col) => head[col],
      ),
      data: List<List<String>>.generate(
        bodyList.length,
        (row) => List<String>.generate(
          head.length,
          (col) => _getVarContent(body[col]),
        ),
      ),
    );
  }

  String _getVarContent(String content) {
    String re = content;
    contentsVars.forEach((key, value) {
      re = re.replaceAll("{{$key}}", value);
      print(re);
    });
    return re;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetsList == null
          ? LoadingScreen(true)
          : SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [Container()],
              ),
            ),
    );
  }
}
