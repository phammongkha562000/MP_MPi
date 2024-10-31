// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:rxdart/rxdart.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';

class ITServiceView extends StatefulWidget {
  const ITServiceView({super.key});

  @override
  State<ITServiceView> createState() => _ITServiceViewState();
}

class _ITServiceViewState extends State<ITServiceView> {
  final _navigationService = getIt<NavigationService>();

  DateTime dateF = DateTime.now();
  DateTime dateT = DateTime.now();

  final ValueNotifier<StdCode> _srStatusNotifier =
      ValueNotifier<StdCode>(StdCode());

  final ValueNotifier<StdCode> _itServiceNotifier =
      ValueNotifier<StdCode>(StdCode());
  final ValueNotifier<StdCode> _serviceTypeNotifier =
      ValueNotifier<StdCode>(StdCode());

  StdCode? selectedITService;
  StdCode? selectedSVC;
  StdCode? selectedSrStatus;

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  final _irsNoController = TextEditingController();
  final _createUserController = TextEditingController();
  final _subjectController = TextEditingController();

  DateTime toDay = DateTime.now();
  DateTime startDay = DateTime(2000);
  DateTime endDay = DateTime(2200);

  final ScrollController _scrollController = ScrollController();

  BehaviorSubject<List<ITServiceResult>> itSvrLst = BehaviorSubject();
  int quantity = 0;

  BehaviorSubject<List<StdCode>> listSrStatus = BehaviorSubject();
  BehaviorSubject<List<StdCode>> listItService = BehaviorSubject();
  BehaviorSubject<List<StdCode>> listSVC = BehaviorSubject();

