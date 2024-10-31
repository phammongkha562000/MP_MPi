// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.type});
  final int type;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

const List<Widget> lang = <Widget>[
  IconCustom(iConURL: MyAssets.flEnglish, size: 25),
  IconCustom(iConURL: MyAssets.flVietNam, size: 25),
];

class _ProfileViewState extends State<ProfileView> {
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier<bool> _isBiometricNotifier = ValueNotifier<bool>(false);
  late ProfileBloc profileBloc;
  late AppBloc appBloc;
  Map<String, String> mapMessPermission = {
    MyConstants.camera: "pleaseopencamerapermission",
    MyConstants.photos: "pleaseopenphotopermission"
  };

  Color primaryColor = MyColor.defaultColor;
  @override
  void initState() {
    if (Platform.isAndroid) {
      PermissionHelper.requestCamera();
    }

    if (Platform.isIOS) {
      PermissionHelper.requestCamera();
      PermissionHelper.requestPhoto();
    }
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    profileBloc = BlocProvider.of<ProfileBloc>(context)
      ..add(ProfileViewLoaded(typeUpdate: widget.type, appBloc: appBloc));
  }

  List<bool> _selectedLang = <bool>[false, false];

  List<Language> listLang = [
    Language(
        lang: "English", langCode: LanguageHelper.en, icon: MyAssets.flEnglish),
    Language(
        lang: "Tiếng Việt",
        langCode: LanguageHelper.vi,
        icon: MyAssets.flVietNam),
  ];
  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();

