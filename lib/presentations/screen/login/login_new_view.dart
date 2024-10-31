// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/businesses_logics/bloc/authentication/authentication_bloc.dart';
import 'package:mpi_new/businesses_logics/bloc/configuration/bloc/configuration_bloc.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import 'package:url_launcher/url_launcher.dart';
import '../../../data/data.dart';

class LoginViewNew extends StatefulWidget {
  const LoginViewNew({super.key});

  @override
  State<LoginViewNew> createState() => _LoginViewNewState();
}

class _LoginViewNewState extends State<LoginViewNew> {
  final _navigationService = getIt<NavigationService>();

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _showPassNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _rememberNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isObscureNotifier = ValueNotifier<bool>(true);

  final ValueNotifier<String> _serverModeNotifier =
      ValueNotifier<String>(ServerMode.prod.toString());
  String? userName;
  String? password;
  final listServer = [
    ServerMode.prod.toString(),
    ServerMode.dev.toString(),
    ServerMode.qa.toString(),
  ];
  int count = 0;
  late AppBloc appBloc;
  late AuthenticationBloc authenticationBloc;
  late ConfigurationBloc configurationBloc;
  late LoginBloc _bloc;
  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    configurationBloc = BlocProvider.of<ConfigurationBloc>(context);
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(MyAssets.oldBg),
            fit: BoxFit.fill,
          )),
          child: MultiBlocListener(
            listeners: [
              BlocListener<LangBloc, LangState>(
                listener: (context, state) {
                  if (state is LangChangeLoadSuccess) {
                    context.setLocale(Locale(state.lang == LanguageHelper.en
                        ? LanguageHelper.en
                        : LanguageHelper.vi));
                  }
                },
              ),
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) async {
                  if (state is LoginLoading) {
                    MyDialog.showLoading(context: context);
                  } else {
                    MyDialog.hideLoading(context: context);
                  }
                  if (state is LoginLoadedSuccess) {}
                  if (state is LoginFailure) {
                    if (state.errorCode != null) {
                      switch (state.errorCode) {
                        case MyError.errCodeNoInternet:
                          MyDialog.showError(
                              context: context,
                              messageError: state.message,
                              pressTryAgain: () {
                                _navigationService
                                    .pushNamed(MyRoute.loginViewRoute);
                              });
                          break;
                        case MyError.err401:
                          MyDialog.showError(
                              context: context,
                              messageError: state.message,
                              pressTryAgain: () {
                                _navigationService
                                    .pushNamed(MyRoute.loginViewRoute);
                              });
                          break;
                        case MyError.err400:
                          MyDialog.showError(
                              context: context,
                              messageError: state.message,
                              pressTryAgain: () {
                                Navigator.of(context).pop();
                              });
                          break;
                        case MyError.errCodeOldVersion:
                          buildVersion(context, state);
                          break;
                        case MyError.errCodeBiometrics:
                          MyDialog.showWarning(
                            context: context,
                            message: state.message,
                            turnOffCancel: true,
                            pressOk: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {
                              _bloc.add(
                                LoginViewLoaded(
                                  defaultServerMode: state.serverMode,
                                  isLogOut: true,
                                ),
                              );
                            },
                            textRight: "ok",
                          );
                          break;
                        case MyError.errCodeInitLogin:
                          MyDialog.showWarning(
                            context: context,
                            message: state.message,
                            turnOffCancel: true,
                            pressOk: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {
                              _bloc.add(
                                LoginViewLoaded(
                                  defaultServerMode: state.serverMode,
                                  isLogOut: true,
                                ),
                              );
                            },
                            textRight: "ok",
                          );
                          break;

                        default:
                          MyDialog.showError(
                              context: context,
                              messageError: state.message,
                              whenComplete: () {
                                _bloc.add(
                                  LoginViewLoaded(
                                    defaultServerMode: state.serverMode,
                                    isLogOut: true,
                                  ),
                                );
                                log("message");
                              },
                              pressTryAgain: () {
                                Navigator.pop(context);
                              });
                      }
                    } else {
                      MyDialog.showError(
                          context: context,
                          messageError: state.message,
                          whenComplete: () {
                            _bloc.add(
                              LoginViewLoaded(
                                defaultServerMode: state.serverMode,
                                isLogOut: true,
                              ),
                            );
                            log("message");
                          },
                          pressTryAgain: () {
                            Navigator.pop(context);
                          });
                    }
                  }
                  if (state is LoginSuccessfully) {
                    authenticationBloc.add(AddInterceptor(appBloc: appBloc));
                    configurationBloc.add(ConfigurationLoaded());
                    _navigationService.pushNamed(MyRoute.homePageRoute);
                  }
                },
              ),
            ],
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoadedSuccess) {
                  String copyRight = "";
                  state.serverMode == MyConstants.dev
                      ? copyRight =
                          "${MyConstants.copyRight} - ${globalApp.systemName ?? ''} ${state.versionClient}-D"
                      : state.serverMode == MyConstants.qa
                          ? copyRight =
                              "${MyConstants.copyRight} - ${globalApp.systemName ?? ''} ${state.versionClient}-QA"
                          : copyRight =
                              "${MyConstants.copyRight} - ${globalApp.systemName ?? ''} ${state.versionClient}-P";

                  //! Test default
                  _usernameController.text = state.userName.toString();
                  _passwordController.text = state.password.toString();
                  //! Test default

                  String defaultLang =
                      EasyLocalization.of(context)!.currentLocale.toString();
                  log(defaultLang);
                  _showPassNotifier.value = state.showPassword ?? true;
                  _rememberNotifier.value = state.isRemember ?? false;
                  _serverModeNotifier.value =
                      state.serverMode ?? ServerMode.prod.toString();

                  return viewLoginSuccess(
                      defaultLang, context, state, copyRight);
                }
                if (state is LoginLoading) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(MyAssets.bg),
                      fit: BoxFit.fill,
                    )),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  buildVersion(BuildContext context, LoginFailure state) {
    return MyDialog.showWarning(
        context: context,
        message: state.message,
        turnOffCancel: true,
        pressOk: () {
          if (Platform.isAndroid || Platform.isIOS) {
            final appId = Platform.isAndroid
                ? MyConstants.androidAppId
                : MyConstants.iOSAppId;
            final url = Uri.parse(
              Platform.isAndroid
                  ? "${MyConstants.urlGooglePlay}$appId"
                  : "${MyConstants.urlAppStore}$appId",
            );
            launchUrl(url, mode: LaunchMode.externalApplication);
          }
        });
  }

  Widget viewLoginSuccess(
    String defaultLang,
    BuildContext context,
    LoginLoadedSuccess state,
    String copyRight,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(flex: 1, child: buildLogo()),
          Expanded(
            flex: 0,
            child: formLogin(defaultLang, context, state),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(copyRight.toString()),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (globalApp.getLogoLogin != '' &&
                              globalApp.getLogoLogin != null)
                          ? Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Image.network(
                                globalApp.getLogoLogin!,
                                width: 120.w,
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Image.asset(
                          MyAssets.logoEnt,
                          width: 120.w,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formLogin(
    String defaultLang,
    BuildContext context,
    LoginLoadedSuccess state,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Column(
        children: [
          buildUserName(),
          buildPassword(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Platform.isAndroid
                      ? Switch(
                          value: _rememberNotifier.value,
                          onChanged: (value) {
                            _onRemember(isRemember: value);
                          })
                      : CupertinoSwitch(
                          applyTheme: true,
                          value: _rememberNotifier.value,
                          onChanged: (value) {
                            _onRemember(isRemember: value);
                          }),
                  Text("remember".tr())
                ],
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: buildChangeLang(defaultLang, context),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: InkWell(
              onTap: () {
                _navigationService.pushNamed(MyRoute.forgotPasswordRoute,
                    args: {KeyParams.username: _usernameController.text});
              },
              child: Text(
                '${'forgotpassword'.tr()}?',
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: ElevatedButton(
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all(
                        const Size(double.infinity - (5 / 100), 50)),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity - (5 / 100), 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onPressedLogin();
                    }
                  },
                  child: Text(
                    "login".tr(),
                    style: TextStyle(
                      color: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.textStyle!
                              .resolve({})!.color ??
                          Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              state.biometrics == BiometricsHelper.notBiometrics
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        if (state.isAllowBiometrics == false) {
                          MyDialog.showError(
                            context: context,
                            messageError: "Chưa bật tính năng xác thực",
                            text: "ok",
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          // *Check xác thực đúng sai
                          _bloc.add(LoginWithBiometrics(
                            appBloc: appBloc,
                            userName: _usernameController.text,
                            password: _passwordController.text,
                          ));
                        }
                      },
                      iconSize: 50,
                      icon: IconCustom(
                          iConURL: state.biometrics == BiometricsHelper.faceId
                              ? MyAssets.icFaceId
                              : MyAssets.icFingerprint,
                          size: 50),
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildLogo() {
    return ValueListenableBuilder(
        builder: (BuildContext buildContext, value, Widget? child) {
          return InkWell(
            onTap: () {
              count == 6
                  ? {
                      //change server
                      _showChangeServer(buildContext),
                      count = 0,
                    }
                  : count++;
            },
            child:
                (globalApp.getIconLogin != '' && globalApp.getIconLogin != null)
                    ? Image.network(
                        globalApp.getIconLogin!,
                        width: 250.w,
                      )
                    : Image.asset(
                        MyAssets.logo,
                        width: 150.w,
                      ),
          );
        },
        valueListenable: _serverModeNotifier);
  }

  Widget buildPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ValueListenableBuilder(
        valueListenable: _isObscureNotifier,
        builder: (context, value, child) => TextFormField(
          obscureText: _isObscureNotifier.value,
          controller: _passwordController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _isObscureNotifier.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                _isObscureNotifier.value = !_isObscureNotifier.value;
              },
            ),
            hintText: "password".tr(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return MyError.erNullPassword;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildUserName() {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "username".tr(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return MyError.erNullUserName;
        }
        return null;
      },
    );
  }

  _onRemember({required bool isRemember}) {
    _bloc.add(LoginRemember(
      remember: isRemember,
      username: _usernameController.text,
      password: _passwordController.text,
      serverMode: _serverModeNotifier.value,
      showPassword: _showPassNotifier.value,
    ));
  }

  Widget buildChangeLang(String defaultLang, BuildContext context) {
    return IconButton(
        onPressed: () {
          BlocProvider.of<LangBloc>(context).add(ChangeLang(
              langChange: defaultLang == LanguageHelper.vi
                  ? LanguageHelper.en
                  : LanguageHelper.vi));
          _bloc.add(LoginChangeLang(
            username: _usernameController.text,
            password: _passwordController.text,
            remember: _rememberNotifier.value,
            serverMode: _serverModeNotifier.value,
            langChange: defaultLang,
          ));
        },
        icon: IconCustom(
            iConURL: defaultLang == LanguageHelper.en
                ? MyAssets.flEnglish
                : MyAssets.flVietNam,
            size: 30));
  }

  _onPressedLogin() async {
    _bloc.add(LoginOnPressed(
      appBloc: appBloc,
      remember: _rememberNotifier.value,
      username: _usernameController.text,
      password: _passwordController.text,
      serverMode: _serverModeNotifier.value,
      showPassword: _showPassNotifier.value,
    ));
  }

  _showChangeServer(BuildContext buildContext) {
    AwesomeDialog(
      width: 400.w,
      padding: EdgeInsets.all(24.w),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      body: Column(
        children: [
          Text(
            "chooseserver".tr(),
          ),
          const HeightSpacer(height: 0.02),
          DropdownButtonFormField2(
              isExpanded: true,
              hint: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColor.outerSpace,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: listServer
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: _serverModeNotifier.value,
              onChanged: (value) {
                BlocProvider.of<LoginBloc>(buildContext).add(LoginChooseServer(
                    serverMode: value!,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    remember: _rememberNotifier.value));
                Navigator.pop(context);
              },
              buttonStyleData: dropdown_custom.buttonStyleData,
              dropdownStyleData: DropdownStyleData(
                  elevation: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: Radius.circular(40.r),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  )),
              menuItemStyleData: dropdown_custom.menuItemStyleData)
        ],
      ),
    ).show();
  }
}
