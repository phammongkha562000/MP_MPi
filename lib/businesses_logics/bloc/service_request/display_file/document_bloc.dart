import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();

  DocumentBloc() : super(DocumentInitial()) {
    on<DocumentViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(DocumentViewLoaded event, emit) async {
    try {
      final List<FileDocumentResponse> fileList = [];
      for (var element in event.fileList) {
        final apiResult = await _serviceRequestRepo.getServiceDocument(
            docNo: element.docNo ?? 0);
        if (apiResult.isFailure) {
          final error = apiResult.getErrorResponse();
          emit(DocumentFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        fileList.add(apiResponse.payload);
      }
      emit(DocumentSuccess(fileList: fileList));
    } catch (e) {
      log(e.toString());
    }
  }
}
