import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'leave_detail_event.dart';
part 'leave_detail_state.dart';

class LeaveDetailBloc extends Bloc<LeaveDetailEvent, LeaveDetailState> {
  final _leaveRepo = getIt<LeaveRepository>();

  LeaveDetailBloc() : super(LeaveDetailInitial()) {
    on<LeaveDetailLoaded>(_mapViewToState);
    on<SaveLeaveApproval>(_mapSaveToState);
  }
  Future<void> _mapViewToState(LeaveDetailLoaded event, emit) async {
    try {
      emit(LeaveDetailLoading());

      ApiResult apiResult = await _leaveRepo.getLeaveDetail(lvNo: event.lvNo);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(LeaveDetailFailure(
           message:  error.errorMessage,
            errorCode: error.errorCode));
        return;
      }
      ApiResponse getLeaveDetail = apiResult.data;
      if (getLeaveDetail.success == false) {
        emit(LeaveDetailFailure(message: getLeaveDetail.error.errorMessage));
        return;
      }
      if (getLeaveDetail.success == true) {
        emit(LeaveDetailLoadSuccess(leaveDetail: getLeaveDetail.payload));
      } else {
        emit(LeaveDetailFailure(message: "no_data".tr()));
      }
    } catch (e) {
      emit(LeaveDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapSaveToState(SaveLeaveApproval event, emit) async {
    try {
      final currentState = state;
      if (currentState is LeaveDetailLoadSuccess) {
        final content = SaveLeaveApprovalRequest(
            comment: event.comment,
            approvalType: event.approvalType,
            existedUserId: '1',
            userId: globalUser.getEmployeeId,
            hLvNo: event.hLvNo);
        ApiResult apiResult =
            await _leaveRepo.postSaveLeaveApproval(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(LeaveDetailFailure(
              message: error.errorMessage,
              errorCode: error.errorCode));
          return;
        }
        ApiResponse apiUpdate = apiResult.data;
        if (apiUpdate.success == false) {
          emit(LeaveDetailFailure(message: apiUpdate.error.errorMessage));
          return;
        }
        if (apiUpdate.error.errorCode != null) {
          emit(LeaveDetailFailure(message: apiUpdate.error.errorMessage));
          log('Error: ${apiUpdate.error.errorMessage}');
        } else {
          emit(LeaveApprovalSuccessful());
          add(LeaveDetailLoaded(lvNo: event.hLvNo));
          log('Leave approval success');
          return;
        }
        emit(currentState);
      }
    } catch (e) {
      emit(LeaveDetailFailure(message: e.toString()));
    }
  }
}