    if (defaultLang == LanguageHelper.en) {
      _selectedLang = <bool>[true, false];
    } else if (defaultLang == LanguageHelper.vi) {
      _selectedLang = <bool>[false, true];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(
        context,
        title: "profile",
        onPressBack: () {
          _navigationService.pushNamed(MyRoute.homePageRoute);
        },
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateAvtSuccessfully) {
            MyDialog.showSuccess(
              message: 'updatesuccess',
              context: context,
              whenComplete: () {
                _navigationService.pushNamedAndRemoveUntil(MyRoute.proFileRoute,
                    args: {KeyParams.uploadImg: 2});
              },
            );
          }
          if (state is ProfileFailure) {
            MyDialog.showError(
              context: context,
              messageError: state.message,
              pressTryAgain: () {
                _navigationService.pushNamedAndRemoveUntil(MyRoute.proFileRoute,
                    args: {KeyParams.uploadImg: 2});
              },
              whenComplete: () {},
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadSuccess) {
              final itemUser = state.userInfo;
              final itemSub = state.subsidiaryInfo;
              _isBiometricNotifier.value = state.isAllowBiometric;
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 10.w),
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await showImageOption(context);
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AvtCustom(
                                  linkAvt: state.avt,
                                  fullName: itemUser.employeeName ?? "",
                                  size: 100,
                                ),
                              ),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MyColor.bgDrawerColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const HeightSpacer(height: 0.01),
                        Text(
                          itemUser.employeeName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${itemSub.divisionDesc ?? ""} - ${itemSub.deptCode ?? ""}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                  buildItem(
                    title: itemUser.mobile ?? "",
                    iCon: MyAssets.icPhone,
                  ),
                  buildItem(
                    title: itemUser.email ?? "",
                    iCon: MyAssets.icMail,
                  ),
                  buildItem(
                    title: itemSub.divisionDesc ?? "",
                    iCon: MyAssets.icTeam,
                  ),
                  buildItem(
                    title: itemSub.tel ?? "",
                    iCon: MyAssets.icLaptop,
                  ),
                  buildItem(
                    title: itemSub.deptDesc ?? "",
                    iCon: MyAssets.icRole,
                  ),
                  buildItem(
                    title: itemUser.address ?? "",
                    iCon: MyAssets.icAddress,
                  ),
                  _buildCard(isBiometric: state.isBiometric)
                ],
              );
            }
            return const LoadingProfile();
          },
        ),
      ),
    );
  }

  Widget _buildCard({required bool isBiometric}) {
    return Card(
      color: MyColor.aliceBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(children: [
        isBiometric
            ? _buildItemCard(
                title: 'biometrics',
                asset: Image.asset(MyAssets.icFingerprint,
                    width: 30, color: primaryColor),
                trailling: Platform.isAndroid
                    ? Switch(
                        value: _isBiometricNotifier.value,
                        onChanged: (value) {
                          _onBiometrics(isAllowBiometric: value);
                        })
                    : CupertinoSwitch(
                        applyTheme: true,
                        value: _isBiometricNotifier.value,
                        onChanged: (value) {
                          _onBiometrics(isAllowBiometric: value);
                        }),
              )
            : const SizedBox(),
        isBiometric ? _divider() : const SizedBox(),
        _buildItemCard(
            asset: Image.asset(
              MyAssets.icLang,
              width: 30,
              color: primaryColor,
            ),
            title: 'language',
            trailling: ToggleButtons(
              borderColor: primaryColor,
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < listLang.length; i++) {
                    _selectedLang[i] = i == index;
                    context.setLocale(Locale(listLang[index].langCode));
                  }
                });
              },
              borderRadius: BorderRadius.all(Radius.circular(32.r)),
              selectedBorderColor: primaryColor,
              selectedColor: primaryColor,
              fillColor: primaryColor,
              color: primaryColor,
              constraints: const BoxConstraints(
                minHeight: 20.0,
                minWidth: 44.0,
              ),
              isSelected: _selectedLang,
              children: lang,
            )),
        _divider(),
        _buildItemCard(
            asset: Icon(
              Icons.lock_reset_sharp,
              size: 30,
              color: primaryColor,
            ),
            title: 'changepassword',
            trailling: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onPressed: () {
              _navigationService.pushNamed(MyRoute.changePasswordRoute,
                  args: {KeyParams.isBackLogin: false});
            }),
        _divider(),
        _buildItemCard(
            asset: Icon(
              Icons.help,
              size: 30,
              color: primaryColor,
            ),
            title: 'contactpage',
            trailling: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onPressed: () {
              _navigationService.pushNamed(MyRoute.contactRoute);
            }),
      ]),
    );
  }

  Widget _buildItemCard(
      {required String title,
      required Widget asset,
      required Widget? trailling,
      VoidCallback? onPressed}) {
    return ListTile(
        onTap: onPressed,
        title: Text(title.tr()),
        trailing: trailling,
        leading: asset);
  }

  Widget buildChangeLang() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: IconCustom(
              iConURL: MyAssets.icLang,
              size: 30,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "language".tr(),
                  ),
                  ToggleButtons(
                    borderColor: MyColor.defaultColor,
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < listLang.length; i++) {
                          _selectedLang[i] = i == index;
                          context.setLocale(Locale(listLang[index].langCode));
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    selectedBorderColor: MyColor.defaultColor,
                    selectedColor: MyColor.darkLiver,
                    fillColor: MyColor.defaultColor,
                    color: MyColor.defaultColor,
                    constraints: const BoxConstraints(
                      minHeight: 20.0,
                      minWidth: 44.0,
                    ),
                    isSelected: _selectedLang,
                    children: lang,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onBiometrics({required bool isAllowBiometric}) {
    profileBloc.add(BiometricChanged(isAllowBiometric: isAllowBiometric));
  }

  Widget buildItem({
    required String title,
    required String iCon,
  }) {
    return ListTile(
      leading: IconCustom(
        iConURL: iCon,
        size: 25,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: MyColor.textBlack,
        ),
      ),
    );
  }

  showImageOption(BuildContext context) async {
    Platform.isAndroid
        ? showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: Text('Title'),
              // message: Text('This is the message'),

              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  onPressed: () async {
                    var status = await Permission.photos.status;
                    if (!status.isGranted) {
                      dialogRequestPermissions(permission: MyConstants.photos);
                    } else {
                      var pathImg = await ImageHelper.pickImage();
                      if (pathImg?.path == null) {
                        Navigator.of(context).pop();
                      } else {
                        profileBloc.add(ProfileUploadAvt(
                          appBloc: appBloc,
                          pathImgChoose: pathImg?.path,
                        ));
                      }
                    }
                  },
                  child: Text(
                    'choosephoto'.tr(),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    var status = await Permission.camera.status;
                    if (!status.isGranted) {
                      dialogRequestPermissions(permission: MyConstants.camera);
                    } else {
                      var pathImg = await ImageHelper.takePhoto();

                      if (pathImg?.path == null) {
                        Navigator.of(context).pop();
                      } else {
                        profileBloc.add(ProfileUploadAvt(
                            pathImgChoose: pathImg?.path, appBloc: appBloc));
                      }
                    }
                  },
                  child: Text(
                    'takephoto'.tr(),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    MyDialog.showPopupImage(context,
                        path: appBloc.linkAvt ?? '', type: 1);
                  },
                  child: Text(
                    'viewphoto'.tr(),
                  ),
                ),
              ],
             
            ),
          )
        : showModalBottomSheet(
            context: context,
            builder: (BuildContext context2) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading:
                          const IconCustom(iConURL: MyAssets.icPhoto, size: 25),
                      title: Text('choosephoto'.tr(),
                          style: MyStyle.styleDefaultText),
                      onTap: () async {
                        var status = await Permission.photos.status;
                        if (!status.isGranted) {
                          dialogRequestPermissions(
                              permission: MyConstants.photos);
                        } else {
                          var pathImg = await ImageHelper.pickImage();
                          if (pathImg?.path == null) {
                            Navigator.of(context).pop();
                          } else {
                            profileBloc.add(ProfileUploadAvt(
                              appBloc: appBloc,
                              pathImgChoose: pathImg?.path,
                            ));
                          }
                        }
                      },
                    ),
                    ListTile(
                      leading: const IconCustom(
                          iConURL: MyAssets.icCamera, size: 25),
                      title: Text(
                        'takephoto'.tr(),
                        style: MyStyle.styleDefaultText,
                      ),
                      onTap: () async {
                        var status = await Permission.camera.status;
                        if (!status.isGranted) {
                          dialogRequestPermissions(
                              permission: MyConstants.camera);
                        } else {
                          var pathImg = await ImageHelper.takePhoto();

                          if (pathImg?.path == null) {
                            Navigator.of(context).pop();
                          } else {
                            profileBloc.add(ProfileUploadAvt(
                                pathImgChoose: pathImg?.path,
                                appBloc: appBloc));
                          }
                        }
                      },
                    ),
                    ListTile(
                      leading: const IconCustom(
                          iConURL: MyAssets.icViewPhoto, size: 25),
                      title: Text(
                        'viewphoto'.tr(),
                        style: MyStyle.styleDefaultText,
                      ),
                      onTap: () async {
                        MyDialog.showPopupImage(context,
                            path: appBloc.linkAvt ?? '', type: 1);
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  dialogRequestPermissions({required String permission}) =>
      MyDialog.showWarning(
          message: mapMessPermission[permission]?.tr() ?? '',
          textLeft: "Cancel".tr(),
          textRight: "OK".tr(),
          context: context,
          pressCancel: () {
            Navigator.pop(context);
          },
          pressOk: () {
            openAppSettings().then((value) => Navigator.pop(context));
          });

  Widget _divider() {
    return const Divider(
      indent: 16,
      endIndent: 16,
      color: MyColor.darkLiver,
      height: 0,
    );
  }
}

class Language {
  final String lang;
  final String langCode;
  final String icon;
  Language({
    required this.lang,
    required this.langCode,
    required this.icon,
  });
}
