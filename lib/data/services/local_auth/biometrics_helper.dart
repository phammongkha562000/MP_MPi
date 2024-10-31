import 'package:easy_localization/easy_localization.dart';

class BiometricsHelper {
  static String faceId = "face_id".tr();
  static String fingerprint = "fingerprint".tr();
  static String strong = "strong".tr();
  static String weak = "weak".tr();
  static String iris = "iris".tr();
  static String notBiometrics = "notBiometrics".tr();

  static int authenticateSuccess = 2000;
  static int cancelAuthenticate = 2001;
  static int authenticateFailure = 2002;
}
