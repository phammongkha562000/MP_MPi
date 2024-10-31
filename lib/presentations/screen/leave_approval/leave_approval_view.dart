import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:mpi_new/presentations/widgets/date_previous_next/date_previous_next.dart';
import 'package:mpi_new/presentations/widgets/dialog/approve_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class LeaveApprovalView extends StatefulWidget {
  const LeaveApprovalView({super.key});

  @override
  State<LeaveApprovalView> createState() => _LeaveApprovalViewState();
}

class _LeaveApprovalViewState extends State<LeaveApprovalView> {
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier _stdTypeNotifier = ValueNotifier('');
  StdCode? stdTypeSelected;
  final ValueNotifier _stdStatusNotifier = ValueNotifier('');
  StdCode? stdStatusSelected;
  final ValueNotifier _isPending = ValueNotifier(false);
  late LeaveApprovalBloc _bloc;
  bool isSelected = false;
  late AppBloc appBloc;
  BehaviorSubject<List<StdCode>> leaveTypeList = BehaviorSubject();
  BehaviorSubject<List<StdCode>> leaveStatusList = BehaviorSubject();
  BehaviorSubject<List<LeaveApprovalResult>> leaveApprovalListPending =
      BehaviorSubject();

  DateTime dateF = DateTime.now();
  DateTime dateT = DateTime.now();
  bool isSelectAll = false;

