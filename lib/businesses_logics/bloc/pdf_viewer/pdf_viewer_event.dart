part of 'pdf_viewer_bloc.dart';

abstract class PdfViewerEvent extends Equatable {
  const PdfViewerEvent();

  @override
  List<Object> get props => [];
}

class PdfViewerViewLoaded extends PdfViewerEvent {}

class PdfViewerDownload extends PdfViewerEvent {}
