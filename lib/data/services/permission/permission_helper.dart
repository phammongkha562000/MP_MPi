import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static requestLocation() async {
    try {
      var status = await Permission.locationWhenInUse.request();

      if (status.isGranted) {
        log("Location được cấp");
      } else {
        log("Location ko được cấp");
      }
    } on PlatformException catch (e) {
      log("LOCATION FAILS: $e");
    }
  }

  static requestCamera() async {
    try {
      var status = await Permission.camera.request();

      if (status.isGranted) {
        log("Cam được cấp");
      } else {
        log("Cam ko được cấp");
      }
    } on PlatformException catch (e) {
      // Xử lý ngoại lệ nếu có
      log("Cam FAILS: $e");
    }
  }

  static requestPhoto() async {
    try {
      var status = await Permission.photos.request();

      if (status.isGranted) {
        log("photos được cấp");
      } else {
        log("photos ko được cấp");
      }
    } on PlatformException catch (e) {
      log("photos FAILS: $e");
    }
  }

  static requestStore() async {
    try {
      var status = await Permission.storage.request();

      if (status.isGranted) {
        log("storage được cấp");
      } else {
        log("storage ko được cấp");
      }
    } on PlatformException catch (e) {
      log("storage FAILS: $e");
    }
  }

  static requestNotification() async {
    try {
      var status = await Permission.notification.request();

      if (status.isGranted) {
        log("notification được cấp");
      } else {
        log("notification ko được cấp");
      }
    } on PlatformException catch (e) {
      log("notification FAILS: $e");
    }
  }
}
