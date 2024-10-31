part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class DocumentLoaded extends DocumentEvent {
  final String fileLocation;
  const DocumentLoaded({
    required this.fileLocation,
  });
  @override
  List<Object?> get props => [fileLocation];
}
