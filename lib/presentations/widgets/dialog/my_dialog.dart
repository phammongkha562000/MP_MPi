import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mpi_new/presentations/presentations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart' as pdf;

class MyDialog {
  static Future<void> showToast({
    required BuildContext context,
    required String title,
  }) async {
    await EasyLoading.showInfo(
      title,
      dismissOnTap: true,
      maskType: EasyLoadingMaskType.custom,
    );
  }

  static Future<void> showLoading({
    required BuildContext context,
  }) async {
    await EasyLoading.show(
      status: "loading".tr(),
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
    );
  }

  static Future<void> hideLoading({
    required BuildContext context,
  }) async {
    await EasyLoading.dismiss();
  }

  static showSuccess({
    required BuildContext context,
    Function? pressContinue,
    required String message,
    bool? turnOffAutoHide,
    Function? whenComplete,
  }) {
    int status = 1;
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  Future.delayed(
                      const Duration(seconds: 1), () => Navigator.pop(context));
                  return CupertinoAlertDialog(
                    title: Text(getStatusText(status),
                        style: styleTitle(status: status)),
                    content: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        message.tr(),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  );
                })
            .whenComplete(
                whenComplete == null ? () {} : whenComplete as void Function())
        : showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              Future.delayed(
                  const Duration(seconds: 1), () => Navigator.pop(context));
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                title: Text(getStatusText(status),
                    textAlign: TextAlign.center,
                    style: styleTitle(status: status)),
                content: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ).whenComplete(
            whenComplete == null ? () {} : whenComplete as void Function());
  }

  static showError(
      {required BuildContext context,
      required String messageError,
      required void Function()? pressTryAgain,
      bool? turnOnAutoHide,
      Function? whenComplete,
      String? text}) {
    int status = 2;
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(getStatusText(status),
                  style: styleTitle(status: status)),
              content: Text(
                messageError.tr(),
                style: const TextStyle(fontSize: 17),
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: pressTryAgain,
                  child: Text(
                    'close'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ).whenComplete(
            whenComplete == null ? () {} : whenComplete as void Function())
        : showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                title: Text(getStatusText(status),
                    style: styleTitle(status: status)),
                content: Text(messageError),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: pressTryAgain,
                    child: Text(
                      'close'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ).whenComplete(
            whenComplete == null ? () {} : whenComplete as void Function());
  }

  static showWarning({
    required BuildContext context,
    void Function()? pressOk,
    void Function()? pressCancel,
    required String message,
    bool? turnOffCancel,
    void Function()? whenComplete,
    String? textLeft,
    String? textRight,
  }) {
    int status = 3;
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(getStatusText(status),
                  style: styleTitle(status: status)),
              content: Text(
                message,
                style: const TextStyle(fontSize: 17),
              ),
              actions: turnOffCancel == true
                  ? [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: pressOk ??
                            () {
                              Navigator.of(context).pop();
                            },
                        child: Text(
                          textRight ?? 'ok'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ]
                  : [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: pressCancel,
                        child: Text(
                          'close'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: pressOk ??
                            () {
                              Navigator.of(context).pop();
                            },
                        child: Text(
                          textRight ?? 'ok'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
            ),
          ).whenComplete(whenComplete ?? () {})
        : showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                title: Text(getStatusText(status),
                    style: styleTitle(status: status)),
                content: Text(message),
                actions: <Widget>[
                  turnOffCancel == true
                      ? const SizedBox()
                      : TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          onPressed: pressCancel,
                          child: Text(
                            'close'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: pressOk ??
                        () {
                          Navigator.of(context).pop();
                        },
                    child: Text(
                      'ok'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ).whenComplete(whenComplete ?? () {});
  }

  Future showInfos({
    required BuildContext context,
    Function? pressOk,
    Function? pressCancel,
    bool? turnOffAutoHide,
    bool? turnOffCancel,
    Function? whenComplete,
  }) async {
    int status = 5;

    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(getStatusText(status),
                  style: styleTitle(status: status)),
              content: Text('under_development'.tr()),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'close'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ).whenComplete(
            whenComplete == null ? () {} : whenComplete as void Function())
        : showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                title: Text(getStatusText(status),
                    style: styleTitle(status: status)),
                content: Text('under_development'.tr()),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: Text(
                      'close'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ).whenComplete(
            whenComplete == null ? () {} : whenComplete as void Function());
  }

  static Text buildTextButton(int status) {
    return Text(
      getTextButton(status),
      style: const TextStyle(
        color: MyColor.textWhite,
        fontWeight: FontWeight.bold,
        fontSize: 15,
        letterSpacing: 0.3,
      ),
    );
  }

  static ButtonStyle styleButton(int status) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(getStatusColor(status)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  static Widget iCon({
    required int status,
  }) {
    late final String assetName;
    late final Color color;

    switch (status) {
      case 1:
        assetName = MyAssets.icSuccess;
        color = MyColor.btnGreen;
        break;
      case 2:
        assetName = MyAssets.icError;
        color = MyColor.textRed;
        break;
      case 5:
        assetName = MyAssets.icWarning;
        color = MyColor.textBlue;
        break;
      default:
        assetName = MyAssets.icWarning;
        color = MyColor.defaultColor;
    }

    return Image.asset(
      assetName,
      color: color,
    );
  }

  static TextStyle styleTitle({required int status}) {
    Color color;
    switch (status) {
      case 1:
        color = MyColor.btnGreen;
        break;
      case 2:
        color = MyColor.textRed;
        break;
      case 5:
        color = MyColor.textBlue;
        break;
      default:
        color = MyColor.defaultColor;
    }

    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleMessage = const TextStyle(
    color: MyColor.textBlack,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );
  static Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return MyColor.btnGreen;
      case 2:
        return MyColor.textRed;
      case 3:
        return MyColor.defaultColor;
      case 4:
        return MyColor.defaultColor;
      case 5:
        return MyColor.textBlue;

      default:
        return MyColor.defaultColor;
    }
  }

  static String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'success'.tr();
      case 2:
        return 'errortitle'.tr();
      case 3:
        return 'warning'.tr();
      case 4:
        return 'Update'.tr();
      case 5:
        return "Info".tr();
      default:
        return 'Button';
    }
  }

  static String getTextButton(int status) {
    switch (status) {
      case 1:
        return 'Continue'.tr();
      case 2:
        return 'tryagain'.tr();
      case 3:
        return 'Continue'.tr();
      case 4:
        return 'Update'.tr();
      case 5:
        return 'OK';
      default:
        return 'Button';
    }
  }

  static Future showPopupImage(
    BuildContext context, {
    required String path,
    required int type, //1 is NetWork| 2 is File | 3 is memory | 4 is pdf
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.white,
                        size: 32,
                      ))),
              Expanded(
                child: ColoredBox(
                  color: Colors.transparent,
                  child: type == 1
                      ? PhotoView(
                          tightMode: true,
                          imageProvider: NetworkImage(path),
                          initialScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.contained * 2,
                          backgroundDecoration:
                              const BoxDecoration(color: Colors.transparent),
                        )
                      : type == 3
                          ? PhotoView(
                              tightMode: true,
                              imageProvider: MemoryImage(
                                  const Base64Decoder().convert(path)),
                              initialScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.contained * 2,
                              backgroundDecoration: const BoxDecoration(
                                  color: Colors.transparent),
                            )
                          : type == 2
                              ? PhotoView(
                                  tightMode: true,
                                  imageProvider: FileImage(File(path)),
                                  initialScale:
                                      PhotoViewComputedScale.contained,
                                  maxScale:
                                      PhotoViewComputedScale.contained * 2,
                                  backgroundDecoration: const BoxDecoration(
                                      color: Colors.transparent),
                                )
                              : pdf.PDFView(
                                  filePath: path,

                                  // pdfData: data,
                                  enableSwipe: true,
                                  swipeHorizontal: false,
                                  autoSpacing: true,
                                  pageFling: true,
                                  // nightMode: true,
                                  // onRender: (pages) {
                                  //   setState(() {});
                                  // },
                                  onError: (error) {
                                    // log(error.toString());
                                  },
                                  onPageError: (page, error) {
                                    // log('$page: ${error.toString()}');
                                  },
                                  onViewCreated:
                                      (PDFViewController pdfViewController) {
                                    // interact with PDF controller
                                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
