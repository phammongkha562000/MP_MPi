import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart' as pdf;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key, required this.path});
  final String path;
  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Viewer'),
        ),
        body: pdf.PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onRender: (pages) {
            setState(() {});
          },
          onError: (error) {
            log(error.toString());
          },
          onPageError: (page, error) {
            log('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            // interact with PDF controller
          },
        ));
  }
}
