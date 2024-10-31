// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:mpi_new/presentations/widgets/dialog/workflow_dialog.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class NewLeaveView extends StatefulWidget {
  const NewLeaveView({super.key});

  @override
  State<NewLeaveView> createState() => _NewLeaveViewState();
}

class _NewLeaveViewState extends State<NewLeaveView> {
  final _navigationService = getIt<NavigationService>();

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _reasonController = TextEditingController();
  final _handOverController = TextEditingController();
  final _handOverEmpController = TextEditingController();
  final _phoneController = TextEditingController();

// * Calendar
  DateTime now = DateTime.now();
  DateTime startDayCalendar = DateTime(DateTime.now().year, 1, 1);
  DateTime endDayCalendar = DateTime(DateTime.now().year, 12, 31);
  //* Calculator Date
  DateTime calDateFrom = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 00, 00, 00);
  DateTime calDateTo = DateTime.now();

  SessionType? selectedSession;

  bool isAddLeave = false;

  final ValueNotifier<SessionType> _sessionNotifier =
      ValueNotifier<SessionType>(
    SessionType(session: "morning".tr(), sessionCode: 2, sessionId: 'AM'),
  );

  final ValueNotifier<num> _totalDateNotifier = ValueNotifier(0.0);

  final _formKey = GlobalKey<FormState>();
  late AppBloc appBloc;
  late NewLeaveBloc newLeaveBloc;
  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    newLeaveBloc = BlocProvider.of<NewLeaveBloc>(context)
      ..add(NewLeaveLoaded(appBloc: appBloc));
  }

  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;

  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: "newleave",
        onPressBack: isAddLeave == true
            ? () {
                _navigationService.pushNamed(MyRoute.leaveRoute,
                    args: {KeyParams.isAddLeave: isAddLeave});
              }
            : null,
      ),
      body: BlocConsumer<NewLeaveBloc, NewLeaveState>(
        listener: (context, state) {
          if (state is NewLeaveSuccessfully) {
            isAddLeave = true;
            MyDialog.showSuccess(
              message: 'addsuccess'.tr(),
              context: context,
              pressContinue: () {},
              whenComplete: () {
                _navigationService.pushNamed(MyRoute.leaveRoute,
                    args: {KeyParams.isAddLeave: isAddLeave});
              },
            );
          }
          if (state is NewLeaveFailure) {
            if (state.errorCode == MyError.errCodeNewLeave) {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    newLeaveBloc.add(NewLeaveLoaded(appBloc: appBloc));
                  });
            } else {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    newLeaveBloc.add(NewLeaveLoaded(appBloc: appBloc));
                  });
            }
          }
        },
        builder: (context, state) {
          if (state is NewLeaveLoadSuccess) {
            _fromDateController.text =
                FormatDateConstants.convertddMMyyyyFromDateTime(state.fromDate);
            _toDateController.text =
                FormatDateConstants.convertddMMyyyyFromDateTime(state.toDate);
            _totalDateNotifier.value = state.calDate;
            _phoneController.text = state.phoneNumber;
            _sessionNotifier.value = state.sessionType;
            selectedSession = state.sessionType;
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  buildWorkFlow(context, state),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, top: 6.h),
                        child: TextRichRequired(label: "leavetype".tr()),
                      ),
                      buildRow1(state),
                      _buildFromDateToDate(state: state),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, top: 6.h),
                        child: TextRichRequired(label: "leavedate".tr()),
                      ),
                      _buildCalulatorLeave(state: state),
                      InputTextFieldNew(
                          isRequired: true,
                          controller: _reasonController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return MyError.errNullReason;
                            }
                            return null;
                          },
                          labelText: 'leavereason'),
                      InputTextFieldNew(
                          isRequired: true,
                          controller: _handOverController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return MyError.errNullHandover;
                            }
                            return null;
                          },
                          labelText: 'handoverjob'),
                      InputTextFieldNew(
                          isRequired: true,
                          controller: _handOverEmpController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return MyError.errNullHandoverEmp;
                            }
                            return null;
                          },
                          labelText: 'handoveremployee'),
                      InputTextFieldNew(
                          type: TextInputType.phone,
                          isRequired: true,
                          controller: _phoneController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return MyError.erNullPhone;
                            }
                            return null;
                          },
                          labelText: 'contactphone'),
                    ],
                  ),
                  DefaultButton(
                    paddingTop: true,
                    buttonText: "submit".tr(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String remark =
                            "- Lý Do Nghỉ: ${_reasonController.text}\n- Công Việc Bàn Giao: ${_handOverController.text}\n- Người Nhận Bàn Giao: ${_handOverEmpController.text}\n- Thông Tin Liên Lạc: ${_phoneController.text}";
                        newLeaveBloc.add(NewLeaveSubmit(remark: remark));
                      }
                    },
                  ),
                ],
              ),
            );
          }
          return const ItemLoading();
        },
      ),
    );
  }

  Widget _buildCalulatorLeave({required NewLeaveLoadSuccess state}) {
    return Padding(
      padding: LayoutCustom.paddingVerticalItemView,
      child: RowFlex5and5(
          crossAxisAlignment: CrossAxisAlignment.center,
          left: chooseSession(state: state),
          spacer: true,
          right: _buildCalculatorDate(state: state)),
    );
  }

  Widget _buildFromDateToDate({required NewLeaveLoadSuccess state}) {
    return Padding(
      padding: LayoutCustom.paddingVerticalItemView,
      child: RowFlex5and5(
          left: InputTextFieldNew(
              labelText: 'from',
              readOnly: true,
              isRequired: true,
              controller: _fromDateController,
              suffixIcon: IconButton(
                onPressed: () async {
                  DateTime? fromDate = await showDatePicker(
                    context: context,
                    initialDate: state.fromDate,
                    firstDate: startDayCalendar,
                    lastDate: endDayCalendar,
                  );
                  newLeaveBloc.add(NewLeaveChangeFromDate(
                      fromDate: fromDate ?? state.fromDate,
                      divisionCode:
                          appBloc.subsidiaryInfo?.divisionCode ?? ''));
                },
                icon: iconCalendar(),
              )),
          spacer: true,
          right: InputTextFieldNew(
              labelText: 'to',
              readOnly: true,
              isRequired: true,
              controller: _toDateController,
              suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? toDate = await showDatePicker(
                      context: context,
                      initialDate: state.toDate,
                      firstDate: state.fromDate,
                      lastDate: endDayCalendar,
                    );
                    newLeaveBloc.add(NewLeaveChangeToDate(
                        toDate: toDate ?? state.toDate,
                        divisionCode:
                            appBloc.subsidiaryInfo?.divisionCode ?? ''));
                  },
                  icon: iconCalendar()))),
    );
  }

  ValueListenableBuilder<num> _buildCalculatorDate(
      {required NewLeaveLoadSuccess state}) {
    return ValueListenableBuilder(
      valueListenable: _totalDateNotifier,
      builder: (context, value, child) {
        return RowFlex7and3(
          child7: Text("leavedate".tr()),
          child3: Text(state.calDate.toString(), style: styleContent()),
        );
      },
    );
  }

  Widget chooseSession({required NewLeaveLoadSuccess state}) {
    return ValueListenableBuilder(
      valueListenable: _sessionNotifier,
      builder: (context, value, child) => DropdownButtonFormField2<SessionType>(
        buttonStyleData: dropdown_custom.buttonStyleData,
        isExpanded: true,
        hint: Text(
          'choosesession'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        validator: (value) {
          if (value == null) {
            return MyError.errNullChooseSession;
          }

          return null;
        },
        items: state.sessionTypes
            .map((item) => DropdownMenuItem<SessionType>(
                  value: item,
                  child: Text(
                    item.session,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedSession,
        onChanged: _fromDateController.text == _toDateController.text
            ? (value) {
                value as SessionType;
                newLeaveBloc.add(NewLeaveChangeSesionType(
                    sessionType: value,
                    divisionCode: appBloc.subsidiaryInfo?.divisionCode ?? ''));
              }
            : null,
        dropdownStyleData: DropdownStyleData(
            elevation: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            )),
        selectedItemBuilder: (context) {
          return state.sessionTypes.map((e) {
            return Text(e.session,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 14));
          }).toList();
        },
        menuItemStyleData: dropdown_custom.menuItemStyleData,
      ),
    );
  }

  Padding buildRow1(NewLeaveLoadSuccess state) {
    return Padding(
      padding: LayoutCustom.paddingVerticalItemView,
      child: RowFlex5and5(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacer: true,
          left: buildLeaveType(state),
          right: RowFlex7and3(
              child7: Text("dateavailability".tr()),
              child3: Text(
                  state.leaveResponse == null
                      ? "0.0"
                      : state.leaveResponse!.balance.toString(),
                  style: styleContent()))),
    );
  }

  TextStyle styleContent() {
    return const TextStyle(
        color: MyColor.textBlack, fontWeight: FontWeight.bold);
  }

  Widget buildLeaveType(NewLeaveLoadSuccess state) {
    return DropdownButtonFormField2<StdCode>(
      validator: (value) {
        if (value == null) {
          return MyError.errNullDateType;
        } else if ((state.leaveResponse!.balance == 0 &&
                state.typeLeave!.codeId == "ANNU") ||
            (state.leaveResponse!.balance == 0 &&
                state.typeLeave!.codeId == "ANNPR")) {
          return "nothaveleave".tr();
        } else if ((state.leaveResponse!.balance! < state.calDate &&
                state.typeLeave!.codeId == 'ANNU') ||
            (state.leaveResponse!.balance! < state.calDate &&
                state.typeLeave!.codeId == 'ANNPR')) {
          return "notenoughleave".tr();
        }
        return null;
      },
      buttonStyleData: dropdown_custom.buttonStyleData,
      isExpanded: true,
      hint: Text(
        "choosetypeleave".tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: LayoutCustom.hintStyle,
      ),
      items: state.listStdCodeHr!
          .map((item) => DropdownMenuItem<StdCode>(
                value: item,
                child: Text(
                  item.codeDesc
                      .toString()
                      .replaceAll(' ', '')
                      .toLowerCase()
                      .tr()
                      .replaceAll('(', ' ('),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      value: state.typeLeave,
      dropdownStyleData: DropdownStyleData(
          elevation: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          )),
      onChanged: (value) {
        value as StdCode;
        newLeaveBloc.add(NewLeaveChangeTypeLeave(
            typeLeave: value, phoneNumber: _phoneController.text));
      },
      selectedItemBuilder: (context) {
        return state.listStdCodeHr!.map((e) {
          return Text(
            e.codeDesc
                .toString()
                .replaceAll(' ', '')
                .toLowerCase()
                .tr()
                .replaceAll('(', ' ('),
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14),
          );
        }).toList();
      },
      menuItemStyleData: dropdown_custom.menuItemStyleData,
    );
  }

  InkWell buildWorkFlow(BuildContext context, NewLeaveLoadSuccess state) {
    return InkWell(
      onTap: () {
        showDialogWorkFlow(context: context, workflowList: state.workFlow ?? [])
            .show();
      },
      child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              color: backgroundPanel,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.r),
                bottomRight: Radius.circular(15.r),
              )),
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: 'viewworkflow'.tr(),
                style:
                    TextStyle(color: colorPanel, fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' ${'here'.tr()}',
                style: const TextStyle(
                    color: MyColor.nokiaBlue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline)),
          ]))),
    );
  }

  Icon iconCalendar() {
    return const Icon(
      Icons.calendar_month,
      size: 30,
    );
  }

  DateTime parseDateString(String dateString) {
    List<String> dateParts = dateString.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      errorStyle: const TextStyle(
        height: 0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }
}

class SessionType {
  final String session;
  final int sessionCode;
  final String sessionId;
  SessionType({
    required this.session,
    required this.sessionCode,
    required this.sessionId,
  });
}
