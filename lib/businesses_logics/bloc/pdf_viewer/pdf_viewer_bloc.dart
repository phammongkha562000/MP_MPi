import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_viewer_event.dart';
part 'pdf_viewer_state.dart';

class PdfViewerBloc extends Bloc<PdfViewerEvent, PdfViewerState> {
  PdfViewerBloc() : super(PdfViewerInitial()) {
    on<PdfViewerEvent>((event, emit) {});
  }
}
