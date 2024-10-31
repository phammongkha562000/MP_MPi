import 'dart:io';

class FileSend {
  final String docRefType;
  final String refNoType;
  final String refNoValue;
  final int createUser;
  final int userId;
  final List<File> files;
  FileSend(
      {required this.docRefType,
      required this.refNoType,
      required this.refNoValue,
      required this.createUser,
      required this.userId,
      required this.files});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docRefType': docRefType,
      'refNoType': refNoType,
      'refNoValue': refNoValue,
      'createUser': createUser,
      'userId': userId,
      'files': files
    };
  }
}