  late ITServiceBloc itServiceBloc;
  late AppBloc appBloc;

  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    itServiceBloc = BlocProvider.of<ITServiceBloc>(context)
      ..add(ITServiceLoaded(
          appBloc: appBloc,
          dateTo: DateTime(dateT.year, dateT.month + 1, 0),
          dateFrom: DateTime(dateF.year, dateF.month, 1)));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        itServiceBloc.add(ITServicePaging(
          dateFrom: dateF,
          dateTo: dateT,
          isSearch: true,
          irsNo: _irsNoController.text.toUpperCase(),
          createUser: _createUserController.text,
          srStatus: _srStatusNotifier.value.codeId,
          stdITServiceType: _itServiceNotifier.value.codeId,
          subject: _subjectController.text,
          svc: _serviceTypeNotifier.value.codeId,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return BlocListener<ITServiceBloc, ITServiceState>(
      listener: (context, state) {
        if (state is ITServiceFailure) {
          MyDialog.showError(
              context: context,
              messageError: state.message,
              pressTryAgain: () {
                Navigator.pop(context);
              },
              whenComplete: () {
                BlocProvider.of<ITServiceBloc>(context).add(ITServiceLoaded(
                    appBloc: appBloc,
                    dateTo: DateTime(dateT.year, dateT.month + 1, 0),
                    dateFrom: DateTime(dateF.year, dateF.month, 1)));
              });
        }
        if (state is ITServiceLoadSuccess) {
          // * setDate use by loading
          dateF = state.dateF;
          dateT = state.dateT;
          _fromDateController.text =
              FindDate.firstDateOfMonth_ddMMyyyy(today: state.dateF);
          _toDateController.text =
              FindDate.lastDateOfMonth_ddMMyyyy(today: state.dateT);
          itSvrLst.add(state.listITServiceSearch);
          listSrStatus.add(state.listSrStatus ?? []);
          listItService.add(state.listItService ?? []);
          listSVC.add(state.listSVC ?? []);
          quantity = state.quantity;
        }
        if (state is ITServiceSearchSuccess) {
          // * setDate use by loading
          dateF = state.dateF;
          dateT = state.dateT;
          _fromDateController.text =
              FindDate.firstDateOfMonth_ddMMyyyy(today: state.dateF);
          _toDateController.text =
              FindDate.lastDateOfMonth_ddMMyyyy(today: state.dateT);
          itSvrLst.add(state.listITServiceSearch);

          quantity = state.quantity;
        }
      },
      child:
          BlocBuilder<ITServiceBloc, ITServiceState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBarCustom(
            context,
            title: "itservice",
            onPressBack: () {
              _navigationService.pushNamedAndRemoveUntil(MyRoute.homePageRoute);
            },
            actionRight: actionRight(context),
          ),
          body: StreamBuilder(
            stream: itSvrLst.stream,
            builder: (context, snapshot) {
              return PickDatePreviousNextWidget(
                isMonth: true,
                onTapPrevious: () {
                  BlocProvider.of<ITServiceBloc>(context)
                      .add(ITServiceChangeMonth(
                    dateTo: DateTime(dateF.year, dateF.month, 0),
                    dateFrom: DateTime(dateF.year, dateF.month - 1, 1),
                    isSearch: true,
                    irsNo: _irsNoController.text.toUpperCase(),
                    createUser: _createUserController.text,
                    srStatus: _srStatusNotifier.value.codeId,
                    stdITServiceType: _itServiceNotifier.value.codeId,
                    subject: _subjectController.text,
                    svc: _serviceTypeNotifier.value.codeId,
                  ));
                },
                onTapNext: () {
                  BlocProvider.of<ITServiceBloc>(context)
                      .add(ITServiceChangeMonth(
                    dateTo: DateTime(dateF.year, dateF.month + 2, 0),
                    dateFrom: DateTime(dateF.year, dateF.month + 1, 1),
                    isSearch: true,
                    irsNo: _irsNoController.text.toUpperCase(),
                    createUser: _createUserController.text,
                    srStatus: _srStatusNotifier.value.codeId,
                    stdITServiceType: _itServiceNotifier.value.codeId,
                    subject: _subjectController.text,
                    svc: _serviceTypeNotifier.value.codeId,
                  ));
                },
                onTapPick: (value) {
                  BlocProvider.of<ITServiceBloc>(context)
                      .add(ITServiceChangeMonth(
                    dateTo: DateTime(value.year, value.month + 1, 0),
                    dateFrom: DateTime(value.year, value.month, 1),
                    isSearch: true,
                    irsNo: _irsNoController.text.toUpperCase(),
                    createUser: _createUserController.text,
                    srStatus: _srStatusNotifier.value.codeId,
                    stdITServiceType: _itServiceNotifier.value.codeId,
                    subject: _subjectController.text,
                    svc: _serviceTypeNotifier.value.codeId,
                  ));
                },
                stateDate: dateF,
                quantityText: "${"quantity".tr()}: $quantity",
                child: Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<ITServiceBloc>(context)
                          .add(ITServiceLoaded(
                        appBloc: appBloc,
                        dateFrom: dateF,
                        dateTo: dateT,
                        isSearch: false,
                      ));
                      cleanDataSearch();
                    },
                    child: (!snapshot.hasData ||
                            snapshot.data!.isEmpty ||
                            snapshot.data == null)
                        ? empty(context)
                        : Scrollbar(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.only(
                                  bottom: 48.h, left: 16.w, right: 16.w),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data![index];
                                return _buildCard(item: item);
                              },
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        );
      }
              /*  return scaffoldLoading(context);
        }, */
              ),
    );
  }

