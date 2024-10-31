import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'service_request_detail_event.dart';
part 'service_request_detail_state.dart';

class ServiceRequestDetailBloc
    extends Bloc<ServiceRequestDetailEvent, ServiceRequestDetailState> {
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();
  ServiceRequestDetailBloc() : super(ServiceRequestDetailInitial()) {
    on<ServiceRequestDetailViewLoaded>(_mapViewLoadedToState);
    on<SaveServiceApproval>(_mapSaveToState);
  }
  Future<void> _mapViewLoadedToState(
      ServiceRequestDetailViewLoaded event, emit) async {
    emit(ServiceRequestDetailLoading());
    try {
      ApiResult apiResult = await _serviceRequestRepo.getServiceRequestDetail(
          svrNo: event.svrNo, employeeId: globalUser.getEmployeeId);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ServiceRequestDetailFailure(
           message:  error.errorMessage,
            errorCode: error.errorCode));
        return;
      }
      ApiResponse apiDetail = apiResult.data;
      ServiceRequestDetailResponse detail = apiDetail.payload;
      ApiResult apiResultFile = await _serviceRequestRepo
          .getServiceRequestDocument(svrNo: event.svrNo, type: 'SVR');
      if (apiResultFile.isFailure) {
        Error? error = apiResultFile.getErrorResponse();
        emit(ServiceRequestDetailFailure(
            message: error.errorMessage,
            errorCode: error.errorCode));
        return;
      }
      ApiResponse apiFile = apiResultFile.data;
      emit(ServiceRequestDetailSuccess(
          detail: detail, fileList: apiFile.payload));
    } catch (e) {
      emit(const ServiceRequestDetailFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSaveToState(SaveServiceApproval event, emit) async {
    try {
      final currentState = state;

      if (currentState is ServiceRequestDetailSuccess) {
        final content = SaveServiceApprovalRequest(
            comment: event.comment,
            approvalType: event.approvalType,
            employeeId: globalUser.getEmployeeId,
            userId: globalUser.getEmployeeId,
            costCenter: '',
            hLvNo: event.hLvNo);
        ApiResult apiResult =
            await _serviceRequestRepo.postSaveServiceApproval(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(ServiceRequestDetailFailure(
              message: error.errorMessage,
              errorCode: error.errorCode));
          return;
        }
        ApiResponse apiUpdate = apiResult.data;
        if (apiUpdate.success == false) {
          emit(ServiceRequestDetailFailure(
              message: apiUpdate.error.errorMessage));
          return;
        }
        if (apiUpdate.error.errorCode != null) {
          emit(ServiceRequestDetailFailure(
              message: apiUpdate.error.errorMessage));
          log('Error: ${apiUpdate.error.errorMessage}');
        } else {
          emit(ServiceApprovalSuccessful());
          add(ServiceRequestDetailViewLoaded(svrNo: event.hLvNo));
          log('Success approval success');
          return;
        }
        emit(currentState);
        log('Error: ${apiUpdate.error.errorMessage}');
      }
    } catch (e) {
      emit(const ServiceRequestDetailFailure(message: MyError.messError));
    }
  }
}
