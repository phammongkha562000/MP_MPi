part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentSuccess extends DocumentState {
  final List<FileDocumentResponse> fileList;
  const DocumentSuccess({required this.fileList});
  @override
  List<Object> get props => [fileList];
}

class DocumentFailure extends DocumentState {
  final String message;
  final int? errorCode;
  const DocumentFailure({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
