part of 'display_file_bloc.dart';

abstract class DisplayFileEvent extends Equatable {
  const DisplayFileEvent();

  @override
  List<Object> get props => [];
}

class DisplayFileViewLoaded extends DisplayFileEvent {
  final List<FileResponse> fileList;
  const DisplayFileViewLoaded({
    required this.fileList,
  });
  @override
  List<Object> get props => [fileList];
}

class DisplayFileDownload extends DisplayFileEvent {
  final DSGetDocumentResult file;
  const DisplayFileDownload({
    required this.file,
  });
  @override
  List<Object> get props => [file];
}
