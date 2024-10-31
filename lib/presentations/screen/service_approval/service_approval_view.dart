import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:mpi_new/presentations/widgets/date_previous_next/date_previous_next.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';
import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class ServiceApprovalView extends StatefulWidget {
  const ServiceApprovalView({super.key});

  @override
  State<ServiceApprovalView> createState() => _ServiceApprovalViewState();
}

class _ServiceApprovalViewState extends State<ServiceApprovalView> {
  final ValueNotifier _applicationNotifier = ValueNotifier('');
  ApplicationResponse? applicationSelected;

  final ValueNotifier _stdStatusNotifier = ValueNotifier('');
  StdCode? stdStatusSelected;

  final ValueNotifier _stdCostCenterNotifier = ValueNotifier('');
  StdCode? stdCostCenterSelected;
  final TextEditingController _codeController = TextEditingController();
  late ServiceApprovalBloc _bloc;
  late AppBloc appBloc;
  final ValueNotifier _isPending = ValueNotifier(false);

  final ScrollController _scrollController = ScrollController();
  BehaviorSubject<List<ServiceApprovalResult>> svrApprLst = BehaviorSubject();
  int quantity = 0;

  BehaviorSubject<List<ApplicationResponse>> applicationList =
      BehaviorSubject();
  BehaviorSubject<List<StdCode>> stdCodeList = BehaviorSubject();
  BehaviorSubject<List<StdCode>> stdCodeCostCenterList = BehaviorSubject();
  DateTime dateF = DateTime.now();
  DateTime dateT = DateTime.now();
  @override
  void initState() {
    appBloc = BlocProvider.of<AppBloc>(context);
    _bloc = BlocProvider.of<ServiceApprovalBloc>(context)
      ..add(ServiceApprovalViewLoaded(appBloc: appBloc));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(ServiceApprovalPaging(
          fromDate: dateF,
          toDate: dateT,
          isPending: _isPending.value,
          application: applicationSelected,
          code: _codeController.text,
          costCenter: stdCostCenterSelected,
          status: stdStatusSelected,
        )); //hardcode
      }
    });
    super.initState();
  }

  final _navigationService = getIt<NavigationService>();
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);

  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    Color primaryColor = Theme.of(context).primaryColor;
    Color foregroundColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarCustom(context, title: 'gn003'),
      body: BlocListener<ServiceApprovalBloc, ServiceApprovalState>(
        listener: (context, state) {
          if (state is ServiceApprovalFailure) {
            MyDialog.showError(
                text: 'close'.tr(),
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {
                  _bloc.add(ServiceApprovalViewLoaded(appBloc: appBloc));
                });
          }
          if (state is ServiceApprovalSuccess) {
            _isPending.value = state.isPending;
            svrApprLst.add(state.serviceApprovalList);
            applicationList.add(state.applicationList ?? []);
            stdCodeList.add(state.stdCodeList ?? []);
            stdCodeCostCenterList.add(state.stdCodeCostCenterList ?? []);
            dateF = state.fromDate;
            dateT = state.toDate;
            quantity = state.quantity;
          }
          if (state is GetServiceApprovalSuccess) {
            svrApprLst.add(state.serviceApprovalList);
            quantity = state.quantity;
          }
        },
        child: BlocBuilder<ServiceApprovalBloc, ServiceApprovalState>(
          builder: (context, state) {
            if (state is ServiceApprovalLoading) {
              return const ItemLoading();
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePreviousNextView(
                    fromDate: dateF,
                    toDate: dateT,
                    onTapPrevious: () {
                      _bloc.add(ServiceApprovalChangeDate(
                        isPending: _isPending.value,
                        application: applicationSelected,
                        code: _codeController.text,
                        costCenter: stdCostCenterSelected,
                        status: stdStatusSelected,
                        toDate: dateT,
                        fromDate: dateF.subtract(const Duration(days: 1)),
                      ));
                    },
                    onPickFromDate: (selectedDate) {
                      _bloc.add(ServiceApprovalChangeDate(
                          isPending: _isPending.value,
                          application: applicationSelected,
                          code: _codeController.text,
                          costCenter: stdCostCenterSelected,
                          status: stdStatusSelected,
                          toDate: dateT,
                          fromDate: selectedDate));
                    },
                    onPickToDate: (selectedDate) {
                      _bloc.add(ServiceApprovalChangeDate(
                          isPending: _isPending.value,
                          application: applicationSelected,
                          code: _codeController.text,
                          costCenter: stdCostCenterSelected,
                          status: stdStatusSelected,
                          fromDate: dateF,
                          toDate: selectedDate));
                    },
                    onTapNext: () {
                      _bloc.add(ServiceApprovalChangeDate(
                        isPending: _isPending.value,
                        application: applicationSelected,
                        code: _codeController.text,
                        costCenter: stdCostCenterSelected,
                        status: stdStatusSelected,
                        fromDate: dateF,
                        toDate: dateT.add(const Duration(days: 1)),
                      ));
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isExpanded,
                    builder: (context, value, child) => ExpansionTile(
                        initiallyExpanded: value,
                        onExpansionChanged: (value) =>
                            _isExpanded.value = value,
                        childrenPadding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
                        title: Text(
                          'search'.tr(),
                          style: TextStyle(
                              color: value ? primaryColor : foregroundColor,
                              fontWeight: FontWeight.w900),
                        ),
                        collapsedIconColor:
                            value ? primaryColor : foregroundColor,
                        collapsedBackgroundColor: primaryColor,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 8.h,
                              ),
                              InputTextFieldNew(
                                controller: _codeController,
                                labelText: 'svrno',
                              ),
                              _buildDecorationDropdown(
                                  childDropdown: StreamBuilder(
                                    stream: applicationList.stream,
                                    builder: (context, snapshot) =>
                                        _buildDropdownApplication(
                                            list: snapshot.hasData
                                                ? snapshot.data!
                                                : []),
                                  ),
                                  notifier: _applicationNotifier,
                                  labelText: 'application'),
                              RowFlex5and5(
                                left: _buildDecorationDropdown(
                                    childDropdown: StreamBuilder(
                                      stream: stdCodeList.stream,
                                      builder: (context, snapshot) =>
                                          _buildDropdownStdCodeStatus(
                                              label: 'status',
                                              list: snapshot.hasData
                                                  ? snapshot.data!
                                                  : []),
                                    ),
                                    notifier: _stdStatusNotifier,
                                    labelText: 'status'),
                                right: _buildDecorationDropdown(
                                    childDropdown: StreamBuilder(
                                      stream: stdCodeCostCenterList.stream,
                                      builder: (context, snapshot) =>
                                          _buildDropdownStdCodeCostCenter(
                                              label: 'costcenter',
                                              list: snapshot.hasData
                                                  ? snapshot.data!
                                                  : []),
                                    ),
                                    notifier: _stdCostCenterNotifier,
                                    labelText: 'costcenter'),
                                spacer: true,
                              ),
                              ValueListenableBuilder(
                                valueListenable: _isPending,
                                builder: (context, value, child) =>
                                    CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _isPending.value,
                                        title: Text('ispending'.tr()),
                                        onChanged: (value) {
                                          _isPending.value = !_isPending.value;
                                        }),
                              ),
                              DefaultButton(
                                  buttonText: 'search',
                                  onPressed: () {
                                    _bloc.add(ServiceApprovalChangeDate(
                                        fromDate: dateF,
                                        toDate: dateT,
                                        isPending: _isPending.value,
                                        application: applicationSelected,
                                        code: _codeController.text,
                                        costCenter: stdCostCenterSelected,
                                        status: stdStatusSelected));
                                  }),
                            ],
                          ),
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 0, 8.h),
                    child: Text(
                      '${'quantity'.tr()}: $quantity',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _bloc.add(ServiceApprovalChangeDate(
                          fromDate: dateF,
                          toDate: dateT,
                        ));
                      },
                      child: StreamBuilder(
                        stream: svrApprLst.stream,
                        builder: (context, snapshot) {
                          return snapshot.hasData &&
                                  snapshot.data != [] &&
                                  snapshot.data!.isNotEmpty
                              ? Scrollbar(
                                  controller: _scrollController,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.only(
                                          bottom: 48.h,
                                          left: 16.w,
                                          right: 16.w),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context1, index) =>
                                          _buildServiceApproval(
                                              buildContext: context,
                                              item: snapshot.data![index])),
                                )
                              : ListView(children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.4,
                                      child: const EmptyWidget())
                                ]);
                        },
                      ),
                    ),
                  ),
                  state is ServiceApprovalPagingLoading
                      ? const PagingLoading()
                      : const SizedBox()
                ]);
          },
        ),
      ),
    );
  }

  Widget _buildRowItem3(
      {required String label, required String content, required int item3}) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
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

  Widget _buildServiceApproval(
      {required BuildContext buildContext,
      required ServiceApprovalResult item}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () async {
          final result = await _navigationService.navigateAndDisplaySelection(
              MyRoute.serviceRequestDetailRoute,
              args: {
                KeyParams.svrNo: item.svrNo,
                KeyParams.isApproveSVR: true
              });
          if (result != null) {
            _bloc.add(ServiceApprovalViewLoaded(appBloc: appBloc));
          }
        },
        child: Padding(
          padding: EdgeInsets.only(right: 8.w, top: 8.h),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ContainerPanelColor(text: item.svrNo ?? ''),
                  TextByTypeStatus(status: item.svrStatus.toString())
                ],
              ),
              Padding(
                padding: LayoutCustom.paddingItemCard,
                child: Column(
                  children: [
                    _buildRowItem(
                        label: 'subject', content: item.svrSubject ?? ''),
                    _buildRowItem(
                        label: 'servicetype', content: item.application ?? ''),
                    _buildRowItem(
                        label: 'name', content: item.createUserName ?? ''),
                    _buildRowItem3(
                        label: 'duedate',
                        content: FormatDateLocal.format_dd_MM_yyyy(
                            item.dueDate.toString()),
                        item3: item.createDate ?? 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem({required String label, required String content}) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
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
            flex: 2,
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
              padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
              child: Text(
                labelText.tr(),
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
                      child: childDropdown,
                    )),
          ],
        ));
  }

  Widget _buildDropdownStdCodeStatus(
          {required List<StdCode> list, required String label}) =>
      DropdownButtonFormField2(
          isExpanded: true,
          hint: Text(
            label.tr(),
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
            _applicationNotifier.value = value!.codeId!;
            stdStatusSelected = value;
          },
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
  Widget _buildDropdownStdCodeCostCenter(
          {required List<StdCode> list, required String label}) =>
      DropdownButtonFormField2(
          isExpanded: true,
          hint: Text(
            label.tr(),
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
          value: stdCostCenterSelected,
          onChanged: (value) {
            _stdCostCenterNotifier.value = value!.codeId!;
            stdCostCenterSelected = value;
          },
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
  Widget _buildDropdownApplication({required List<ApplicationResponse> list}) =>
      DropdownButtonFormField2(
          isExpanded: true,
          hint: Text(
            'application'.tr(),
            style: LayoutCustom.hintStyle,
          ),
          buttonStyleData: dropdown_custom.buttonStyleData,
          items: list
              .map((item) => DropdownMenuItem<ApplicationResponse>(
                    value: item,
                    child: Text(
                      item.applicationDesc ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: applicationSelected,
          onChanged: (value) {
            _applicationNotifier.value = value!.applicationCode!;
            applicationSelected = value;
          },
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
}
