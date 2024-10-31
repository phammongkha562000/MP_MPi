class FileInfo {
  final String path;
  final String name;
  final String id;
  FileInfo({required this.path, required this.name, required this.id});

  factory FileInfo.fromMap(Map<String, dynamic> map) {
    return FileInfo(
        path: map['path'] as String,
        name: map['name'] as String,
        id: map['id'] as String);
  }
}
