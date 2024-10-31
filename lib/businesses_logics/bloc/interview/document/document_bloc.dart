import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc() : super(DocumentInitial()) {
    on<DocumentLoaded>(_mapViewToState);
  }
  void _mapViewToState(DocumentLoaded event, emit) async {
    emit(DocumentLoading());
    try {
      emit(DocumentLoadSuccess(fileLocation: event.fileLocation));
    } catch (e) {
      emit(DocumentFailure(message: e.toString()));
    }
  }
}
