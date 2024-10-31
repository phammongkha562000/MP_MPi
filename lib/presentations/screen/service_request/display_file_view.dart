import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/data.dart';

class DisplayFileView extends StatefulWidget {
  const DisplayFileView({super.key});

  @override
  State<DisplayFileView> createState() => _DisplayFileViewState();
}

class _DisplayFileViewState extends State<DisplayFileView> {
  final _navigationService = getIt<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: 'attachment',
      ),
      body: BlocConsumer<DisplayFileBloc, DisplayFileState>(
        listener: (context, state) async {
          if (state is DisplayFileDownloadSuccess) {
            if (state.fileType == FileCheck.pdf) {
              _navigationService.pushNamed(MyRoute.pdfViewRoute,
                  args: {KeyParams.pdfPath: state.fileLocation});
            } else {
              final result = await OpenFile.open(
                state.fileLocation,
              );

              if (result.type != ResultType.done) {
                MyDialog.showWarning(
                    // ignore: use_build_context_synchronously
                    context: context,
                    message: "${result.message}, Download App?",
                    pressOk: () {
                      log(state.fileType);
                      if (Platform.isAndroid) {
                        launchUrl(
                          Uri.parse(state.fileType == FileCheck.xlsx
                              ? MyConstants.urlGGExcel
                              : state.fileType == FileCheck.docx
                                  ? MyConstants.urlGGWord
                                  : ""),
                          mode: LaunchMode.externalApplication,
                        );
                      } else if (Platform.isIOS) {}
                    },
                    textRight: "OK",
                    textLeft: 'Cancel',
                    pressCancel: () {
                      Navigator.of(context).pop();
                    });
              }
            }
          } else if (state is DisplayFileFailure) {
            MyDialog.showError(
                text: 'close'.tr(),
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {});
          }
        },
        builder: (context, state) {
          if (state is DisplayFileSuccess) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: state.fileList.length,
              itemBuilder: (context, index) {
                final item = state.fileList[index];
                final fileType =
                    item.dSGetDocumentResult!.dFileName!.split('.').last;
                return InkWell(
                    onTap: () {
                      (fileType == 'jpeg' ||
                              fileType == 'png' ||
                              fileType == 'jpg')
                          ? MyDialog.showPopupImage(context,
                              path: state.fileList[index].filestream ?? '',
                              type: 3)
                          : BlocProvider.of<DisplayFileBloc>(context).add(
                              DisplayFileDownload(
                                  file: state
                                      .fileList[index].dSGetDocumentResult!));
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: (fileType == 'jpeg' ||
                              fileType == 'png' ||
                              fileType == 'jpg')
                          ? Image.memory(
                              const Base64Decoder().convert(
                                  state.fileList[index].filestream ?? ''),
                              width: 100,
                              fit: BoxFit.fitWidth,
                            )
                          : Image.asset(
                              (fileType == 'pdf')
                                  ? MyAssets.filePdf2
                                  : (fileType == 'xlsx' || fileType == 'xls')
                                      ? MyAssets.fileExcel2
                                      : (fileType == 'docx' ||
                                              fileType == 'doc')
                                          ? MyAssets.fileDocx2
                                          : MyAssets.fileNon,
                              width: 100,
                              fit: BoxFit.fitWidth,
                            ),
                      title: titleAttach(
                        title: item.dSGetDocumentResult!.dFileName ?? '',
                      ),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          }

          return buildLoading(context);
        },
      ),
    );
  }

  Widget titleAttach({required String title}) {
    return Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
            color: MyColor.nokiaBlue));
  }

  Widget buildLoading(BuildContext context) {
    return SizedBox(
        child: Shimmer.fromColors(
            baseColor: MyColor.bgDrawerColor,
            highlightColor: MyColor.textGrey,
            child: ListView.builder(
                itemBuilder: (context, index) => const Card(
                      child: SizedBox(
                        height: 80,
                      ),
                    ),
                itemCount: 10)));
  }
}
