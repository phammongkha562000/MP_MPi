class GlobalApp {
  String? version;
  get getVersion => version;
  set setVersion(value) => version = value;

  String? versionBuild;
  String? get getVersionBuild => versionBuild;
  set setVersionBuild(String? value) => versionBuild = value;

  String? versionRelease;
  String? get getVersionRelease => versionRelease;
  set setVersionRelease(String? value) => versionRelease = value;

  int? countNotification;
  int? get getCountNotification => countNotification;
  set setCountNotification(int? value) => countNotification = value;

  bool? isLogin;
  bool? get getIsLogin => isLogin;
  set setIsLogin(bool? value) => isLogin = value;

  String? logoLogin;
  String? get getLogoLogin => logoLogin;
  set setLogoLogin(String? value) => logoLogin = value;

  String? iconLogin;
  String? get getIconLogin => iconLogin;
  set setIconLogin(String? value) => iconLogin = value;

  String? systemName;
  String? get getSystemName => systemName;
  set setSystemName(String? value) => systemName = value;
}

GlobalApp globalApp = GlobalApp();
