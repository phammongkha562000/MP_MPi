import '../../presentations/common/constants.dart';

class ServerMode {
  const ServerMode._(this._code);
  final int _code;
  int get code => _code;

  static const ServerMode undefined = ServerMode._(0);
  static const ServerMode prod = ServerMode._(1);
  static const ServerMode dev = ServerMode._(2);
  static const ServerMode qa = ServerMode._(3);
  @override
  String toString() {
    switch (_code) {
      case 1:
        return MyConstants.prod;
      case 2:
        return MyConstants.dev;
      case 3:
        return MyConstants.qa;
      default:
        return '';
    }
  }

  factory ServerMode.from(int code) {
    switch (code) {
      case 1:
        return prod;
      case 2:
        return dev;
      case 3:
        return qa;
      default:
        return undefined;
    }
  }
}
