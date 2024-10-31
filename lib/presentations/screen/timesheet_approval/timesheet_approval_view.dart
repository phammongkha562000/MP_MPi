import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mpi_new/data/models/timesheet_approval/timesheet_approval_response.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;

import 'package:mpi_new/presentations/widgets/date_previous_next/date_previous_next.dart';
import 'package:mpi_new/presentations/widgets/dialog/approve_dialog.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class TimesheetApprovalView extends StatefulWidget {
  const TimesheetApprovalView({super.key});

  @override
  State<TimesheetApprovalView> createState() => _TimesheetApprovalViewState();
}

class _TimesheetApprovalViewState extends State<TimesheetApprovalView> {
  late TimesheetApprovalBloc _bloc;
  bool isSelected = false;

  final ValueNotifier<String> _stdStatusNotifier = ValueNotifier('');
  StdCode? stdStatusSelected;
  final _formKey = GlobalKey<FormState>();
  late AppBloc appBloc;

  DateTime dateF = DateTime.now();
  DateTime dateT = DateTime.now();
  BehaviorSubject<List<StdCode>> statusList = BehaviorSubject();
  BehaviorSubject<List<TimesheetApprovalResult>> timesheetApprList =
      BehaviorSubject();
  bool isSelectAll = false;
  int quantity = 0;
  Color primaryColor = MyColor.defaultColor;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    appBloc = BlocProvider.of<AppBloc>(context);
    _bloc = BlocProvider.of<TimesheetApprovalBloc>(context)
      ..add(TimesheetApprovalViewLoaded(appBloc: appBloc));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(TimesheetApprovalPaging(
            fromDate: dateF,
            toDate: dateT,
            statusCode: stdStatusSelected!.codeId ?? ''));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBarCustom(context, title: 'timesheetapproval'),
      body: BlocListener<TimesheetApprovalBloc, TimesheetApprovalState>(
        listener: (context, state) {
          if (state is TimesheetApprovalSaveSuccessful) {
            MyDialog.showSuccess(
                context: context,
                message: 'updatesuccess'.tr(),
                pressContinue: () {},
                whenComplete: () {
                  _bloc.add(TimesheetApprovalChangeDate(
                      fromDate: dateF,
                      toDate: dateT,
                      statusCode: stdStatusSelected!.codeId ?? ''));
                });
          }
          if (state is TimesheetApprovalFailure) {
            MyDialog.showError(
                text: 'close'.tr(),
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {
                  _bloc.add(TimesheetApprovalViewLoaded(appBloc: appBloc));
                });
          }
          if (state is TimesheetApprovalSuccess) {
            isSelected = state.timesheetApprovalList
                    .where((element) => element.selected == true)
                    .toList()
                    .isNotEmpty
                ? true
                : false;
            _stdStatusNotifier.value = state.status.codeId ?? '';
            stdStatusSelected = state.status;
            dateF = state.fromDate;
            dateT = state.toDate;
            statusList.add(state.statusList);
            timesheetApprList.add(state.timesheetApprovalList);
            isSelectAll = state.isSelectAll;
            quantity = state.quantity;
          }
          if (state is GetTimesheetApprovalSuccess) {
            dateF = state.fromDate;
            dateT = state.toDate;
            timesheetApprList.add(state.timesheetApprovalList);
            isSelectAll = state.isSelectAll;
            quantity = state.quantity;
          }
          if (state is ChangeStatusTimesheetApprovalSuccess) {
            timesheetApprList.add(state.timesheetApprovalList);
            quantity = state.quantity;
          }
          if (state is SelectTimesheetApprovalSuccess) {
            isSelectAll = state.isSelectAll;
            timesheetApprList.add(state.timesheetApprList);
            isSelected = state.timesheetApprList
                    .where((element) => element.selected == true)
                    .toList()
                    .isNotEmpty
                ? true
                : false;
          }
        },
        child: BlocBuilder<TimesheetApprovalBloc, TimesheetApprovalState>(
          builder: (context, state) {
            if (state is TimesheetApprovalLoading) {
              return const ItemLoading();
            }
            return StreamBuilder(
                stream: timesheetApprList.stream,
                builder: (context, snapshot) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DatePreviousNextView(
                          fromDate: dateF,
                          toDate: dateT,
                          onTapPrevious: () {
                            _bloc.add(TimesheetApprovalChangeDate(
                                fromDate:
                                    dateF.subtract(const Duration(days: 1)),
                                toDate: dateT,
                                statusCode: stdStatusSelected!.codeId ?? ''));
                          },
                          onPickFromDate: (selectedDate) {
                            _bloc.add(TimesheetApprovalChangeDate(
                                fromDate: selectedDate,
                                toDate: dateT,
                                statusCode: stdStatusSelected!.codeId ?? ''));
                          },
                          onPickToDate: (selectedDate) {
                            _bloc.add(TimesheetApprovalChangeDate(
                                fromDate: dateF,
                                toDate: selectedDate,
                                statusCode: stdStatusSelected!.codeId ?? ''));
                          },
                          onTapNext: () {
                            _bloc.add(TimesheetApprovalChangeDate(
                                toDate: dateT.add(const Duration(days: 1)),
                                fromDate: dateF,
                                statusCode: stdStatusSelected!.codeId ?? ''));
                          },
                        ),
                        StreamBuilder(
                          stream: statusList.stream,
                          builder: (context, snapshot) => _buildDropdown(
                              notifier: _stdStatusNotifier,
                              list: (snapshot.hasData && snapshot.data != null)
                                  ? snapshot.data!
                                  : []),
                        ),
                        (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data != [])
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(16.w, 8.h, 0, 8.h),
                                child: Text(
                                  '${'qty'.tr()}: $quantity',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : const SizedBox(),
                        _stdStatusNotifier.value == 'NEW'
                            ? _buildRowSelectAll(
                                isSelectAll: isSelectAll,
                                timesheetApprovalList: snapshot.data ?? [])
                            : const SizedBox(),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              _bloc.add(TimesheetApprovalChangeDate(
                                  fromDate: dateF,
                                  toDate: dateT,
                                  statusCode: stdStatusSelected!.codeId ?? ''));
                            },
                            child: (snapshot.hasData &&
                                    snapshot.data != null &&
                                    snapshot.data != [] &&
                                    snapshot.data!.isNotEmpty)
                                ? Scrollbar(
                                    controller: _scrollController,
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        padding: EdgeInsets.only(
                                            bottom: 100.h,
                                            left: 16.w,
                                            right: 16.w),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context1, index) =>
                                            _buildTimesheetApproval(
                                                timesheetApprList:
                                                    snapshot.data!,
                                                buildContext: context,
                                                item: snapshot.data![index])),
                                  )
                                : ListView(children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.4,
                                        child: const EmptyWidget())
                                  ]),
                          ),
                        ),
                        state is TimesheetApprovalPagingLoading
                            ? const PagingLoading()
                            : const SizedBox()
                      ]);
                });
          },
        ),
      ),
    );
  }

  Widget _buildRowSelectAll(
      {required List<TimesheetApprovalResult> timesheetApprovalList,
      required bool isSelectAll}) {
    return Row(
      children: [
        Expanded(
          child: timesheetApprovalList != [] && timesheetApprovalList.isNotEmpty
              ? CheckboxListTile(
                  title: Text('selectall'.tr()),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: isSelectAll,
                  onChanged: (value) {
                    _bloc.add(TimesheetSelectedAll(
                        isSelectAll: value!,
                        timesheetApprList: timesheetApprovalList));
                  },
                )
              : const SizedBox(),
        ),
        timesheetApprovalList.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(right: 12.w, bottom: 8.h),
                child: ElevateButtonCustom(
                  enable: isSelected,
                  onPressed: () async {
                    final TextEditingController commentApprovalController =
                        TextEditingController();
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ApproveDialog(
                            controller: commentApprovalController,
                            onPressed: () async {
                              _bloc.add(TimesheetApproveSelected(
                                  timesheetApprList: timesheetApprovalList,
                                  fromDate: dateF,
                                  toDate: dateT,
                                  statusCode: stdStatusSelected!.codeId ?? '',
                                  comment: commentApprovalController.text));

                              Navigator.of(context).pop();
                            },
                            isApprove: true,
                          );
                        });
                  },
                  text: "approveselected".tr(),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Widget _buildDropdown(
      {required ValueNotifier notifier, required List<StdCode> list}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16.h, 8.h, 16.h, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 6),
              child: Text(
                'status'.tr(),
                style: LayoutCustom.labelStyleRequired,
              ),
            ),
            ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, value, child) => DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white,
                    ),
                    child: DropdownButtonFormField2(
                        isExpanded: true,
                        hint: Text(
                          'status'.tr(),
                          style: LayoutCustom.hintStyle,
                        ),
                        buttonStyleData: dropdown_custom.buttonStyleData,
                        items: list
                            .map((item) => DropdownMenuItem<StdCode>(
                                  value: item,
                                  child: Text(
                                    item.codeDesc ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: stdStatusSelected,
                        onChanged: (value) {
                          _stdStatusNotifier.value = value!.codeId!;
                          stdStatusSelected = value;
                          _bloc.add(TimesheetChangeStatus(
                              fromDate: dateF,
                              toDate: dateT,
                              statusList: list != [] ? list : [],
                              statusCode: stdStatusSelected!.codeId ?? ''));
                        },
                        dropdownStyleData: dropdown_custom.dropdownStyleData,
                        menuItemStyleData: dropdown_custom.menuItemStyleData))),
          ],
        ));
  }

  Widget _buildTimesheetApproval(
      {required BuildContext buildContext,
      required TimesheetApprovalResult item,
      required List<TimesheetApprovalResult> timesheetApprList}) {
    return Slidable(
      endActionPane: item.tsStatus == 'NEW'
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    final TextEditingController commentApprovalController =
                        TextEditingController();
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ApproveDialog(
                            controller: commentApprovalController,
                            onPressed: () async {
                              _bloc.add(TimesheetApprovalSlidable(
                                  comment: commentApprovalController.text,
                                  approvalType: "Approved",
                                  tsId: item.tsId ?? 0));
                              Navigator.of(context).pop();
                            },
                            isApprove: true,
                          );
                        });
                  },
                  backgroundColor: MyColor.textBlue,
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'approval'.tr(),
                ),
                SlidableAction(
                  onPressed: (context) async {
                    final TextEditingController commentRejectController =
                        TextEditingController();
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ApproveDialog(
                            formKey: _formKey,
                            controller: commentRejectController,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _bloc.add(TimesheetApprovalSlidable(
                                    comment: commentRejectController.text,
                                    approvalType: "Rejected",
                                    tsId: item.tsId ?? 0));
                                Navigator.of(context).pop();
                              }
                            },
                            isApprove: false,
                          );
                        });
                  },
                  backgroundColor: MyColor.textRed,
                  foregroundColor: Colors.white,
                  icon: Icons.close,
                  label: 'reject'.tr(),
                ),
              ],
            )
          : null,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        elevation: 8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.tsStatus == 'NEW'
                ? Expanded(
                    flex: 1,
                    child: Checkbox(
                        value: item.selected,
                        onChanged: (value) {
                          _bloc.add(TimesheetSelected(
                              timesheetApprList: timesheetApprList,
                              tsId: item.tsId ?? 0,
                              selected: value!));
                        }),
                  )
                : const SizedBox(),
            Expanded(
              flex: 9,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ContainerPanelColor(text: item.tsId.toString()),
                        TextByTypeStatus(status: item.tsStatus.toString())
                      ],
                    ),
                    Column(
                      children: [
                        _buildRowItem(
                            label: 'name', content: item.employeeName ?? ''),
                        _buildRowItem(
                            label: 'date',
                            content: FormatDateLocal.format_dd_MM_yyyy(
                                item.createDate.toString())),
                        _buildRowItem4(
                            label: 'starttime',
                            content: FormatDateLocal.format_HH_mm(
                                item.startTime.toString()),
                            label2: 'endtime',
                            content2: FormatDateLocal.format_HH_mm(
                                item.endTime.toString())),
                        _buildRowItem4(
                            label: 'workhour',
                            content: item.workHour.toString(),
                            label2: 'overtime',
                            content2: item.overtTimeHour.toString()),
                        _buildRowItem3(
                            label: 'manualpostreason',
                            content: item.manualPostReason ?? '',
                            item3: item.createDate ?? 0),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem4({
    required String label,
    required String content,
    required String label2,
    required String content2,
  }) {
    return Padding(
      padding: LayoutCustom.paddingVerticalItemView,
      child: Row(
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
            flex: 1,
            child: Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColor.getTextColor(), fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              flex: 1,
              child: Text(
                '${label2.tr()}:',
                style: TextStyle(
                  color: MyColor.getTextColor(),
                ),
              )),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    content2,
                    style: TextStyle(
                        color: MyColor.getTextColor(),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildRowItem({required String label, required String content}) {
    return Padding(
      padding: LayoutCustom.paddingVerticalItemView,
      child: Row(
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
            flex: 3,
            child: Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColor.getTextColor(), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem3(
      {required String label, required String content, required int item3}) {
    return Padding(
      padding: LayoutCustom.paddingVerticalItemView,
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColor.getTextColor(), fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(FormatDateLocal.format_dd_MM_yyyy(item3.toString()),
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      )),
                ],
              )),
        ],
      ),
    );
  }

  TextStyle styleItem() {
    return const TextStyle(
        color: MyColor.textBlack, fontWeight: FontWeight.w500);
  }

  TextStyle styleContent() {
    return const TextStyle(
        color: MyColor.textBlack, fontWeight: FontWeight.bold);
  }
}
