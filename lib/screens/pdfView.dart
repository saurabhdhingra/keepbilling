import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PdfViewPage extends StatefulWidget {
  final File file;
  const PdfViewPage({Key? key, required this.file}) : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(
          name,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Platform.isIOS ? CupertinoIcons.share : Icons.share),
            onPressed: () async {
              RenderBox? box = context.findRenderObject() as RenderBox;
              await Share.shareXFiles([XFile(widget.file.path)],
                  subject: 'Share PDF',
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          )
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }
}
