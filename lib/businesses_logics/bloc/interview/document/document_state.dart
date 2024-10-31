part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentLoadSuccess extends DocumentState {
  final String fileLocation;
  const DocumentLoadSuccess({
    required this.fileLocation,
  });
  @override
  List<Object> get props => [fileLocation];
}

class DocumentFailure extends DocumentState {
  final String message;
  final String? errorCode;
  const DocumentFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
