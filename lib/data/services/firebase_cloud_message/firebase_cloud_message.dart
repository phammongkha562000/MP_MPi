import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/data/services/injection/injection_mpi.dart';
import 'package:mpi_new/data/services/navigator/navigation_service.dart';
import 'package:mpi_new/presentations/common/constants.dart';
import 'package:mpi_new/presentations/widgets/dialog/my_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/global_app.dart';

class FcmServices {
  late AndroidNotificationChannel channel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void firebaseCloudMessagingListeners(ValueNotifier totalNotifications) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('A new onMessage event was published!');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null &&
          notification.title != null &&
          notification.title!.contains("[VERSION]")) {
        dialogToLogin(text: notification.body ?? '');
      }
      totalNotifications.value++;
      globalApp.setCountNotification = totalNotifications.value;
      if (notification != null && android != null) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          await notificationDetails(),
          payload: 'item x',
        );
      }
    });
  }

  dialogToLogin({required String text}) async {
    final navigationService = getIt<NavigationService>();
    BlocProvider.of<AppBloc>(navigationService.navigatorKey.currentContext!)
        .add(LogOut());

    return MyDialog.showWarning(
      context: navigationService.navigatorKey.currentContext!,
      message: text,
      pressOk: () {
        goUpdateApp();
      },
    );
  }

  notificationDetails() {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentSound: true, presentAlert: true, presentBadge: true);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  void iosPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
  }

  Future<void> configLocalNoti() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestAlertPermission: true,
            requestBadgePermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  void goUpdateApp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? MyConstants.androidAppId : MyConstants.iOSAppId;
      final url = Uri.parse(Platform.isAndroid
          ? "${MyConstants.urlGooglePlay}$appId"
          : "${MyConstants.urlAppStore}$appId");
      launchUrl(url, mode: LaunchMode.externalApplication)
          .whenComplete(() => exit(0));
    }
  }
}
