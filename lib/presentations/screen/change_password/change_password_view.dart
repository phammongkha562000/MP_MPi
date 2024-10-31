import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/presentations/screen/change_password/validate_password.dart';
import '../../../data/data.dart';
import '../../widgets/label_form.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key, this.isBackLogin});
  final bool? isBackLogin;
  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _navigationService = getIt<NavigationService>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  late AppBloc appBloc;
  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarCustom(
          context,
          title: "change_password_mb".tr(),
          onPressBack: () {
            widget.isBackLogin == true
                ? _navigationService
                    .pushNamedAndRemoveUntil(MyRoute.loginViewRoute)
                : Navigator.pop(context);
          },
        ),
        body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccessful) {
              showDialogLogOut(context, newPass: state.newPass);
            }

            if (state is ChangePasswordFailure) {
              MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  BlocProvider.of<ChangePasswordBloc>(context)
                      .add(ChangePasswordLoaded());
                  Navigator.pop(context);
                },
              );
            }
          },
          child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
            builder: (context, state) {
              if (state is ChangePasswordFailure) {
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              }
              if (state is ChangePasswordLoadSuccess) {
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                    child: Column(
                      children: [_buildUI(oldPass: state.oldPass), _buildUI2()],
                    ),
                  ),
                );
              }
              return const ItemLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUI({required String oldPass}) {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(children: [
      _buildCurrentPassword(oldPass: oldPass),
      _buildTextWithWidget(
        title: "newpassword".tr(),
        widget: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          controller: _newPasswordController,
          textInputAction: TextInputAction.next,
          obscureText: _obscureNew,
          validator: (value) {
            if (value!.isEmpty) {
              validate = false;
              return MyError.erNullPassword;
            } else if (value.length < 6) {
              validate = false;
              return MyError.erPasswordShort;
            } else if (value != _confirmPasswordController.text) {
              return MyError.erPassNotMatch;
            }
            return null;
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureNew = !_obscureNew;
                });
              },
              icon: Icon(
                _obscureNew
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye,
              ),
            ),
          ),
        ),
      ),
      _buildTextWithWidget(
        title: "newpasswordconfirm".tr(),
        widget: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          validator: (value) {
            if (value!.isEmpty) {
              return MyError.erNullPassword;
            } else if (value.length < 6) {
              return MyError.erPasswordShort;
            } else if (value != _newPasswordController.text) {
              return MyError.erPassNotMatch;
            }
            return null;
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
              icon: Icon(
                _obscureConfirm
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye,
              ),
            ),
          ),
        ),
      ),
      ValidatePasswordWidget(
          controller: _newPasswordController, minCharacter: 6)
    ])));
  }

  Widget _buildUI2() {
    return Expanded(
        flex: -1,
        child: ValueListenableBuilder(
            valueListenable: isValidateNewPassword,
            builder: (context, value, child) => DefaultButton(
                buttonText: "change_password_mb".tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<ChangePasswordBloc>(context).add(
                        ChangePasswordSubmit(
                            appBloc: appBloc,
                            newPass: _newPasswordController.text,
                            oladPass: _currentPasswordController.text));
                  }
                })));
  }

  Widget _buildCurrentPassword({required String oldPass}) {
    return _buildTextWithWidget(
      title: "oldpassword".tr(),
      widget: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        controller: _currentPasswordController,
        obscureText: _obscureCurrent,
        validator: (value) {
          if (value!.isEmpty) {
            return MyError.erNullPassword;
          } else if (_currentPasswordController.text != oldPass) {
            return MyError.erPassNotMatch;
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureCurrent = !_obscureCurrent;
              });
            },
            icon: Icon(
              _obscureCurrent
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextWithWidget({required String title, required Widget widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelForm(
          isRequired: true,
          label: title,
        ),
        widget,
      ],
    );
  }

  showDialogLogOut(BuildContext context, {required String newPass}) {
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              Future.delayed(
                  const Duration(seconds: 5), () => Navigator.pop(context));
              return CupertinoAlertDialog(
                title: Text('logout'.tr()),
                content: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "requiredlogout".tr(),
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              );
            }).whenComplete(() async {
            _logOut(newPass: newPass);
          })
        : showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              Future.delayed(
                  const Duration(seconds: 5), () => Navigator.pop(context));
              return AlertDialog(
                  contentPadding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  title: Text(
                    'logout'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "requiredlogout".tr(),
                    textAlign: TextAlign.center,
                  ));
            },
          ).whenComplete(() async {
            _logOut(newPass: newPass);
          });
  }

  _logOut({required String newPass}) async {
    final sharedPref = await SharedPreferencesService.instance;
    sharedPref.setPassword(newPass).whenComplete(
          () => _navigationService
              .pushNamedAndRemoveUntil(MyRoute.loginViewRoute),
        );
  }
}
