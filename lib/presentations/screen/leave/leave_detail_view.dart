import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/approve/icon_approve.dart';
import 'package:mpi_new/presentations/widgets/dialog/approve_dialog.dart';

class LeaveDetailView extends StatefulWidget {
  const LeaveDetailView({
    Key? key,
    required this.isApprove,
    required this.lvNo,
  }) : super(key: key);
  final bool isApprove;
  final String lvNo;

  @override
  State<LeaveDetailView> createState() => _LeaveDetailViewState();
}

class _LeaveDetailViewState extends State<LeaveDetailView> {
  final TextEditingController _commentApprovalController =
      TextEditingController();
  final TextEditingController _commentRejectController =
      TextEditingController();
  late LeaveDetailBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;
  @override
  void initState() {
    _bloc = BlocProvider.of<LeaveDetailBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarCustom(context, title: "leavedetail", onPressBack: () {
          Navigator.pop(context, 1);
        }),
        body: BlocConsumer<LeaveDetailBloc, LeaveDetailState>(
          listener: (context, state) {
            if (state is LeaveApprovalSuccessful) {
              MyDialog.showSuccess(
                  message: 'updatesuccess'.tr(),
                  context: context,
                  pressContinue: () {},
                  whenComplete: () {});
            }
            if (state is LeaveDetailFailure) {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    _bloc.add(LeaveDetailLoaded(lvNo: widget.lvNo));
                  });
            }
          },
          builder: (context, state) {
            if (state is LeaveDetailLoadSuccess) {
              final detail = state.leaveDetail;
              return Padding(
                padding: LayoutCustom.paddingItemCard,
                child: Column(
                  children: [
                    buildCard1(detail),
                    buildCardRemark(detail),
                    Expanded(
                      child: ListView.builder(
                        padding: LayoutCustom.paddingBottomListView,
                        itemCount: detail.hlvLeaveDetails!.length,
                        itemBuilder: (context, index) {
                          var itemDetail = detail.hlvLeaveDetails![index];
                          return _buildApproval(
                              itemDetail: itemDetail, item: detail);
                        },
                      ),
                    )
                  ],
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildApproval(
      {required HlvLeaveDetail itemDetail, required LeaveDetailPayload item}) {
    return CardCustom(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTypeAndDate(itemDetail),
          _buildNameAndStatus(itemDetail: itemDetail, item: item),
          itemDetail.comment != null && itemDetail.comment != ''
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(itemDetail.comment ?? ''),
                )
              : const SizedBox(),
        ],
      ),
    ));
  }

  Widget _buildNameAndStatus(
      {required HlvLeaveDetail itemDetail, required LeaveDetailPayload item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(itemDetail.assignerName ?? '',
              style: TextStyle(
                  fontWeight: (globalUser.employeeId == itemDetail.assignedUser)
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ),
        itemDetail.leaveStatus != null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: MyColor.bgDrawerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: TextByTypeStatus(status: itemDetail.leaveStatus ?? ""),
                ),
              )
            : (globalUser.employeeId == itemDetail.assignedUser) &&
                    (itemDetail.approvalType == null) &&
                    (widget.isApprove == true)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconApprove(
                          isApprove: true,
                          onPressed: () async => await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ApproveDialog(
                                  controller: _commentApprovalController,
                                  onPressed: () async {
                                    _bloc.add(SaveLeaveApproval(
                                        comment:
                                            _commentApprovalController.text,
                                        approvalType: "Approved",
                                        hLvNo: item.lvNo ?? ''));
                                    Navigator.of(context).pop();
                                  },
                                  isApprove: true,
                                );
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: IconApprove(
                            isApprove: false,
                            onPressed: () async => await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ApproveDialog(
                                    formKey: _formKey,
                                    controller: _commentRejectController,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _bloc.add(SaveLeaveApproval(
                                            comment:
                                                _commentRejectController.text,
                                            approvalType: "Rejected",
                                            hLvNo: item.lvNo ?? ''));
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    isApprove: false,
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
      ],
    );
  }

  Widget buildTypeAndDate(HlvLeaveDetail itemDetail) {
    log("${itemDetail.replyType}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
          decoration: BoxDecoration(
              color: (globalUser.employeeId == itemDetail.assignedUser)
                  ? MyColor.pastelGray
                  : MyColor.bgDrawerColor,
              borderRadius: LayoutCustom.borderRadiusRight12),
          child: Row(
            children: [
              IconCustom(
                iConURL: getIConByType(
                    type: itemDetail.replyType.toString(),
                    status: itemDetail.leaveStatus == null ? false : true),
                size: 25,
              ),
              const WidthSpacer(width: 0.02),
              Text(
                itemDetail.replyTypeDesc ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        (itemDetail.approvalType == null) && (itemDetail.replyType != 'REQ')
            ? const SizedBox()
            : ContainerPanelColor(
                isRight: true,
                text: FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                    itemDetail.createDate.toString())),

        /* Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                    color: backgroundPanel,
                    borderRadius: LayoutCustom.borderRadiusLeft32),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                        itemDetail.createDate.toString()),
                    style: TextStyle(
                      color: colorPanel,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ) */
      ],
    );
  }

  CardCustom buildCardRemark(LeaveDetailPayload item) {
    return CardCustom(
      child: Padding(
        padding: LayoutCustom.paddingItemCard,
        child: Column(
          children: [
            DecoratedBox(
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: MyColor.outerSpace))),
                child: Text(
                  "remark".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              children: [
                Text(
                  item.remark.toString(),
                  style: styleItem(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CardCustom buildCard1(LeaveDetailPayload item) {
    return CardCustom(
      child: Column(
        children: [
          ColoredBox(
              color: backgroundPanel,
              child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item.lvNo ?? '',
                        style: TextStyle(
                          color: colorPanel,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ))),
          Padding(
            padding: LayoutCustom.paddingItemCard,
            child: Column(
              children: [
                RowFlex3and7(
                    child3: Text(
                      "leaveperiod".tr(),
                      style: styleItem(),
                    ),
                    child7: Text(
                      "${FormatDateLocal.format_dd_MM_yyyy(item.fromDate.toString())} - ${FormatDateLocal.format_dd_MM_yyyy(item.toDate.toString())}",
                      style: styleItemBold(),
                    )),
                RowFlex3and7(
                  child3: Text(
                    "leavedate".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    '${item.leaveDays} - ${item.marker}',
                    style: styleItemBold(),
                  ),
                ),
                RowFlex3and7(
                  child3: Text(
                    "requester".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    item.employeeName ?? "no_data".tr(),
                    style: styleItemBold(),
                  ),
                ),
                RowFlex3and7(
                  child3: Text(
                    "leavetype".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    item.leaveTypeDesc ?? "nodata".tr(),
                    style: styleItemBold(),
                  ),
                ),
                RowFlex3and7(
                  child3: Text(
                    "submitdate".tr(),
                    style: styleItem(),
                  ),
                  child7: Text(
                    FormatDateLocal.format_dd_MM_yyyy(
                        item.submitDate.toString()),
                    style: styleItemBold(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle styleItem() {
    return const TextStyle(
      color: MyColor.textBlack,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle styleItemBold() {
    return const TextStyle(
      color: MyColor.textBlack,
      fontWeight: FontWeight.bold,
    );
  }
}
