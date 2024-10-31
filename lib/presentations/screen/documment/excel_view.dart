import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';

class ExcelView extends StatefulWidget {
  const ExcelView({
    Key? key,
    required this.path,
  }) : super(key: key);
  final String path;
  @override
  State<ExcelView> createState() => _ExcelViewState();
}

class _ExcelViewState extends State<ExcelView> {
  var _openResult = 'Unknown';
  Future<void> openFile() async {
    // final filePath = '/storage/emulated/0/update.apk';
    final result = await OpenFile.open(
      widget.path,
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('XLSX Viewer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('open result: $_openResult\n'),
            TextButton(
              onPressed: openFile,
              child: const Text('Tap to open file'),
            ),
          ],
        ),
      ),
    );
  }
}
