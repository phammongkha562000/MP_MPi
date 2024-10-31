import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mpi_new/presentations/presentations.dart';

import '../../../businesses_logics/bloc/interview/document/document_bloc.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key});

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: "document",
      ),
      body: BlocListener<DocumentBloc, DocumentState>(
        listener: (context, state) {
          if (state is DocumentLoading) {
            MyDialog.showLoading(context: context);
          } else {
            MyDialog.hideLoading(context: context);
          }
        },
        child: BlocBuilder<DocumentBloc, DocumentState>(
          builder: (context, state) {
            if (state is DocumentLoadSuccess) {
              return PDFView(
                filePath: state.fileLocation,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
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
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
