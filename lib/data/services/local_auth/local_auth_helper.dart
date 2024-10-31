import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mpi_new/data/data.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthHelper {
  static final LocalAuthentication localAuth = LocalAuthentication();
  static Future<String> checkBiometrics() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();

    if (canCheckBiometrics) {
      if (availableBiometrics.contains(BiometricType.face)) {
        return BiometricsHelper.faceId;
      }
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return BiometricsHelper.fingerprint;
      }
      if (availableBiometrics.contains(BiometricType.iris)) {
        return BiometricsHelper.iris;
      }
      if (availableBiometrics.contains(BiometricType.strong)) {
        return BiometricsHelper.strong;
      }
      if (availableBiometrics.contains(BiometricType.weak)) {
        return BiometricsHelper.weak;
      }

      return BiometricsHelper.notBiometrics;
    } else {
      return BiometricsHelper.notBiometrics;
    }
  }

  static Future<int> isAuthenticated() async {
    if (Platform.isAndroid) {
      return await checkWithAndroid();
    } else if (Platform.isIOS) {
      return await checkWithIOS();
    }
    return BiometricsHelper.authenticateFailure;
  }

  static Future<int> checkWithAndroid() async {
    try {
      String type = await checkBiometrics();
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: '${"authenticate".tr()}$type',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // Tắt/Bật tùy chọn nhập mật khẩu
        ),
      );

      if (isAuthenticated) {
        return BiometricsHelper.authenticateSuccess;
      } else {
        return BiometricsHelper.cancelAuthenticate;
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        return BiometricsHelper.authenticateFailure;
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        return BiometricsHelper.authenticateFailure;
      } else {
        return BiometricsHelper.authenticateFailure;
      }
    }
  }

  static Future<int> checkWithIOS() async {
    try {
      String type = await checkBiometrics();
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: '${"authenticate".tr()}$type',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // Tắt/Bật tùy chọn nhập mật khẩu
        ),
      );

      if (isAuthenticated) {
        return BiometricsHelper.authenticateSuccess;
      } else {
        return BiometricsHelper.authenticateFailure;
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        return BiometricsHelper.authenticateFailure;
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        return BiometricsHelper.authenticateFailure;
      } else {
        return BiometricsHelper.cancelAuthenticate;
      }
    }
  }
}
