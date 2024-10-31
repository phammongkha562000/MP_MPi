import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../../data/data.dart';
import '../../../application_bloc/app_bloc.dart';

part 'it_service_detail_event.dart';
part 'it_service_detail_state.dart';

class ITServiceDetailBloc
    extends Bloc<ITServiceDetailEvent, ITServiceDetailState> {
  final _itRepo = getIt<ITServiceRepository>();

  ITServiceDetailBloc() : super(ItServiceDetailInitial()) {
    on<ITServiceDetailLoaded>(_mapViewToState);
    on<ITServiceDetailChangeAssign>(_mapChangeAssignToState);
    on<ITServiceDetailChooseStatus>(_mapChooseStatusToState);
    on<ITServiceDetailReply>(_mapSentChatToState);
  }

  Future<void> _mapViewToState(ITServiceDetailLoaded event, emit) async {
    try {
      emit(ITServiceDetailLoading());
      ApiResult apiResult =
          await _itRepo.getITServiceDetail(irsNo: event.irsNo.toString());
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();

        emit(ITServiceDetailFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse itService = apiResult.data;
      if (itService.success == false) {
        emit(ITServiceDetailFailure(message: itService.error.errorMessage));
        return;
      }

      List<StdCode> listItService = event.appBloc.listItService;
      if (listItService.isEmpty) {
        final getItServiceData = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeITService,
        );
        if (getItServiceData is ApiResult) {
          if (getItServiceData.isFailure) {
            Error? error = getItServiceData.getErrorResponse();
            emit(ITServiceFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listItService = getItServiceData;
        listItService = getItServiceData;
      }

      List<StdCode> listSVC = event.appBloc.listSVC;
      if (listSVC.isEmpty) {
        final getSVC =
            await event.appBloc.getStdCodeWithType(type: TypeStdCode.typeSVC);
        if (getSVC is ApiResult) {
          if (getSVC.isFailure) {
            Error? error = getSVC.getErrorResponse();
            emit(ITServiceFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listSVC = getSVC;
        listSVC = getSVC;
      }

      List<StdCode> listSrStatus = event.appBloc.listSrStatus;
      if (listSrStatus.isEmpty) {
        final getSrStatus = await event.appBloc
            .getStdCodeWithType(type: TypeStdCode.typeSrStatus);
        if (getSrStatus is ApiResult) {
          if (getSrStatus.isFailure) {
            Error? error = getSrStatus.getErrorResponse();
            emit(ITServiceDetailFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listSrStatus = getSrStatus;
        listSrStatus = getSrStatus;
      }

      List<ITAdminResponse> listITAdmin = [];

      if (event.appBloc.listITAdmin.isEmpty) {
        ApiResult apiResultITAdmin = await _itRepo.getITAdmin(value: "-1");
        if (apiResultITAdmin.isFailure) {
          Error error = apiResult.getErrorResponse();

          emit(ITServiceDetailFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse getApi = apiResultITAdmin.data;
        if (!getApi.success) {
          emit(ITServiceDetailFailure(message: itService.error.errorMessage));
          return;
        }

        listITAdmin = getApi.payload;
        event.appBloc.listITAdmin = listITAdmin;
      } else {
        listITAdmin = event.appBloc.listITAdmin
            .map((e) => e.copyWith(isSelected: false))
            .toList();
      }

      emit(ITServiceDetailLoadSuccess(
          irsNo: event.irsNo,
          itServiceDetailResponse: itService.payload,
          listItService: listItService,
          listSrStatus: listSrStatus,
          listSVC: listSVC,
          listITAdmin: listITAdmin,
          selectedStatus: listSrStatus[1]));
    } catch (e) {
      emit(ITServiceDetailFailure(message: e.toString(), irsNo: event.irsNo));
    }
  }

  Future<void> _mapChangeAssignToState(
      ITServiceDetailChangeAssign event, emit) async {
    try {
      final currentState = state;
      if (currentState is ITServiceDetailLoadSuccess) {
        emit(ITServiceDetailLoading());

        List<ITAdminResponse> listITAdmin = [];

        listITAdmin = currentState.listITAdmin!
            .map((e) => e.itAdmin == event.itAdmin
                ? e.copyWith(isSelected: event.isSelected)
                : e)
            .toList();

        List<ITAdminResponse> a =
            listITAdmin.where((element) => element.isSelected == true).toList();
        var b = a.map((e) => e.itAdmin).toList();
        log("SENT: ${b.join(',')}");

        emit(currentState.copyWith(listITAdmin: listITAdmin));
      }
    } catch (e) {
      emit(ITServiceDetailFailure(message: e.toString(), irsNo: event.irsNo));
    }
  }

  Future<void> _mapChooseStatusToState(
      ITServiceDetailChooseStatus event, emit) async {
    try {
      final currentState = state;
      if (currentState is ITServiceDetailLoadSuccess) {
        emit(ITServiceDetailLoading());
        emit(currentState.copyWith(selectedStatus: event.stdSelected));
      }
    } catch (e) {
      emit(ITServiceDetailFailure(message: e.toString(), irsNo: event.irsNo));
    }
  }

  Future<void> _mapSentChatToState(ITServiceDetailReply event, emit) async {
    try {
      final currentState = state;
      if (currentState is ITServiceDetailLoadSuccess) {
        var list = currentState.listITAdmin!.toList();
        List<ITAdminResponse> a =
            list.where((element) => element.isSelected == true).toList();

        var assignTo = a.map((e) => e.itAdmin).toList();

        final dataChat = ItServiceReplyRequest(
            createuser: globalUser.employeeId.toString(),
            assignTo: assignTo.join(','),
            details: event.detailsChat,
            iSrNo: currentState.irsNo,
            sRStatus: event.srStatus);
        ApiResult apiResult =
            await _itRepo.replyITServiceDetail(content: dataChat);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();

          emit(ITServiceDetailFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse reply = apiResult.data;
        if (reply.success == true) {
          ApiResult apiResult =
              await _itRepo.getITServiceDetail(irsNo: event.irsNo.toString());
          if (apiResult.isFailure) {
            Error error = apiResult.getErrorResponse();

            emit(ITServiceDetailFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          ApiResponse itService = apiResult.data;
          if (itService.success == false) {
            emit(ITServiceDetailFailure(message: itService.error.errorMessage));
            return;
          }
          List<ITAdminResponse> listITAdmin = [];
          if (event.appBloc.listITAdmin.isEmpty) {
            ApiResult apiResultITAdmin = await _itRepo.getITAdmin(value: "-1");
            if (apiResultITAdmin.isFailure) {
              Error error = apiResult.getErrorResponse();

              emit(ITServiceDetailFailure(
                  message: error.errorMessage, errorCode: error.errorCode));
              return;
            }
            ApiResponse getApi = apiResultITAdmin.data;
            if (!getApi.success) {
              emit(ITServiceDetailFailure(
                  message: itService.error.errorMessage));
              return;
            }

            listITAdmin = getApi.payload;
            event.appBloc.listITAdmin = listITAdmin;
          } else {
            listITAdmin = event.appBloc.listITAdmin
                .map((e) => e.copyWith(isSelected: false))
                .toList();
          }

          emit(currentState.copyWith(
              itServiceDetailResponse: itService.payload,
              listITAdmin: listITAdmin));
        }
      }
    } catch (e) {
      emit(ITServiceDetailFailure(message: e.toString(), irsNo: event.irsNo));
    }
  }
}
