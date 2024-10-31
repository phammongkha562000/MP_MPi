import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/approve/icon_approve.dart';
import 'package:mpi_new/presentations/widgets/dialog/approve_dialog.dart';

import '../../../data/data.dart';

class ServiceRequestDetailView extends StatefulWidget {
  const ServiceRequestDetailView({
    Key? key,
    required this.svrNo,
    required this.isApprove,
  }) : super(key: key);
  final String svrNo;
  final bool isApprove;
  @override
  State<ServiceRequestDetailView> createState() =>
      _ServiceRequestDetailViewState();
}

class _ServiceRequestDetailViewState extends State<ServiceRequestDetailView> {
  final _navigationService = getIt<NavigationService>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _commentApprovalController =
      TextEditingController();
  final TextEditingController _commentRejectController =
      TextEditingController();
  late ServiceRequestDetailBloc _bloc;
  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;
  @override
  void initState() {
    _bloc = BlocProvider.of<ServiceRequestDetailBloc>(context);

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
        resizeToAvoidBottomInset: false,
        appBar: AppBarCustom(
          context,
          title: 'servicerequestdetail',
          onPressBack: () {
            Navigator.pop(context, true);
          },
        ),
        body: BlocConsumer<ServiceRequestDetailBloc, ServiceRequestDetailState>(
          listener: (context, state) {
            if (state is ServiceApprovalSuccessful) {
              MyDialog.showSuccess(
                  context: context,
                  message: 'updatesuccess'.tr(),
                  pressContinue: () {},
                  whenComplete: () {});
            }
            if (state is ServiceRequestDetailFailure) {
              MyDialog.showError(
                  text: 'close'.tr(),
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    _bloc.add(
                        ServiceRequestDetailViewLoaded(svrNo: widget.svrNo));
                  });
            }
          },
          builder: (context, state) {
            if (state is ServiceRequestDetailSuccess) {
              return SingleChildScrollView(
                padding: LayoutCustom.paddingItemCard,
                child: Column(
                  children: [
                    _buildInfo(detail: state.detail, fileList: state.fileList),
                    state.detail.details!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 24.h),
                            itemCount: state.detail.details!.length,
                            itemBuilder: (context, index) => _buildApproved(
                                item: state.detail.details![index]))
                        : const SizedBox()
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

  Widget _buildInfo(
      {required ServiceRequestDetailResponse detail,
      required List<FileResponse> fileList}) {
    return CardCustom(
        child: Column(
      children: <Widget>[
        ColoredBox(
            color: backgroundPanel,
            child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      detail.info!.svrNo ?? '',
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
              _buildRowItem(
                  label: 'subject', content: detail.info!.svrSubject ?? ''),
              _buildRowItem(
                  label: 'servicetype',
                  content: detail.info!.applicationDesc ?? ''),
              _buildRowItem(
                  label: 'requester',
                  content: detail.info!.createUserName ?? ''),
              _buildRowItem(
                  label: 'duedate',
                  content: FormatDateLocal.format_dd_MM_yyyy(
                      detail.info!.dueDate.toString())),
              _buildRowItem(
                  label: 'remark', content: detail.info!.remark ?? ''),
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
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.w),
                                  child: Text("attachment".tr(),
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blue,
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
                        : Row(
                            children: <Widget>[
                              const Icon(Icons.attachment, color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.only(left: 6.w),
                                child: Text("attachment".tr(),
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey)),
                              )
                            ],
                          ),
                  ),
                ],
              ),
              _buildRowItem(
                  label: 'createdate',
                  content: FormatDateLocal.format_dd_MM_yyyy(
                      detail.info!.createDate.toString())),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildApproved({required ServiceRequestDetail item}) {
    return CardCustom(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildRelyAndDate(item: item),
          _buildNameAndStatus(item: item),
          (item.comment != null && item.comment != '')
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(item.comment ?? ''),
                )
              : const SizedBox(),
        ],
      ),
    ));
  }

  Widget _buildNameAndStatus({required ServiceRequestDetail item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(item.createUser ?? '',
                style: TextStyle(
                    fontWeight: (globalUser.employeeId == item.assignedUser)
                        ? FontWeight.bold
                        : FontWeight.normal)),
          ),
        ),
        item.svrStatus != null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: (globalUser.employeeId == item.assignedUser)
                      ? MyColor.pastelGray
                      : MyColor.bgDrawerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: TextByTypeStatus(status: item.svrStatus ?? ""),
                ),
              )
            : (globalUser.employeeId == item.assignedUser) &&
                    (item.approveType == null) &&
                    (widget.isApprove == true)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(children: [
                      IconApprove(
                          isApprove: true,
                          onPressed: () async => await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ApproveDialog(
                                  controller: _commentApprovalController,
                                  onPressed: () async {
                                    _bloc.add(SaveServiceApproval(
                                        comment:
                                            _commentApprovalController.text,
                                        approvalType: "Approved",
                                        hLvNo: item.svrNo ?? ''));
                                    Navigator.of(context).pop();
                                  },
                                  isApprove: true,
                                );
                              })),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: IconApprove(
                              isApprove: false,
                              onPressed: () async => await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ApproveDialog(
                                        formKey: _formKey,
                                        controller: _commentRejectController,
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _bloc.add(SaveServiceApproval(
                                                comment:
                                                    _commentRejectController
                                                        .text,
                                                approvalType: "Rejected",
                                                hLvNo: item.svrNo ?? ''));
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        isApprove: false,
                                      );
                                    },
                                  )))
                    ]),
                  )
                : const SizedBox(),
      ],
    );
  }

  Widget _buildRelyAndDate({required ServiceRequestDetail item}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
          decoration: BoxDecoration(
              color: (globalUser.employeeId == item.assignedUser)
                  ? MyColor.pastelGray
                  : MyColor.bgDrawerColor,
              borderRadius: LayoutCustom.borderRadiusRight12),
          child: Row(
            children: [
              IconCustom(
                iConURL: getIConByType(
                    type: item.replyType.toString(),
                    status: item.svrStatus == null ? false : true),
                size: 25,
              ),
              const WidthSpacer(width: 0.02),
              Text(
                item.replyType ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              )
            ],
          ),
        ),
        (item.approveType == null) && (item.replyType != 'Request')
            ? const SizedBox()
            : ContainerPanelColor(
                isRight: true,
                text: FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                    item.createDate.toString()),
              ),

        /* Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                    color: backgroundPanel,
                    borderRadius: LayoutCustom.borderRadiusLeft32),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    FormatDateLocal.format_dd_MM_yyyy_HH_mm(
                        item.createDate.toString()),
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

  Widget _buildRowItem({required String label, required String content}) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(
                '${label.tr()}:',
                style: TextStyle(
                  color: MyColor.getTextColor(),
                ),
              )),
          Expanded(
            flex: 2,
            child: Text(
              content,
              style: TextStyle(
                  color: MyColor.getTextColor(), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

String getIConByType({required String type, required bool status}) {
  switch (type) {
    case "REQ":
    case "Request":
      return MyAssets.request;

    case "APPO":
    case "Approval":
      return status ? MyAssets.approveYellow : MyAssets.approveGray;
    case "Action":
      return status ? MyAssets.actionYellow : MyAssets.actionGray;
    default:
      return MyAssets.avt;
  }
}
