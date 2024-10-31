part of 'pdf_viewer_bloc.dart';

abstract class PdfViewerState extends Equatable {
  const PdfViewerState();

  @override
  List<Object?> get props => [];
}

class PdfViewerInitial extends PdfViewerState {}

class PdfViewerLoading extends PdfViewerState {}

class PdfViewerSuccess extends PdfViewerState {}

class PdfViewerFailure extends PdfViewerState {
  final String message;
  final int? errorCode;
  const PdfViewerFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
