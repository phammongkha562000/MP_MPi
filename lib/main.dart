import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mpi_new/app.dart';
import 'package:mpi_new/businesses_logics/bloc/configuration/bloc/configuration_bloc.dart';
import 'package:mpi_new/data/services/data_clean/data_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'businesses_logics/application_bloc/app_bloc.dart';
import 'businesses_logics/bloc/authentication/authentication_bloc.dart';
import 'data/data.dart';
import 'data/services/firebase_cloud_message/firebase_cloud_message.dart';
import 'data/services/language/asset_lang_server.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  RemoteNotification? notification = message?.notification;
  if (notification != null &&
      notification.title != null &&
      notification.title!.contains("[VERSION]")) {
    final sharedPref = await SharedPreferencesService.instance;
    sharedPref.setIsCheckVersion(true);
  }
  log("Handling a background message ${message?.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  configureInjection();
  try {
    await DataHelper.cleanAll();
  } catch (e) {
    log(e.toString());
  }

  await EasyLocalization.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String versionBuild = packageInfo.buildNumber;

  globalApp.setVersion = version;
  globalApp.setVersionBuild = versionBuild;
  globalApp.setIsLogin = false;

  FcmServices().configLocalNoti();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  HttpOverrides.global = MyHttpoverrides();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(LanguageHelper.en),
        Locale(LanguageHelper.vi),
      ],
      assetLoader: const DioAssetLoader(),
      fallbackLocale: const Locale(LanguageHelper.vi),
      startLocale: const Locale(LanguageHelper.vi),
      path: "assets/lang",
      errorWidget: (message) {
        return ColoredBox(
          color: MyColor.bgDrawerColor,
          child: Center(
            child: Text(
              message.toString(),
            ),
          ),
        );
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LangBloc(),
          ),
          BlocProvider(
            create: (context) => AuthenticationBloc(),
          ),
          BlocProvider(
            create: (context) => AppBloc(),
          ),
          BlocProvider(
            create: (context) =>
                ConfigurationBloc()..add(ConfigurationLoaded()),
          )
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<LangBloc, LangState>(
              listener: (context, state) {
                if (state is LangChangeLoadSuccess) {
                  switch (state.lang) {
                    case LanguageHelper.vi:
                      context.setLocale(const Locale(LanguageHelper.vi));
                      break;
                    case LanguageHelper.en:
                      context.setLocale(const Locale(LanguageHelper.en));
                      break;
                    default:
                      context
                          .setLocale(const Locale(MyConstants.languageDefault));
                  }
                }
              },
            ),
          ],
          child: const MPI(),
        ),
      ),
    ),
  );
  configLoading();
  FlutterNativeSplash.remove();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = MyColor.defaultColor
    ..backgroundColor = Colors.black.withOpacity(0.1)
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
    // ..badCertificateCallback =
    // (X509Certificate cert, String host, int port) => true;
  }
}