  Widget _buildCard({required ITServiceResult item}) {
    return InkWell(
      onTap: () {
        log("ISR: ${item.isrNo}");
        _navigationService.pushNamed(MyRoute.itServiceDetailRoute, args: {
          KeyParams.irsNo: item.isrNo,
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            irsNo(item),
            Padding(
              padding: LayoutCustom.paddingItemCard,
              child: Column(
                children: [
                  itemRow(
                    title: "createuser",
                    data: item.createUser ?? "",
                  ),
                  itemRow(
                    title: "subject",
                    data: item.srSubject ?? "",
                  ),
                  itemRow(
                    title: "division",
                    data: item.department ?? "",
                  ),
                  RowFlex4and6(
                    child4: Text("status".tr()),
                    child6: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextByTypeStatus(status: item.srStatus.toString()),
                        Text(
                            FormatDateLocal.format_dd_MM_yyyy(
                                item.postDate.toString()),
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> actionRight(BuildContext context) {
    final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r));
    return [
      IconButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              builder: (contextModal) {
                return SizedBox(
                  height: 500,
                  child: Column(
                    children: [
                      Expanded(
                        // flex: 0,
                        child: listViewSearch(contextModal: contextModal),
                      ),
                      Expanded(
                        flex: -1,
                        child: DefaultButton(
                          buttonText: "search",
                          onPressed: () {
                            BlocProvider.of<ITServiceBloc>(context).add(
                              ITServiceLoaded(
                                appBloc: appBloc,
                                isSearch: true,
                                dateFrom: FormatDateLocal.parseDateFromString(
                                    _fromDateController.text),
                                dateTo: FormatDateLocal.parseDateFromString(
                                    _toDateController.text),
                                irsNo: _irsNoController.text.toUpperCase(),
                                createUser: _createUserController.text,
                                srStatus: _srStatusNotifier.value.codeId,
                                stdITServiceType:
                                    _itServiceNotifier.value.codeId,
                                subject: _subjectController.text,
                                svc: _serviceTypeNotifier.value.codeId,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.search)),
      IconButton(
          onPressed: () {
            _navigationService.pushNamed(MyRoute.itServiceNewRequestRoute);
          },
          icon: const Icon(Icons.add)),
    ];
  }

  Widget listViewSearch({required BuildContext contextModal}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: ListView(
        padding: EdgeInsets.only(top: 10.h),
        children: [
          buildDate(
            _fromDateController,
            contextModal,
            toDay,
            startDay,
            endDay,
            _toDateController,
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconCustom(iConURL: MyAssets.icNumber, size: 28),
            title: buildField(
              controller: _irsNoController,
              label: "irsno",
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconCustom(iConURL: MyAssets.avt, size: 28),
            title: buildField(
              controller: _createUserController,
              label: "createuser",
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconCustom(
              iConURL: MyAssets.icDropDown,
              size: 28,
            ),
            title: StreamBuilder(
              stream: listSrStatus.stream,
              builder: (context, snapshot) {
                return buildDropDownStdCode(
                  valueNotifier: _srStatusNotifier,
                  listStdCode: snapshot.hasData ? snapshot.data ?? [] : [],
                  hintText: "choosesrstatus",
                  selectedValue: selectedSrStatus,
                  onChanged: (value) {
                    value as StdCode;
                    _srStatusNotifier.value = value;
                    selectedSrStatus = value;
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconCustom(
              iConURL: MyAssets.icDropDown,
              size: 28,
            ),
            title: StreamBuilder(
              stream: listItService.stream,
              builder: (context, snapshot) {
                return buildDropDownStdCode(
                  valueNotifier: _itServiceNotifier,
                  listStdCode: snapshot.hasData ? snapshot.data ?? [] : [],
                  hintText: "chooseitservice",
                  selectedValue: selectedITService,
                  onChanged: (value) {
                    value as StdCode;
                    _itServiceNotifier.value = value;
                    selectedITService = value;
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconCustom(iConURL: MyAssets.icSubject, size: 28),
            title: buildField(
              controller: _subjectController,
              label: "subject",
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const IconCustom(
              iConURL: MyAssets.icDropDown,
              size: 28,
            ),
            title: StreamBuilder(
              stream: listSVC.stream,
              builder: (context, snapshot) {
                return buildDropDownStdCode(
                  valueNotifier: _serviceTypeNotifier,
                  listStdCode: snapshot.hasData ? snapshot.data ?? [] : [],
                  hintText: "choosesvc",
                  selectedValue: selectedSVC,
                  onChanged: (value) {
                    value as StdCode;
                    _serviceTypeNotifier.value = value;
                    selectedSVC = value;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        label: Text(
          label.tr(),
        ),
      ),
    );
  }

  ValueListenableBuilder<StdCode> buildDropDownStdCode({
    required ValueNotifier<StdCode> valueNotifier,
    required List<StdCode> listStdCode,
    required String hintText,
    required StdCode? selectedValue,
    required Function(StdCode?) onChanged,
  }) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return DropdownButtonFormField2<StdCode>(
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w)),
          buttonStyleData: dropdown_custom.buttonStyleData,
          isExpanded: true,
          hint: Text(
            hintText.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: MyColor.btnGreyDisable),
          ),
          items: listStdCode
              .map((item) => DropdownMenuItem<StdCode>(
                    value: item,
                    child: Text(
                      item.codeDesc.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: onChanged,
          selectedItemBuilder: (context) {
            return listStdCode.map((e) {
              return Text(
                e.codeDesc ?? '',
                textAlign: TextAlign.left,
              );
            }).toList();
          },
          menuItemStyleData: dropdown_custom.menuItemStyleData,
        );
      },
    );
  }

  Widget scaffoldLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(context, title: "itservice", onPressBack: () {
        _navigationService.pushNamed(MyRoute.homePageRoute);
      }, actionRight: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ]),
      body: buildLoading(dateF),
    );
  }

  Widget buildDate(
      TextEditingController fromDateController,
      BuildContext contextModal,
      DateTime toDay,
      DateTime startDay,
      DateTime endDay,
      TextEditingController toDateController) {
    return RowFlex5and5(
      left: InkWell(
        onTap: () async {
          DateTime? fromDate = await showDatePicker(
            context: contextModal,
            initialDate: toDay,
            firstDate: startDay,
            lastDate: endDay,
          );
          if (fromDate != null) {
            String formattedStartDate =
                DateFormat(MyConstants.ddMMyyyySlash, "en").format(fromDate);
            fromDateController.text = formattedStartDate;

            toDateController.text = formattedStartDate;
          }
        },
        child: InputTextFieldNew(
            suffixIcon: const Icon(
              Icons.calendar_month,
            ),
            enabled: false,
            controller: fromDateController,
            labelText: 'fromdate'),
      ),
      right: InkWell(
        onTap: () async {
          DateTime? toDate = await showDatePicker(
            context: contextModal,
            initialDate:
                FormatDateLocal.parseDateFromString(toDateController.text),
            firstDate:
                FormatDateLocal.parseDateFromString(toDateController.text),
            lastDate: endDay,
          );
          if (toDate != null) {
            String formattedToDate =
                DateFormat(MyConstants.ddMMyyyySlash, "en").format(toDate);
            toDateController.text = formattedToDate;
          }
        },
        child: InputTextFieldNew(
            suffixIcon: const Icon(
              Icons.calendar_month,
            ),
            enabled: false,
            controller: toDateController,
            labelText: 'todate'),
      ),
      spacer: true,
    );
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
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 5)
      ],
    );
  }

  Padding irsNo(ITServiceResult item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ContainerPanelColor(text: item.isrNo ?? ''),
          ContainerPanelColor(isRight: true, text: item.itServiceDesc ?? ''),
        ],
      ),
    );
  }

  ListView empty(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.8,
          child: const EmptyWidget(),
        ),
      ],
    );
  }

  TextStyle styleTitle() {
    return TextStyle(
      color: colorPanel,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      letterSpacing: 0.3,
    );
  }

  PickDatePreviousNextWidget buildLoading(DateTime? date) {
    return PickDatePreviousNextWidget(
      isMonth: true,
      onTapPrevious: () {},
      onTapNext: () {},
      onTapPick: () {},
      stateDate: date ?? DateTime.now(),
      quantityText: "${"quantity".tr()}: 0",
      child: const ItemLoading(),
    );
  }

  void cleanDataSearch() {
    _irsNoController.clear();
    _createUserController.clear();
    selectedSrStatus = null;
    selectedITService = null;
    _subjectController.clear();
    selectedSVC = null;
  }
}
