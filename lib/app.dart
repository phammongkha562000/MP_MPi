import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpi_new/businesses_logics/bloc/configuration/bloc/configuration_bloc.dart';
import 'package:mpi_new/data/base/life_cycle_state.dart';
import 'package:mpi_new/data/services/firebase_cloud_message/firebase_cloud_message.dart';

import 'package:mpi_new/data/services/navigator/generate_route.dart' as router;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/services/services.dart';

class MPI extends StatefulWidget {
  const MPI({Key? key}) : super(key: key);

  @override
  State<MPI> createState() => _MyMaterialState();
}

class _MyMaterialState extends LifecycleState<MPI> {
  @override
  Future<void> onResumed() async {
    final sharedPref = await SharedPreferencesService.instance;
    SharedPreferencesService.reload().then((value) {
      if (sharedPref.isCheckVersion == true) {
        log('onResumed - isCheckVersion: ${sharedPref.isCheckVersion}');
        sharedPref.setIsCheckVersion(false);
        FcmServices().dialogToLogin(
            text:
                'Bạn hiện đang sử dụng phiên bản cũ, vui lòng cập nhật phiên bản mới, cảm ơn !');
      }
    });
  }

  final ValueNotifier<ThemeData> _themeCurrent = ValueNotifier(theme(
      primaryColor: MyColor.defaultColor,
      secondaryColor: MyColor.darkLiver,
      surfaceColor: Colors.white,
      dividerColor: Colors.grey,
      frameFontColor: Colors.black,
      appbarColor: MyColor.defaultColor,
      normalFontColor: Colors.black,
      backgroundPanel: Colors.black,
      colorPanel: Colors.white));
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      child: BlocListener<ConfigurationBloc, ConfigurationState>(
        listener: (context, state) {
          if (state is ConfigurationSuccess) {
            final primaryColor = state.currentTheme.primaryColor == ''
                ? MyColor.defaultColor
                : Color(int.parse(
                    '0xff${state.currentTheme.primaryColor!.substring(1)}'));
            final secondaryColor = state.currentTheme.secondaryColor == ''
                ? MyColor.darkLiver
                : Color(int.parse(
                    '0xff${state.currentTheme.secondaryColor!.substring(1)}'));
            final frameFontColor = state.currentTheme.frameFontColor == ''
                ? Colors.black
                : Color(int.parse(
                    '0xff${state.currentTheme.frameFontColor!.substring(1)}'));
            final normalFontColor = state.currentTheme.normalFontColor == ''
                ? Colors.black
                : Color(int.parse(
                    '0xff${state.currentTheme.normalFontColor!.substring(1)}'));
            final appbarColor = state.currentTheme.hex == ''
                ? MyColor.defaultColor
                : Color(
                    int.parse('0xff${state.currentTheme.hex!.substring(1)}'));

            final bgPanel = state.currentTheme.backgroundPanel == ''
                ? Colors.black
                : Color(int.parse(
                    '0xff${state.currentTheme.backgroundPanel!.substring(1)}'));

            final colorPanel = state.currentTheme.colorPanel == ''
                ? Colors.white
                : Color(int.parse(
                    '0xff${state.currentTheme.colorPanel!.substring(1)}'));
            _themeCurrent.value = theme(
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                surfaceColor: Colors.white,
                dividerColor: Colors.grey,
                frameFontColor: frameFontColor,
                appbarColor: appbarColor,
                normalFontColor: normalFontColor,
                backgroundPanel: bgPanel,
                colorPanel: colorPanel);
            log('theme ok');
          }
        },
        child: ValueListenableBuilder(
          valueListenable: _themeCurrent,
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: value,
              builder: EasyLoading.init(builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: ResponsiveWrapper.builder(
                      BouncingScrollWrapper.builder(context, child!),
                      maxWidth: 1200,
                      minWidth: 450,
                      defaultScale: true,
                      breakpoints: [
                        const ResponsiveBreakpoint.resize(450, name: MOBILE),
                        const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                        const ResponsiveBreakpoint.autoScale(1000,
                            name: TABLET),
                        const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                        const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                      ],
                      background: const ColoredBox(color: Color(0xFFF5F5F5))),
                );
              }),
              home: BlocProvider(
                create: (context) => LoginBloc()..add(const LoginViewLoaded()),
                child: const LoginViewNew(),
              ),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorKey: getIt<NavigationService>().navigatorKey,
              onGenerateRoute: router.generateRoute,
            );
          },
        ),
      ),
    );
  }

  void goUpdateApp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? MyConstants.androidAppId : MyConstants.iOSAppId;
      final url = Uri.parse(
        Platform.isAndroid
            ? "${MyConstants.urlGooglePlay}$appId"
            : "${MyConstants.urlAppStore}$appId",
      );
      launchUrl(url, mode: LaunchMode.externalApplication)
          .whenComplete(() => exit(0));
    }
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}
}
