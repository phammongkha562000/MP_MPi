import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class ITServiceDetailView extends StatefulWidget {
  const ITServiceDetailView({
    Key? key,
    required this.irsNo,
  }) : super(key: key);
  final String irsNo;
  @override
  State<ITServiceDetailView> createState() => _ITServiceDetailViewState();
}

class _ITServiceDetailViewState extends State<ITServiceDetailView> {
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier<bool> _enableSendNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<StdCode> _statusNotifier =
      ValueNotifier<StdCode>(StdCode());

  final _chatDetailController = TextEditingController();
  final ScrollController _scrollChatController = ScrollController();
  final ValueNotifier<String> _sendNotifier = ValueNotifier<String>("");

  StdCode? selectedTypeStatus;
  late ITServiceDetailBloc itServiceDetailBloc;
  late AppBloc appBloc;
  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    itServiceDetailBloc = BlocProvider.of<ITServiceDetailBloc>(context)
      ..add(ITServiceDetailLoaded(irsNo: widget.irsNo, appBloc: appBloc));
  }

  @override
  void dispose() {
    _scrollChatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: "details",
        onPressBack: () {
          _navigationService.pushNamed(MyRoute.itServiceRoute);
        },
      ),
      body: BlocListener<ITServiceDetailBloc, ITServiceDetailState>(
        listener: (context, state) {
          if (state is ITServiceSending) {
            _sendNotifier.value = "Đang gửi";
          }
          if (state is ITServiceSendSuccess) {
            _sendNotifier.value = "Đã gửi";
          }

          if (state is ITServiceDetailFailure) {
            if (state.errorCode != null) {
              MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {
                  itServiceDetailBloc.add(ITServiceDetailLoaded(
                      irsNo: widget.irsNo, appBloc: appBloc));
                },
              );
            } else {
              MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  _navigationService.pushNamed(MyRoute.itServiceDetailRoute,
                      args: {KeyParams.irsNo: widget.irsNo});
                },
                whenComplete: () {
                  Navigator.pop(context);
                },
              );
            }
          }
        },
        child: BlocBuilder<ITServiceDetailBloc, ITServiceDetailState>(
          builder: (context, state) {
            if (state is ITServiceDetailLoadSuccess) {
              //get data
              final svc = state.itServiceDetailResponse.svcRequest;
              final listSvcDetail =
                  state.itServiceDetailResponse.svcRequestDetails;

              _statusNotifier.value =
                  state.selectedStatus ?? state.listSrStatus![0];

              var avtUserRequest = listSvcDetail!.first.avatarUser.toString();

              return Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          card(
                              svc: svc,
                              avtUserRequest: avtUserRequest,
                              fileList:
                                  state.itServiceDetailResponse.attachments ??
                                      []),
                          // *ListView
                          Expanded(
                            child: listSvcDetail.isEmpty
                                ? const SizedBox()
                                : ListView.builder(
                                    padding: EdgeInsets.only(top: 8.h),
                                    controller: _scrollChatController,
                                    itemCount: listSvcDetail.length,
                                    itemBuilder: (context, index) {
                                      final item = listSvcDetail[index];

                                      return Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: item.createUserId ==
                                                globalUser.employeeId
                                            ? Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      detailChat(
                                                          item: item, type: 1),
                                                      SizedBox(width: 10.w),
                                                      avtChat(item: item),
                                                    ],
                                                  ),
                                                  _buildAttachmentsDetail(
                                                      mainAlign:
                                                          MainAxisAlignment.end,
                                                      fileList:
                                                          item.attachments ??
                                                              [])
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      avtChat(item: item),
                                                      SizedBox(width: 10.w),
                                                      detailChat(
                                                          item: item, type: 2),
                                                    ],
                                                  ),
                                                  _buildAttachmentsDetail(
                                                      mainAlign:
                                                          MainAxisAlignment
                                                              .start,
                                                      fileList:
                                                          item.attachments ??
                                                              [])
                                                ],
                                              ),
                                      );
                                    },
                                  ),
                          )
                        ],
                      ),
                    ),
                    rowChat(state, _scrollChatController)
                  ],
                ),
              );
            }
            return loading();
          },
        ),
      ),
    );
  }

  LoadingCustom loading() {
    return LoadingCustom(
      widget: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 12,
              child: const SizedBox(
                height: 150,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 25,
                              width: 200,
                              decoration: const BoxDecoration(
                                  color: MyColor.bgDrawerColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                            ),
                            const SizedBox(width: 7),
                            const AvtCustom(
                              linkAvt: "",
                              fullName: "ADMIN D",
                              size: 35,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const AvtCustom(
                              linkAvt: "",
                              fullName: "ADMIN D",
                              size: 35,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 50,
                              width: 260,
                              decoration: const BoxDecoration(
                                  color: MyColor.bgDrawerColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowChat(
      ITServiceDetailLoadSuccess state, ScrollController scrollChatController) {
    return Expanded(
      flex: -1,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return SizedBox(
                              height: 500,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.listITAdmin!.length,
                                      itemBuilder: (context, index) {
                                        var item = state.listITAdmin![index];
                                        return CheckboxListTile(
                                          title: Text(
                                              item.employeeName.toString()),
                                          value: item.isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              log(value.toString());
                                              item.isSelected = value;
                                              log("${item.itAdmin}: ${item.isSelected}");
                                            });
                                            itServiceDetailBloc.add(
                                                ITServiceDetailChangeAssign(
                                              irsNo: state.irsNo,
                                              isSelected: item.isSelected,
                                              itAdmin: item.itAdmin,
                                            ));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.group_add_outlined,
                      size: 25,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    controller: _chatDetailController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(15.0, 15.0, 0, 10.0),
                      prefixIcon: IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SizedBox(
                                    height: 500,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: state.listSrStatus!.length,
                                      itemBuilder: (context, index) {
                                        var item = state.listSrStatus![index];
                                        return ValueListenableBuilder(
                                          valueListenable: _statusNotifier,
                                          builder: (context, value, child) {
                                            return RadioListTile(
                                              value: item.codeId,
                                              groupValue:
                                                  _statusNotifier.value.codeId,
                                              selected: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  value as String;
                                                  var a = state.listSrStatus!
                                                      .firstWhere((element) =>
                                                          element.codeId ==
                                                          value);
                                                  _statusNotifier.value = a;
                                                  itServiceDetailBloc.add(
                                                      ITServiceDetailChooseStatus(
                                                    irsNo: state.irsNo,
                                                    stdSelected:
                                                        _statusNotifier.value,
                                                  ));

                                                  log("ALO: ${_statusNotifier.value}");
                                                });
                                              },
                                              title: Text(
                                                  item.codeDesc.toString()),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.abc),
                      ),
                      suffixIcon: ValueListenableBuilder(
                        valueListenable: _enableSendNotifier,
                        builder: (context, value, child) => IconButton(
                          onPressed: _enableSendNotifier.value == true
                              ? () {
                                  // Gọi Bloc sent message
                                  var details =
                                      "<p>${_chatDetailController.text}</p>";
                                  itServiceDetailBloc.add(ITServiceDetailReply(
                                    appBloc: appBloc,
                                    irsNo: state.irsNo,
                                    detailsChat: details,
                                    srStatus: _statusNotifier.value.codeId
                                        .toString()
                                        .toUpperCase(),
                                  ));
                                  _enableSendNotifier.value = false;

                                  _chatDetailController.clear();
                                  scrollChatController.animateTo(
                                    scrollChatController
                                        .position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                }
                              : null,
                          icon: Icon(
                            Icons.send_rounded,
                            color: _enableSendNotifier.value == true
                                ? MyColor.textBlue
                                : MyColor.textGrey,
                          ),
                        ),
                      ),
                      hintText: "${_statusNotifier.value.codeDesc}",
                    ),
                    onChanged: (value) {
                      _enableSendNotifier.value =
                          (value.isNotEmpty && value.trim() != '')
                              ? true
                              : false;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailChat({required SvcRequestDetail item, required int type}) {
    String ass = "";

    item.assignTo == null
        ? ass = ""
        : ass = "<b>${"Assign".tr()}:</b><i>${item.assignTo}</i>";

    return Expanded(
      child: Column(
        crossAxisAlignment:
            type == 1 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            item.createUser.toString(),
            style: const TextStyle(
              color: MyColor.textGrey,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          IntrinsicWidth(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MyColor.bgDrawerColor,
                borderRadius: type == 1
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: type == 1
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HtmlWidget(
                        "${item.details}\n$ass",
                        customWidgetBuilder: (element) {
                          if (element.localName == 'table') {
                            return Column(
                              children: [
                                HtmlWidget(element.outerHtml,
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                    ))
                              ],
                            );
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            FormatDateLocal.format_dd_MM_yyyy_HH_mm(item.createDate.toString()),
            style: const TextStyle(
              color: MyColor.textGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget avtChat({
    required SvcRequestDetail item,
  }) {
    return AvatarCustom2(
      imageUrl: item.avatarUser.toString(),
      fullName: item.createUser.toString(),
      size: 20,
    );
  }

  Widget card(
      {SvcRequest? svc,
      required String avtUserRequest,
      required List<FileResponse> fileList}) {
    return CardCustom(
        child: Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 0, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarCustom2(
                    imageUrl: avtUserRequest,
                    fullName: svc!.createUser ?? "",
                    size: 40,
                  ),
                  const WidthSpacer(width: 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        svc.createUser ?? "",
                        style: const TextStyle(
                          color: MyColor.textBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const HeightSpacer(height: 0.01),
                      Text(
                        FormatDateLocal.format_dd_MM_yyyy(
                            svc.createDate.toString()),
                        style: const TextStyle(letterSpacing: 0.3),
                      ),
                      const WidthSpacer(width: 0.01),
                    ],
                  ),
                ],
              ),
              DecoratedBox(
                decoration: const BoxDecoration(
                    color: MyColor.bgDrawerColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: TextByTypeStatus(status: svc.srStatus ?? ""),
                ),
              )
            ],
          ),
          Text(
            svc.srSubject ?? "",
            style: const TextStyle(
              color: MyColor.textBlack,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const HeightSpacer(height: 0.01),
          itemRow(
            title: "division",
            data: svc.itServiceDesc ?? ".",
          ),
          itemRow(
            title: "servicetype",
            data: svc.serviceTypeDesc ?? ".",
          ),
          itemRow(
            title: "priority",
            data: svc.pirorityDesc ?? "",
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: (fileList.isNotEmpty)
                      ? InkWell(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.attachment,
                                color: MyColor.nokiaBlue,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text("attachment".tr(),
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: MyColor.nokiaBlue,
                                    )),
                              )
                            ],
                          ),
                          onTap: () {
                            _navigationService.pushNamed(
                                MyRoute.displayFileRoute,
                                args: {KeyParams.fileList: fileList});
                          },
                        )
                      : const SizedBox()),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildAttachmentsDetail(
      {required List<FileResponse> fileList,
      required MainAxisAlignment mainAlign}) {
    return (fileList.isNotEmpty)
        ? InkWell(
            child: Row(
              mainAxisAlignment: mainAlign,
              children: <Widget>[
                const Icon(
                  Icons.attachment,
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text("viewattachment".tr(),
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                      )),
                )
              ],
            ),
            onTap: () {
              _navigationService.pushNamed(MyRoute.displayFileRoute,
                  args: {KeyParams.fileList: fileList});
            },
          )
        : const SizedBox();
  }

  Widget itemRow({
    required String title,
    required String data,
  }) {
    return Column(
      children: [
        RowFlex4and6(
          child4: Text(
            title.tr(),
            style: const TextStyle(
              color: MyColor.textBlack,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          child6: Text(
            data,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: MyColor.textBlack,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 5)
      ],
    );
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      errorStyle: const TextStyle(
        height: 0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