  final ScrollController _scrollController = ScrollController();
  int quantity = 0;
  Color primaryColor = MyColor.defaultColor;
  Color foregroundColor = MyColor.defaultColor;

  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);
  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;

  @override
  void initState() {
    appBloc = BlocProvider.of<AppBloc>(context);
    _bloc = BlocProvider.of<LeaveApprovalBloc>(context)
      ..add(LeaveApprovalViewLoaded(appBloc: appBloc));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(LeaveApprovalPaging(
            fromDate: dateF,
            toDate: dateT,
            isPending: _isPending.value,
            stdStatus: stdStatusSelected,
            stdType: stdTypeSelected));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    primaryColor = Theme.of(context).primaryColor;

    foregroundColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(
        context,
        title: 'leaveapproval',
        onPressBack: () {
          Navigator.pop(context, 1);
        },
      ),
      body: BlocListener<LeaveApprovalBloc, LeaveApprovalState>(
        listener: (context, state) {
          if (state is LeaveApprovalSaveSuccessful) {
            MyDialog.showSuccess(
                message: 'updatesuccess'.tr(), context: context);
          }
          if (state is LeaveApprovalFailure) {
            MyDialog.showError(
                text: 'close'.tr(),
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {
                  _bloc.add(LeaveApprovalViewLoaded(appBloc: appBloc));
                });
          }
          if (state is LeaveApprovalSuccess) {
            _isPending.value = state.isPending;
            stdTypeSelected = state.typeLeave;
            stdStatusSelected = state.statusLeave;

            dateF = state.fromDate;
            dateT = state.toDate;
            leaveTypeList.add(state.leaveTypeList);
            leaveStatusList.add(state.leaveStatusList);
            leaveApprovalListPending.add(state.leaveApprovalListPending);
          }
          if (state is GetLeaveApprovalSuccessful) {
            dateF = state.fromDate;
            dateT = state.toDate;
            isSelectAll = state.isSelectAll;
            leaveApprovalListPending.add(state.leaveApprovalListPending);
          }
          if (state is SelectLeaveApprovalSuccess) {
            isSelectAll = state.isSelectAll;
            leaveApprovalListPending.add(state.leaveApprovalListPending);
            isSelected = state.leaveApprovalListPending
                    .where((element) => element.selected == true)
                    .toList()
                    .isNotEmpty
                ? true
                : false;
          }
          if (state is LeaveApprovalSelectedSuccess) {
            leaveApprovalListPending.add(state.leaveApprovalListPending);
          }
          if (state is LeaveApprovalPagingSuccess) {
            leaveApprovalListPending.add(state.leaveApprovalListPending);
          }
        },
        child: BlocBuilder<LeaveApprovalBloc, LeaveApprovalState>(
          builder: (context, state) {
            if (state is LeaveApprovalLoading) {
              return const ItemLoading();
            }
            return StreamBuilder(
              stream: leaveApprovalListPending.stream,
              builder: (context, snapshotAppr) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPickDate(),
                      _buildSearch(),
                      _buildQty(
                          qty: snapshotAppr.data != null
                              ? snapshotAppr.data!.length
                              : 0),
                      (snapshotAppr.hasData &&
                              snapshotAppr.data != [] &&
                              snapshotAppr.data!.isNotEmpty)
                          ? _buildCheckBoxAll(
                              leaveApprovalListPending: snapshotAppr.data!)
                          : const SizedBox(),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _bloc.add(LeaveApprovalChangeDate(
                                fromDate: dateF,
                                toDate: dateT,
                                isPending: _isPending.value));
                          },
                          child: (snapshotAppr.hasData &&
                                  snapshotAppr.data != null &&
                                  snapshotAppr.data != [] &&
                                  snapshotAppr.data!.isNotEmpty)
                              ? Scrollbar(
                                  controller: _scrollController,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.only(
                                          bottom: 100.h,
                                          left: 16.w,
                                          right: 16.w),
                                      shrinkWrap: true,
                                      itemCount: snapshotAppr.data?.length,
                                      itemBuilder: (context1, index) =>
                                          _buildLeaveApproval(
                                              buildContext: context,
                                              item: snapshotAppr.data![index])),
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
                      state is LeaveApprovalPagingLoading
                          ? const PagingLoading()
                          : const SizedBox()
                    ]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckBoxAll(
      {required List<LeaveApprovalResult> leaveApprovalListPending}) {
    return Row(
      children: [
        Expanded(
            child: CheckboxListTile(
          title: Text('selectall'.tr()),
          controlAffinity: ListTileControlAffinity.leading,
          value: isSelectAll,
          onChanged: (value) {
            _bloc.add(LeaveSelectedAll(
                isSelectAll: value!,
                leaveApprovalListPending: leaveApprovalListPending));
          },
        )),
        Padding(
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
                        _bloc.add(LeaveApproveSelected(
                            fromDate: dateF,
                            toDate: dateT,
                            leaveApprovalListPending: leaveApprovalListPending,
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
      ],
    );
  }

  Widget _buildQty({required int qty}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 0, 8.h),
      child: Text(
        '${'qty'.tr()}: $qty',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSearch() {
    return ValueListenableBuilder(
      valueListenable: _isExpanded,
      builder: (context, value, child) => ExpansionTile(
        initiallyExpanded: value,
        onExpansionChanged: (value) => _isExpanded.value = value,
        title: Text(
          'search'.tr(),
          style: TextStyle(
              color: value ? primaryColor : foregroundColor,
              fontWeight: FontWeight.w900),
        ),
        collapsedIconColor: value ? primaryColor : foregroundColor,
        collapsedBackgroundColor: primaryColor,
        childrenPadding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
        children: [
          Column(
            children: [
              _buildDecorationDropdown(
                  childDropdown: StreamBuilder(
                    stream: leaveTypeList.stream,
                    builder: (context, snapshot) {
                      return _buildDropdownStdCode(
                          list: snapshot.hasData ? snapshot.data ?? [] : [],
                          label: 'leavetype',
                          onChanged: (value) {
                            _stdTypeNotifier.value = value!.codeId!;
                            stdTypeSelected = value;
                          },
                          selected: stdTypeSelected);
                    },
                  ),
                  notifier: _stdTypeNotifier,
                  labelText: 'leavetype'),
              _buildDecorationDropdown(
                  childDropdown: StreamBuilder(
                    stream: leaveStatusList.stream,
                    builder: (context, snapshot) => _buildDropdownStdCode(
                      label: 'status'.tr(),
                      list: snapshot.hasData ? snapshot.data ?? [] : [],
                      selected: stdStatusSelected,
                      onChanged: (value) {
                        _stdStatusNotifier.value = value!.codeId!;
                        stdStatusSelected = value;
                      },
                    ),
                  ),
                  notifier: _stdStatusNotifier,
                  labelText: 'status'),
              ValueListenableBuilder(
                valueListenable: _isPending,
                builder: (context, value, child) => CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _isPending.value,
                    title: Text('ispending'.tr()),
                    onChanged: (value) {
                      _isPending.value = !_isPending.value;
                    }),
              )
            ],
          ),
          DefaultButton(
              buttonText: 'search',
              onPressed: () {
                _bloc.add(LeaveApprovalChangeType(
                    fromDate: dateF,
                    toDate: dateT,
                    stdType: stdTypeSelected,
                    stdStatus: stdStatusSelected,
                    isPending: _isPending.value));
              }),
        ],
      ),
    );
  }

  Widget _buildPickDate() {
    return DatePreviousNextView(
      fromDate: dateF,
      toDate: dateT,
      onTapPrevious: () {
        _bloc.add(LeaveApprovalChangeDate(
            stdType: stdTypeSelected,
            stdStatus: stdStatusSelected,
            isPending: _isPending.value,
            toDate: dateT,
            fromDate: dateF.subtract(const Duration(days: 1))));
      },
      onPickFromDate: (selectedDate) {
        _bloc.add(LeaveApprovalChangeDate(
            fromDate: selectedDate,
            toDate: dateT,
            stdType: stdTypeSelected,
            stdStatus: stdStatusSelected,
            isPending: _isPending.value));
      },
      onPickToDate: (selectedDate) {
        _bloc.add(LeaveApprovalChangeDate(
            fromDate: dateF,
            toDate: selectedDate,
            stdType: stdTypeSelected,
            stdStatus: stdStatusSelected,
            isPending: _isPending.value));
      },
      onTapNext: () {
        _bloc.add(LeaveApprovalChangeDate(
            toDate: dateT.add(const Duration(days: 1)),
            fromDate: dateF,
            stdType: stdTypeSelected,
            stdStatus: stdStatusSelected,
            isPending: _isPending.value));
      },
    );
  }

  Widget _buildLeaveApproval(
      {required BuildContext buildContext, required LeaveApprovalResult item}) {
    return InkWell(
      onTap: () async {
        final result = await _navigationService
            .navigateAndDisplaySelection(MyRoute.leaveDetailRoute, args: {
          KeyParams.lvNoLeave: item.lvNo,
          KeyParams.isApproveLeave: true
        });
        if (result != null) {
          _bloc.add(LeaveApprovalViewLoaded(appBloc: appBloc));
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Checkbox(
                    value: item.selected,
                    onChanged: (value) {
                      _bloc.add(LeaveSelected(
                          leaveApprovalListPending:
                              leaveApprovalListPending.value,
                          lvNo: item.lvNo ?? '',
                          selected: value!));
                    }),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ContainerPanelColor(text: item.lvNo ?? ''),
                          TextByTypeStatus(status: item.leaveStatus.toString())
                        ],
                      ),
                      _buildFullName(
                          content: item.employeeName ?? '',
                          content2: item.leaveDays.toString()),
                      _buildDate(
                        title: 'leaveperiod',
                        content: FormatDateLocal.format_dd_MM_yyyy(
                            item.fromDate.toString()),
                        content2: FormatDateLocal.format_dd_MM_yyyy(
                            item.toDate.toString()),
                      ),
                      _buildLeaveType(item: item)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate({
    required String title,
    required String content,
    required String content2,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Text(
            '${title.tr()}:',
            style: styleItem(),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            '$content  -  $content2',
            style: styleContent(),
          ),
        ),
      ]),
    );
  }

  Padding _buildLeaveType({required LeaveApprovalResult item}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: Row(children: [
        Expanded(
            flex: 2, child: Text('${"leavetype".tr()}:', style: styleItem())),
        Expanded(
          flex: 4,
          child: Text(
            item.leaveTypeDesc.toString(),
            style: styleContent(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            FormatDateLocal.format_dd_MM_yyyy(item.submitDate.toString()),
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: MyColor.textGrey,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3),
          ),
        ),
      ]),
    );
  }

  Widget _buildFullName({required String content, required String content2}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(flex: 2, child: Text('${'name'.tr()}:', style: styleItem())),
          Expanded(
            flex: 4,
            child: Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styleContent(),
            ),
          ),
          Expanded(
              flex: 2, child: Text('${'leavedate'.tr()}:', style: styleItem())),
          Expanded(
              flex: 1,
              child: Text(content2,
                  textAlign: TextAlign.end, style: styleContent())),
        ],
      ),
    );
  }

  Widget _buildDropdownStdCode(
          {required List<StdCode> list,
          required String label,
          StdCode? selected,
          required Function(StdCode?) onChanged}) =>
      DropdownButtonFormField2(
          isExpanded: true,
          hint: Text(
            label.tr(),
            style: LayoutCustom.hintStyle,
          ),
          items: list
              .map((item) => DropdownMenuItem<StdCode>(
                    value: item,
                    child: Text(
                      item.codeDesc ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selected,
          onChanged: onChanged,
          buttonStyleData: dropdown_custom.buttonStyleData,
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
  RowFlex333 buildDate({required LeaveApprovalResult item}) {
    return RowFlex333(
      child1: Column(
        children: [
          Text(
            "from".tr(),
            style: styleItem(),
          ),
          SizedBox(height: 8.h),
          DecoratedBox(
            decoration: BoxDecoration(
                color: MyColor.textBlack,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16.r),
                )),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                FormatDateLocal.format_dd_MM_yyyy(item.fromDate.toString()),
                style: const TextStyle(
                  color: MyColor.defaultColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      child2: Column(
        children: [
          Text(
            "to".tr(),
            style: styleItem(),
          ),
          SizedBox(height: 8.h),
          DecoratedBox(
            decoration: BoxDecoration(
                color: MyColor.defaultColor,
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(16.r),
                )),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                FormatDateLocal.format_dd_MM_yyyy(item.toDate.toString()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      child3: Column(
        children: [
          Text(
            "leave_date".tr(),
            style: styleItem(),
          ),
          SizedBox(height: 8.h),
          DecoratedBox(
            decoration: BoxDecoration(
                color: MyColor.outerSpace,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(16.r),
                  bottomStart: Radius.circular(16.r),
                )),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                item.leaveDays.toString(),
                style: const TextStyle(
                  color: MyColor.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorationDropdown(
      {required Widget childDropdown,
      required ValueNotifier notifier,
      required String labelText}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 6.h),
              child: Text(
                labelText.tr(),
                style: LayoutCustom.labelStyleRequired,
              ),
            ),
            ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, value, child) => DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        color: Colors.white,
                      ),
                      child: childDropdown,
                    )),
          ],
        ));
  }

  TextStyle styleItem() {
    return const TextStyle(
        color: MyColor.textBlack, fontWeight: FontWeight.w500);
  }

  TextStyle styleContent() {
    return TextStyle(
        color: MyColor.getTextColor(), fontWeight: FontWeight.w600);
  }
}
