part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object> get props => [];
}

class DocumentViewLoaded extends DocumentEvent {
  final List<FileResponse> fileList;
  const DocumentViewLoaded({
    required this.fileList,
  });
  @override
  List<Object> get props => [fileList];
}
