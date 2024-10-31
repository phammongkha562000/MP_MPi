import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '/presentations/presentations.dart';

class CustomDialog {
  Future showCustomDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(8)),
      width: 250,
      body: const LoadingWidget(),
    ).show();
  }

  void hideCustomDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(8)),
      width: 250,
      body: const LoadingWidget(),
    ).dismiss();
  }

  goBack3sWhenStateErr(BuildContext context) {
    return Timer(
      const Duration(seconds: 3),
      () {
        CustomDialog().hideCustomDialog(context);
        Navigator.pop(context);
      },
    );
  }

  // *Dialog success
  Future success(
    BuildContext context, {
    String? success,
    Function? ok,
    Function? cancel,
    bool? autoHide,
  }) {
    return AwesomeDialog(
      width: MediaQuery.sizeOf(context).width * 0.7,
      padding: EdgeInsets.zero,
      dialogBorderRadius: BorderRadius.circular(16),
      context: context,
      bodyHeaderDistance: 0,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      autoHide: autoHide == true ? const Duration(seconds: 1) : null,
      body: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  decoration: const BoxDecoration(
                    color: MyColor.textGreen,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: MyColor.textWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: Text(
                      success == null || success == ""
                          ? "success".tr()
                          : success.tr(),
                      style: const TextStyle(
                        color: MyColor.textBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const HeightSpacer(height: 0.01)
          ],
        ),
      ),
      btnOkColor: MyColor.defaultColor,
      btnOkOnPress: ok as void Function()?,
      btnCancelColor: MyColor.textRed,
      btnCancelOnPress: cancel as void Function()?,
    ).show();
  }

  Future error(
    BuildContext context, {
    String? error,
    Function? cancel,
    Function? ok,
    bool? dismissOutSide,
  }) {
    return AwesomeDialog(
      context: context,
      dismissOnTouchOutside: dismissOutSide == true ? false : true,
      customHeader: const IconCustom(iConURL: MyAssets.error, size: 100),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "error".tr(),
            style: const TextStyle(
              color: MyColor.textRed,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const HeightSpacer(height: 0.01),
          error == null || error == ""
              ? const SizedBox()
              : Text(
                  error,
                  style: MyStyle.styleTextError,
                  textAlign: TextAlign.center,
                ),
          const HeightSpacer(height: 0.01)
        ],
      ),
      btnOkColor: MyColor.defaultColor,
      btnOkOnPress: ok as void Function()?,
      btnCancelColor: MyColor.textRed,
      btnCancelOnPress: cancel as void Function()?,
    ).show();
  }

  Future warning(BuildContext context,
      {String? message, Function()? ok, Function()? cancel, bool? isOk}) {
    return AwesomeDialog(
      context: context,

      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      // *NỮa đổi
      customHeader: const IconCustom(iConURL: MyAssets.logo, size: 100),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message == null || message == "" ? "warning".tr() : message.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MyColor.textBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const HeightSpacer(height: 0.01)
        ],
      ),
      btnOkColor: MyColor.defaultColor,
      btnCancelText: 'close'.tr(),
      btnOkText: isOk ?? true ? 'ok'.tr() : null,
      btnCancelColor: MyColor.warningColor,
      btnCancelOnPress: cancel ?? () {},
      btnOkOnPress: isOk ?? true ? ok : null,
    ).show();
  }
}
