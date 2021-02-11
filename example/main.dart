import 'dart:io';
import 'dart:typed_data';

import 'package:docx_template/src/template.dart';
import 'package:docx_template/src/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

///
/// Read file template.docx, produce it and save
///
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData templatedox = await rootBundle.load('assets/dogtempl.docx');
  Uint8List audioUint8List = templatedox.buffer
      .asUint8List(templatedox.offsetInBytes, templatedox.lengthInBytes);
  List<int> audioListInt = audioUint8List.cast<int>();
  final docx = await DocxTemplate.fromBytes(audioListInt);

   Load test image for inserting in docx
   ByteData imagefile = await rootBundle.load('assets/test.jpg');
   Uint8List imagebuff = imagefile.buffer
      .asUint8List(imagefile.offsetInBytes, imagefile.lengthInBytes);
   List<int> testFileContent = imagebuff.cast<int>();

  Content c = Content();
  c
    ..add(TextContent("docname", "Simple docname"))
    ..add(TextContent("passport", "Passport NE0323 4456673"))
    ..add(TableContent("table", [
      RowContent()
        ..add(TextContent("key1", "Paul"))
        ..add(TextContent("key2", "Viberg"))
        ..add(TextContent("key3", "Engineer")),
      RowContent()
        ..add(TextContent("key1", "Alex"))
        ..add(TextContent("key2", "Houser"))
        ..add(TextContent("key3", "CEO & Founder"))
        ..add(ListContent("tablelist", [
          TextContent("value", "Mercedes-Benz C-Class S205"),
          TextContent("value", "Lexus LX 570")
        ]))
    ]))
    ..add(ListContent("list", [
      TextContent("value", "Engine")
        ..add(ListContent("listnested",
            [TextContent("value", "BMW M30"), TextContent("value", "2GZ GE")])),
      TextContent("value", "Gearbox"),
      TextContent("value", "Chassis")
    ]))
    ..add(ListContent("plainlist", [
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Paul"))
            ..add(TextContent("key2", "Viberg"))
            ..add(TextContent("key3", "Engineer")),
          RowContent()
            ..add(TextContent("key1", "Alex"))
            ..add(TextContent("key2", "Houser"))
            ..add(TextContent("key3", "CEO & Founder"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Mercedes-Benz C-Class S205"),
              TextContent("value", "Lexus LX 570")
            ]))
        ])),
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Nathan"))
            ..add(TextContent("key2", "Anceaux"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent(
                "tablelist", [TextContent("value", "Peugeot 508")])),
          RowContent()
            ..add(TextContent("key1", "Louis"))
            ..add(TextContent("key2", "Houplain"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Range Rover Velar"),
              TextContent("value", "Lada Vesta SW Sport")
            ]))
        ])),
    ]))
    ..add(ListContent("multilineList", [
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 1')),
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 2')),
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 3'))
    ]))
    ..add(TextContent('multilineText2', 'line 1\nline 2\n line 3'))
    ..add(ImageContent('img', testFileContent));
  ;
  
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/generated.docx';

    final d = await docx.generate(c);
    final of = File(filePath);
    await of.writeAsBytes(d);
  
    OpenFile.open('${appDocDir.path}/generated.docx');
}
