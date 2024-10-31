import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:permission_handler/permission_handler.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class CreateNewITServiceView extends StatefulWidget {
  const CreateNewITServiceView({super.key});

  @override
  State<CreateNewITServiceView> createState() => CreateNewITServiceStateView();
}

class CreateNewITServiceStateView extends State<CreateNewITServiceView> {
  final _navigationService = getIt<NavigationService>();
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ValueNotifier<StdCode> _itServiceNotifier =
      ValueNotifier<StdCode>(StdCode());
  final ValueNotifier<StdCode> _priorityNotifier =
      ValueNotifier<StdCode>(StdCode());

  final ValueNotifier<StdCode> _serviceTypeNotifier =
      ValueNotifier<StdCode>(StdCode());

  final ValueNotifier<List<FileInfo>> _attachmentsNotifier =
      ValueNotifier<List<FileInfo>>([]);

  StdCode? selectedITService;
  StdCode? selectedPriority;
  StdCode? selectedSVC;
  late ITServiceNewRequestBloc itServiceNewRequestBloc;
  late AppBloc appBloc;
  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    itServiceNewRequestBloc = BlocProvider.of<ITServiceNewRequestBloc>(context)
      ..add(ITServiceNewRequestLoaded(appBloc: appBloc));
  }

  @override
  Widget build(BuildContext context) {
    List<FileInfo> atttachList = [];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarCustom(
          context,
          title: "newrequest",
          onPressBack: () {
            _navigationService.pushNamed(MyRoute.itServiceRoute);
          },
        ),
        body: BlocListener<ITServiceNewRequestBloc, ITServiceNewRequestState>(
          listener: (context, state) {
            if (state is ITServiceNewRequestLoading) {
              MyDialog.showLoading(context: context);
            } else {
              MyDialog.hideLoading(context: context);
            }
            if (state is CreateNewITServiceRequestSuccessfully) {
              MyDialog.showSuccess(
                context: context,
                message: 'addsuccess'.tr(),
                whenComplete: () {
                  _navigationService.pushNamed(MyRoute.itServiceRoute);
                },
              );
            }

            if (state is ITServiceNewRequestFailure) {
              MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  _navigationService.pushNamed(MyRoute.itServiceRoute);
                },
                whenComplete: () {
                  Navigator.pop(context);
                },
              );
            }
          },
          child: BlocBuilder<ITServiceNewRequestBloc, ITServiceNewRequestState>(
            builder: (context, state) {
              if (state is ITServiceNewRequestLoadSuccess) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(8.w),
                    children: [
                      InputTextFieldNew(
                        labelText: "subject",
                        controller: _subjectController,
                        isRequired: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyError.errNullSubject;
                          }
                          return null;
                        },
                      ),
                      _buildDecorationDropdown(
                        labelText: 'itservice',
                        isRequired: true,
                        childDropdown: _buildDropdownStdCode(
                            list: state.listItService ?? [],
                            label: "itservice",
                            selected: selectedITService,
                            onChanged: (value) {
                              value as StdCode;
                              _itServiceNotifier.value = value;
                              selectedITService = value;

                              BlocProvider.of<ITServiceNewRequestBloc>(context)
                                  .add(ChangeITService(
                                      itServiceId: value.codeId.toString()));
                            },
                            stdNotifier: _itServiceNotifier.value.codeId ?? ""),
                        notifier: _itServiceNotifier,
                      ),
                      _buildDecorationDropdown(
                        labelText: 'servicetype',
                        isRequired: true,
                        childDropdown: _buildDropdownStdCode(
                            list: state.listSVC ?? [],
                            label: "choosesvc",
                            selected: selectedSVC,
                            onChanged: (value) {
                              value as StdCode;
                              _serviceTypeNotifier.value = value;
                              selectedSVC = value;

                              BlocProvider.of<ITServiceNewRequestBloc>(context)
                                  .add(ChangeServiceTypeITService(
                                      serviceType: value.codeId.toString()));
                            },
                            stdNotifier:
                                _serviceTypeNotifier.value.codeId ?? ""),
                        notifier: _serviceTypeNotifier,
                      ),
                      _buildDecorationDropdown(
                        isRequired: true,
                        childDropdown: _buildDropdownStdCode(
                            list: state.listPriority ?? [],
                            label: "choosepriority",
                            selected: selectedPriority,
                            onChanged: (value) {
                              value as StdCode;
                              _priorityNotifier.value = value;
                              selectedPriority = value;
                              log(value.codeId.toString());

                              BlocProvider.of<ITServiceNewRequestBloc>(context)
                                  .add(ChangePriorityITService(
                                      priority: value.codeId.toString()));
                            },
                            stdNotifier: _priorityNotifier.value.codeId ?? ""),
                        notifier: _priorityNotifier,
                        labelText: 'priority',
                      ),
                      InputTextFieldNew(
                        labelText: "description",
                        controller: _descriptionController,
                        isRequired: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyError.errNullDescription;
                          }
                          return null;
                        },
                      ),
                      _buildAttachments(atttachList: atttachList),
                      ValueListenableBuilder(
                        valueListenable: _attachmentsNotifier,
                        builder: (context, value, child) => Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _attachmentsNotifier.value.length,
                                  itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        MyDialog.showPopupImage(context,
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
                                          _attachmentsNotifier.value.remove(
                                              _attachmentsNotifier
                                                  .value[index]);
                                          _attachmentsNotifier.value = [];
                                          _attachmentsNotifier.value =
                                              atttachList;
                                        },
                                      ),
                                      title: Text(
                                        _attachmentsNotifier.value[index].name,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.underline),
                                      ))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: DefaultButton(
            buttonText: "submit",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<ITServiceNewRequestBloc>(context).add(
                    ITServiceNewRequest(
                        subject: _subjectController.text,
                        description: _descriptionController.text,
                        svcType: _serviceTypeNotifier.value.codeId
                            .toString()
                            .toUpperCase(),
                        itService: _itServiceNotifier.value.codeId
                            .toString()
                            .toUpperCase(),
                        priority: _priorityNotifier.value.codeId
                            .toString()
                            .toUpperCase(),
                        attachmentList: atttachList));
              }
            },
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
              color: MyColor.nokiaBlue,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'attachment'.tr(),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: MyColor.nokiaBlue,
              ),
            )
          ],
        ));
  }

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

  Widget _buildDropdownStdCode({
    required List<StdCode> list,
    required String label,
    StdCode? selected,
    required String stdNotifier,
    Function(StdCode?)? onChanged,
  }) =>
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
        validator: (value) {
          if (value == null) {
            return 'notempty'.tr();
          }
          return null;
        },
        buttonStyleData: dropdown_custom.buttonStyleData,
        value: selected,
        onChanged: onChanged,
        dropdownStyleData: dropdown_custom.dropdownStyleData,
        menuItemStyleData: dropdown_custom.menuItemStyleData,
      );

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
