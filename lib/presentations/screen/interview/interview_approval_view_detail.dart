// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:open_file_plus/open_file_plus.dart';

import '../../../data/data.dart';

class InterviewApprovalViewDetail extends StatefulWidget {
  const InterviewApprovalViewDetail({super.key});

  @override
  State<InterviewApprovalViewDetail> createState() =>
      _InterviewApprovalViewDetailState();
}

class _InterviewApprovalViewDetailState
    extends State<InterviewApprovalViewDetail> {
  final _commentController = TextEditingController();
  final _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(context, title: "details"),
      body: BlocListener<InterviewApprovalDetailBloc,
          InterviewApprovalDetailState>(
        listener: (context, state) async {
          if (state is InterviewApprovalDetailFailure) {
            MyDialog.showError(
              context: context,
              messageError: state.message,
              whenComplete: () {
                _navigationService.pushNamed(MyRoute.interviewApprovalRoute);
              },
              pressTryAgain: () {
                Navigator.pop(context);
              },
            );
          }

          if (state is InterviewApprovalDownloadSuccessfully) {
            if (state.fileType == FileCheck.pdf) {
              _navigationService.pushNamed(MyRoute.documentViewRoute,
                  args: {KeyParams.documentFile: state.fileLocation});
            } else {
              final result = await OpenFile.open(state.fileLocation);
              if (result.type != ResultType.done) {
                MyDialog.showWarning(
                  context: context,
                  message: "${result.message}, Download App?",
                  pressCancel: () {
                    Navigator.pop(context);
                  },
                  textLeft: "cancel",
                  textRight: "download",
                  pressOk: () {
                    if (Platform.isAndroid) {
                      switch (state.fileType) {
                        case FileCheck.xlsx:
                          OpenStoreHelper.openExcelWithCHPlay();
                          break;
                        case FileCheck.docx:
                          OpenStoreHelper.openWordWithCHPlay();
                          break;
                        default:
                          OpenStoreHelper.openCHPlay();
                      }
                    }
                  },
                );
              }
            }
          }
          if (state is UpdateCommentSuccessfully) {
            MyDialog.showSuccess(
                context: context, message: 'updatesuccess'.tr());
          }
        },
        child: BlocBuilder<InterviewApprovalDetailBloc,
            InterviewApprovalDetailState>(
          builder: (context, state) {
            if (state is InterviewApprovalDetailLoadSuccess) {
              _commentController.text =
                  state.interviewApprovalResponse.interviewRemark ?? "";
              return Column(
                children: [
                  _buildInfo(state: state),
                  Expanded(
                    flex: -1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
                      child: DefaultButton(
                        buttonText: "update",
                        onPressed: () {
                          BlocProvider.of<InterviewApprovalDetailBloc>(context)
                              .add(InterviewApprovalUpdateComment(
                                  comment: _commentController.text));
                        },
                      ),
                    ),
                  )
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildInfo({required InterviewApprovalDetailLoadSuccess state}) {
    var item = state.interviewApprovalResponse;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: LayoutCustom.contentPaddingTFF,
                child: Column(
                  children: [
                    _buildItem(
                      itemLeft: "positiontitle",
                      itemRight: item.positionTitle ?? "",
                    ),
                    _buildItem(
                      itemLeft: "interviewtype",
                      itemRight: item.interviewTypeDesc ?? "",
                    ),
                    _buildItem(
                      itemLeft: "interviewdate",
                      itemRight: FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                        item.interviewDate.toString(),
                      ),
                    ),
                    _buildItem(
                      itemLeft: "place",
                      itemRight: item.facilityDesc ?? "",
                    ),
                    _buildItem(
                      itemLeft: "interviewname",
                      itemRight: item.cvName ?? "",
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: RowFlex4and6(
                        child4: Text(
                          "interviewform".tr(),
                          style: _styleLeft(),
                        ),
                        child6: InkWell(
                          onTap: () {
                            var itemForm = state.recruitInterviewFormResponse ??
                                RecruitInterviewFormResponse();

                            _navigationService
                                .pushNamed(MyRoute.interviewFormRoute, args: {
                              KeyParams.interviewForm: itemForm,
                              KeyParams.interviewApproval: item
                            });
                          },
                          child: Text(
                            "viewdetail".tr(),
                            style: const TextStyle(
                              color: MyColor.nokiaBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const HeightSpacer(height: 0.01),
                    _buildDocuments(state),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: LayoutCustom.contentPaddingTFF,
                child: Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "interviewcomment".tr(),
                            style: _styleLeft(),
                          ),
                          const HeightSpacer(height: 0.01),
                          TextFormField(
                            controller: _commentController,
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: '${'interviewcomment'.tr()}...',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16)),
                            maxLines: 4,
                          ),
                          const HeightSpacer(height: 0.01),
                          _buildItem(
                            itemLeft: "updatedate",
                            itemRight: FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                                item.updateDate.toString()),
                          ),
                          const HeightSpacer(height: 0.01),
                          _buildItem(
                            itemLeft: "by",
                            itemRight: item.intervieweeerName ?? "",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocuments(InterviewApprovalDetailLoadSuccess state) {
    return SizedBox(
      height: state.listDocument?.length == 1
          ? 50
          : state.listDocument?.length == 2
              ? 70
              : 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(
                "document".tr(),
                style: _styleLeft(),
              )),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: state.listDocument?.length,
              itemBuilder: (context, index) {
                var itemDocument = state.listDocument![index];

                String fileExtension =
                    itemDocument.dFileName.toString().split(".").last;

                return InkWell(
                  onTap: () {
                    log("DOC NO: ${itemDocument.filePath}");
                    BlocProvider.of<InterviewApprovalDetailBloc>(context)
                        .add(InterviewApprovalViewFile(
                      pathFile: itemDocument.filePath ?? "",
                    ));
                  },
                  child: Row(
                    children: [
                      IconCustom(
                        iConURL: _getIconByFile(file: fileExtension),
                        size: 25,
                      ),
                      const WidthSpacer(width: 0.02),
                      Expanded(
                        child: Text(
                          itemDocument.dFileName.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColor.textDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String itemLeft,
    required String itemRight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: RowFlex4and6(
        child4: Text(
          itemLeft.tr(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        child6: Text(itemRight,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  TextStyle _styleLeft() {
    return const TextStyle(
      color: MyColor.textBlack,
    );
  }

  String _getIconByFile({required String file}) {
    switch (file) {
      case "pdf":
        return MyAssets.filePdf;
      case "xlsx":
        return MyAssets.fileExcel2;
      case "docx":
        return MyAssets.fileDocx;

      default:
    }
    return MyAssets.fileNon;
  }
}
