import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:mpi_new/presentations/widgets/dialog/workflow_dialog.dart';

import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import '../../../businesses_logics/application_bloc/app_bloc.dart';

class AddServiceRequestView extends StatefulWidget {
  const AddServiceRequestView({super.key});

  @override
  State<AddServiceRequestView> createState() => _AddServiceRequestViewState();
}

class _AddServiceRequestViewState extends State<AddServiceRequestView> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  ValueNotifier<DateTime> _dueDateNotifier = ValueNotifier(DateTime.now());
  TextEditingController _relatedCustomerController = TextEditingController();
  TextEditingController _backgroundController = TextEditingController();
  TextEditingController _localAmountController = TextEditingController();
  ValueNotifier<bool> _plannedBudgetNotifier = ValueNotifier<bool>(true);

  ValueNotifier _applicationNotifier = ValueNotifier('');
  ApplicationResponse? applicationSelected;
  StdCode? prioritySelected;
  ValueNotifier _priorityNotifier = ValueNotifier('');
  DivisionResponse? divisionSelected;
  ValueNotifier _divisionNotifier = ValueNotifier('');
  ValueNotifier<List<FileInfo>> _attachmentsNotifier =
      ValueNotifier<List<FileInfo>>([]);

  TextEditingController _remarkController = TextEditingController();
  TextEditingController _relatedPartyController = TextEditingController();
  TextEditingController _requireDetailController = TextEditingController();
  TextEditingController _usdAmountController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AddServiceRequestBloc addServiceRequestBloc;
  late AppBloc appBloc;
  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    addServiceRequestBloc = BlocProvider.of<AddServiceRequestBloc>(context)
      ..add(AddServiceRequestViewLoaded(appBloc: appBloc));
  }

  @override
  Widget build(BuildContext context) {
    List<FileInfo> atttachList = [];
    _dueDateController.text =
        DateFormat(MyConstants.ddMMyyyySlash).format(_dueDateNotifier.value);
    return PopScope(
      canPop: false,
      child: Form(
        key: _formKey,
        child: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBarCustom(
              context,
              title: 'addservicerequest',
              onPressBack: () {
                Navigator.pop(context, true);
              },
            ),
            body: BlocListener<AddServiceRequestBloc, AddServiceRequestState>(
              listener: (context, state) {
                if (state is AddServiceRequestFailure) {
                  reset();
                  MyDialog.showError(
                      text: 'close'.tr(),
                      context: context,
                      messageError: state.message,
                      pressTryAgain: () {
                        Navigator.pop(context);
                      },
                      whenComplete: () {
                        BlocProvider.of<AddServiceRequestBloc>(context)
                            .add(AddServiceRequestViewLoaded(appBloc: appBloc));
                      });
                }
                if (state is AddServiceRequestSuccess) {
                  if (state.saveSuccess == true) {
                    if (state.saveSuccess == true) {
                      MyDialog.showSuccess(
                          context: context, message: 'addsuccess'.tr());
                    }
                  }
                }
              },
              child: BlocBuilder<AddServiceRequestBloc, AddServiceRequestState>(
                builder: (context, state) {
                  if (state is AddServiceRequestSuccess) {
                    bool haveWorkflow = state.workflowList == null ||
                            state.workflowList!.isEmpty
                        ? false
                        : true;
                    return SingleChildScrollView(
                      padding: LayoutCustom.paddingItemView,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            InputTextFieldNew(
                              controller: _subjectController,
                              labelText: 'subject',
                              isRequired: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'notempty'.tr();
                                }
                                return null;
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable: _dueDateNotifier,
                              builder: (context, value, child) => InkWell(
                                onTap: () {
                                  pickDate(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      date: _dueDateNotifier.value,
                                      function: (selectedDate) {
                                        _dueDateNotifier.value = selectedDate;
                                        _dueDateController.text = DateFormat(
                                                MyConstants.ddMMyyyySlash)
                                            .format(_dueDateNotifier.value);
                                      });
                                },
                                child: InputTextFieldNew(
                                    suffixIcon: const Icon(
                                      Icons.calendar_month,
                                      size: 30,
                                    ),
                                    enabled: false,
                                    controller: _dueDateController,
                                    labelText: 'duedate'),
                              ),
                            ),
                            InputTextFieldNew(
                                controller: _relatedCustomerController,
                                labelText: 'relatedcustomer'),
                            InputTextFieldNew(
                                controller: _backgroundController,
                                labelText: 'background'),
                            InputTextFieldNew(
                                controller: _localAmountController,
                                type: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                labelText: 'localamount'),
                            _buildPlannedBudget(),
                            InputTextFieldNew(
                                controller: _remarkController,
                                labelText: 'remark'),
                            //application
                            _buildDecorationDropdown(
                                childDropdown: _buildDropdownApplication(
                                    list: state.applicationList),
                                notifier: _applicationNotifier,
                                labelText: 'application',
                                isRequired: true),

                            _buildViewWorkflow(
                                haveWorkflow: haveWorkflow, state: state),
                            //priority
                            _buildDecorationDropdown(
                                childDropdown: _buildDropdownPriority(
                                    list: state.priorityList),
                                notifier: _priorityNotifier,
                                labelText: 'priority',
                                isRequired: true),

                            InputTextFieldNew(
                                controller: _relatedPartyController,
                                labelText: 'relatedparty'),
                            InputTextFieldNew(
                                controller: _requireDetailController,
                                labelText: 'requiredetail'),
                            InputTextFieldNew(
                                type: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                controller: _usdAmountController,
                                labelText: 'usdamount'),
                            InputTextFieldNew(
                                controller: _referenceController,
                                labelText: 'referencedocno'),
                            _buildAttachments(atttachList: atttachList),
                            ValueListenableBuilder(
                              valueListenable: _attachmentsNotifier,
                              builder: (context, value, child) => Row(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            _attachmentsNotifier.value.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                                onTap: () {
                                                  MyDialog.showPopupImage(
                                                      context,
                                                      path: _attachmentsNotifier
                                                          .value[index].path
                                                          .toString(),
                                                      type: 2);
                                                },
                                                leading: Image.file(
                                                  File(
                                                    _attachmentsNotifier
                                                        .value[index].path,
                                                  ),
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    _attachmentsNotifier.value
                                                        .remove(
                                                            _attachmentsNotifier
                                                                .value[index]);
                                                    _attachmentsNotifier.value =
                                                        [];
                                                    _attachmentsNotifier.value =
                                                        atttachList;
                                                  },
                                                ),
                                                title: Text(
                                                  _attachmentsNotifier
                                                      .value[index].name,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ))),
                                  ),
                                ],
                              ),
                            ),
                            //relate dd
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: _buildDecorationDropdown(
                                  childDropdown: _buildDropdownRelate(
                                      list: state.divisionList),
                                  notifier: _divisionNotifier,
                                  labelText: 'relateddivision'),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
                              child: DefaultButton(
                                buttonText: 'createrequest',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<AddServiceRequestBloc>(context).add(AddServiceRequestSave(
                                        appBloc: appBloc,
                                        hasBudget:
                                            _plannedBudgetNotifier.value == false
                                                ? 'No'
                                                : 'Yes',
                                        svrSubject: _subjectController.text,
                                        svrServiceType: applicationSelected!
                                            .applicationCode!,
                                        requiredDetail:
                                            _requireDetailController.text,
                                        proiority: prioritySelected!.codeId!,
                                        svrStatus: 'NEW',
                                        dueDate: DateFormat(MyConstants.yyyyMMdd)
                                            .format(_dueDateNotifier.value),
                                        localDocAmount:
                                            _localAmountController.text.isEmpty
                                                ? '0'
                                                : _localAmountController.text,
                                        usdDocAmount:
                                            _usdAmountController.text.isEmpty
                                                ? '0'
                                                : _usdAmountController.text,
                                        remark: _remarkController.text,
                                        thirdParty:
                                            _relatedPartyController.text,
                                        refDocumentNo:
                                            _referenceController.text,
                                        relatedDivision: divisionSelected != null
                                            ? divisionSelected!.divisionCode ??
                                                ''
                                            : '',
                                        attachmentList: _attachmentsNotifier.value));
                                  }
                                },
                              ),
                            ),
                          ]),
                    );
                  }
                  return const ItemLoading();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachments({required List<FileInfo> atttachList}) {
    return InkWell(
        onTap: () async {
          var status = await Permission.camera.status;
          if (status.isGranted) {
            List<XFile?>? pickedFiles = await ImagePicker().pickMultiImage(
                imageQuality: 100, maxHeight: 100000, maxWidth: 100000);

            if (pickedFiles.isNotEmpty) {
              for (var item in pickedFiles) {
                atttachList.add(FileInfo(
                    path: item!.path, name: path.basename(item.path), id: ''));
              }
              _attachmentsNotifier.value = [];
              _attachmentsNotifier.value = atttachList;
            }
          } else {
            openAppSettings();
          }
        },
        child: Row(
          children: [
            const Icon(
              Icons.attachment,
              color: Colors.lightBlue,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'attachment'.tr(),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.lightBlue,
              ),
            )
          ],
        ));
  }

  Widget _buildViewWorkflow(
      {required bool haveWorkflow, required AddServiceRequestSuccess state}) {
    return InkWell(
        onTap: !haveWorkflow
            ? null
            : () {
                showDialogWorkFlow(
                        context: context,
                        workflowList: state.workflowList ?? [])
                    .show();
              },
        child: Padding(
          padding: LayoutCustom.paddingItemView,
          child: Text(
            'viewworkflow'.tr(),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: !haveWorkflow ? MyColor.pastelGray : MyColor.nokiaBlue,
            ),
          ),
        ));
  }

  void reset() {
    _subjectController = TextEditingController();
    _dueDateController = TextEditingController();
    _dueDateNotifier = ValueNotifier(DateTime.now());
    _relatedCustomerController = TextEditingController();
    _backgroundController = TextEditingController();
    _localAmountController = TextEditingController();
    _plannedBudgetNotifier = ValueNotifier<bool>(true);

    _applicationNotifier = ValueNotifier('');
    applicationSelected = null;
    prioritySelected = null;
    _priorityNotifier = ValueNotifier('');
    divisionSelected = null;
    _divisionNotifier = ValueNotifier('');
    _attachmentsNotifier = ValueNotifier<List<FileInfo>>([]);

    _remarkController = TextEditingController();
    _relatedPartyController = TextEditingController();
    _requireDetailController = TextEditingController();
    _usdAmountController = TextEditingController();
    _referenceController = TextEditingController();
  }

  Widget _buildPlannedBudget() {
    return Padding(
      padding: LayoutCustom.paddingItemView,
      child: ValueListenableBuilder(
        valueListenable: _plannedBudgetNotifier,
        builder: (context, value, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'plannedbudget'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _buildRadio(
                groupValue: _plannedBudgetNotifier.value,
                title: 'yes'.tr(),
                value: true),
            _buildRadio(
                groupValue: _plannedBudgetNotifier.value,
                title: 'noquestion'.tr(),
                value: false),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(
          {required String title,
          required bool value,
          required bool groupValue}) =>
      Expanded(
          child: RadioListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        title: Text(title.tr()),
        groupValue: groupValue,
        value: value,
        onChanged: (value) {
          _plannedBudgetNotifier.value = value!;
        },
      ));

  Widget _buildDropdownApplication({required List<ApplicationResponse> list}) =>
      DropdownButtonFormField2(
          validator: (value) {
            if (value == null) {
              return 'notempty'.tr();
            }
            return null;
          },
          hint: Text(
            'application'.tr(),
            style: LayoutCustom.hintStyle,
          ),
          isExpanded: true,
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
          buttonStyleData: dropdown_custom.buttonStyleData,
          onChanged: (value) {
            _applicationNotifier.value = value!.applicationCode!;
            applicationSelected = value;
            BlocProvider.of<AddServiceRequestBloc>(context).add(
                AddServiceRequestWorkFlow(
                    appBloc: appBloc,
                    applicationCode: applicationSelected!.applicationCode ?? '',
                    localAmount: _localAmountController.text == ''
                        ? '0'
                        : _localAmountController.text));
          },
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
  Widget _buildDropdownPriority({required List<StdCode> list}) =>
      DropdownButtonFormField2(
          validator: (value) {
            if (value == null) {
              return 'notempty'.tr();
            }
            return null;
          },
          hint: Text(
            'priority'.tr(),
            style: LayoutCustom.hintStyle,
          ),
          buttonStyleData: dropdown_custom.buttonStyleData,
          isExpanded: true,
          items: list
              .map((item) => DropdownMenuItem<StdCode>(
                    value: item,
                    child: Text(
                      item.codeDesc ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: prioritySelected,
          onChanged: (value) {
            _priorityNotifier.value = value!.codeId!;
            prioritySelected = value;
          },
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
  Widget _buildDecorationDropdown(
      {required Widget childDropdown,
      required ValueNotifier notifier,
      bool? isRequired,
      required String labelText}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
            child: isRequired ?? false
                ? TextRichRequired(label: labelText.tr())
                : Text(
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
      ),
    );
  }

  Widget _buildDropdownRelate({required List<DivisionResponse> list}) =>
      DropdownButtonFormField2(
          isExpanded: true,
          hint: Text(
            'relateddivision'.tr(),
            style: LayoutCustom.hintStyle,
          ),
          items: list
              .map((item) => DropdownMenuItem<DivisionResponse>(
                    value: item,
                    child: Text(
                      item.divisionDesc ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: divisionSelected,
          onChanged: (value) {
            _divisionNotifier.value = value!.divisionCode!;
            divisionSelected = value;
          },
          buttonStyleData: dropdown_custom.buttonStyleData,
          dropdownStyleData: dropdown_custom.dropdownStyleData,
          menuItemStyleData: dropdown_custom.menuItemStyleData);
}
