part of 'display_file_bloc.dart';

abstract class DisplayFileState extends Equatable {
  const DisplayFileState();

  @override
  List<Object?> get props => [];
}

class DisplayFileInitial extends DisplayFileState {}

class DisplayFileLoading extends DisplayFileState {}

class DisplayFileSuccess extends DisplayFileState {
  final List<FileDocumentResponse> fileList;
  const DisplayFileSuccess({
    required this.fileList,
  });
  @override
  List<Object> get props => [fileList];
}

class DisplayFileFailure extends DisplayFileState {
  final String message;
  final int? errorCode;
  const DisplayFileFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class DisplayFileDownloadSuccess extends DisplayFileState {
  final String fileLocation;
  final String fileType;
  const DisplayFileDownloadSuccess({
    required this.fileLocation,
    required this.fileType,
  });
  @override
  List<Object?> get props => [fileLocation, fileType];
}
