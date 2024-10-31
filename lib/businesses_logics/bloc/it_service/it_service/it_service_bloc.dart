import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../../data/data.dart';
import '../../../application_bloc/app_bloc.dart';

part 'it_service_event.dart';
part 'it_service_state.dart';

class ITServiceBloc extends Bloc<ITServiceEvent, ITServiceState> {
  final _itRepo = getIt<ITServiceRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<ITServiceResult> itSvrLst = [];
  ITServiceBloc() : super(ITServiceInitial()) {
    on<ITServiceLoaded>(_mapViewToState);
    on<ITServiceChangeMonth>(_mapChangeMonthToState);
    on<ITServicePaging>(_mapPagingToState);
  }

  Future<void> _mapViewToState(ITServiceLoaded event, emit) async {
    try {
      emit(ITServiceLoading());
      itSvrLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;
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
        final getSVC = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeSVC,
        );
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
        final getSrStatus = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeSrStatus,
        );
        if (getSrStatus is ApiResult) {
          if (getSrStatus.isFailure) {
            Error? error = getSrStatus.getErrorResponse();
            emit(ITServiceFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listSrStatus = getSrStatus;
        listSrStatus = getSrStatus;
      }

      List<StdCode> listPriority = event.appBloc.listPriority;
      if (listPriority.isEmpty) {
        final getPriority = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typePRIORITY,
        );
        if (getPriority is ApiResult) {
          if (getPriority.isFailure) {
            Error? error = getPriority.getErrorResponse();
            emit(ITServiceFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listPriority = getPriority;
        listPriority = getPriority;
      }

      final fromDate = event.dateFrom;
      final toDate = event.dateTo;
      ApiResult apiResult = await getItService(
        isSearch: event.isSearch ?? false,
        dateFrom: fromDate,
        dateTo: toDate,
        isrNo: event.irsNo,
        itService: event.stdITServiceType,
        createUserName: event.createUser,
        status: event.srStatus,
        subject: event.subject,
        svcType: event.svc,
      );
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ITServiceFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse itService = apiResult.data;
      if (itService.success == false) {
        emit(ITServiceFailure(message: itService.error.errorMessage));
        return;
      }
      ITServiceResponse itRes = itService.payload;
      itSvrLst.addAll(itRes.result ?? []);
      quantity = itRes.totalRecord ?? 0;
      emit(ITServiceLoadSuccess(
        quantity: itRes.totalRecord ?? 0,
        dateF: fromDate,
        dateT: toDate,
        listITServiceSearch: itSvrLst,
        listItService: listItService,
        listSrStatus: listSrStatus,
        listSVC: listSVC,
        listPriority: listPriority,
      ));
    } catch (e) {
      emit(ITServiceFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeMonthToState(ITServiceChangeMonth event, emit) async {
    try {
      emit(ITServiceLoading());
      itSvrLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      ApiResult apiResult = await getItService(
          isSearch: event.isSearch ?? false,
          isrNo: event.irsNo,
          itService: event.stdITServiceType,
          createUserName: event.createUser,
          status: event.srStatus,
          subject: event.subject,
          svcType: event.svc,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ITServiceFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse itService = apiResult.data;
      if (itService.success == false) {
        emit(ITServiceFailure(message: itService.error.errorMessage));
        return;
      }
      ITServiceResponse itRes = itService.payload;
      itSvrLst.addAll(itRes.result ?? []);
      quantity = itRes.totalRecord ?? 0;
      emit(ITServiceSearchSuccess(
          listITServiceSearch: itSvrLst,
          dateF: event.dateFrom,
          dateT: event.dateTo,
          quantity: quantity));
    } catch (e) {
      emit(ITServiceFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(ITServicePaging event, emit) async {
    try {
      if (quantity == itSvrLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(ITServicePagingLoading());
        pageNumber++;
        DateTime fromDate = event.dateFrom;
        DateTime toDate = event.dateTo;

        ApiResult apiResult = await getItService(
          dateFrom: fromDate,
          dateTo: toDate,
          isSearch: event.isSearch ?? false,
          isrNo: event.irsNo,
          itService: event.stdITServiceType,
          createUserName: event.createUser,
          status: event.srStatus,
          subject: event.subject,
          svcType: event.svc,
        );
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(ITServiceFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(ITServiceFailure(message: apiResponse.error.errorMessage));
          return;
        }
        if (apiResponse.error.errorCode == null) {
          ITServiceResponse itSvr = apiResponse.payload;
          List<ITServiceResult> lstSvr = itSvr.result ?? [];

          if (lstSvr != [] && lstSvr.isNotEmpty) {
            itSvrLst.addAll(lstSvr);
          } else {
            endPage = true;
          }
          emit(ITServiceSearchSuccess(
              listITServiceSearch: itSvrLst,
              quantity: itSvr.totalRecord ?? 0,
              dateF: fromDate,
              dateT: toDate));
        } else {
          emit(ITServiceFailure(message: apiResponse.error.errorMessage));
        }
      }
    } catch (e) {
      emit(ITServiceFailure(message: e.toString()));
    }
  }

  Future<ApiResult<ApiResponse>> getItService({
    bool? isSearch,
    required DateTime dateFrom,
    required DateTime dateTo,
    String? details,
    String? isrNo,
    String? itService,
    String? svcType,
    String? createUserName,
    String? subject,
    String? subsidiaryId,
    String? subsidiary,
    String? status,
    String? serviceType,
    String? createdUser,
    String? assignTo,
  }) async {
    String postDateF = "";
    String postDateT = "";

    var formatter = DateFormat(MyConstants.yyyyMMdd, "en");
    var a = formatter.format(dateFrom);
    var b = formatter.format(dateTo);
    if (isSearch == true) {
      postDateF = a;
      postDateT = b;
    } else {
      if (a == b) {
        postDateF = FindDate.firstDateOfMonth_yyyyMMdd(today: dateFrom);
        postDateT = FindDate.lastDateOfMonth_yyyyMMdd(today: dateTo);
      } else if (a == b) {
        postDateF = FindDate.firstDateOfMonth_yyyyMMdd(today: dateFrom);
        postDateT = FindDate.lastDateOfMonth_yyyyMMdd(today: dateTo);
      } else {
        postDateF = a;
        postDateT = b;
      }
    }
    log("$postDateF\n$postDateT");

    final content = ItServiceSearchRequest(
        details: details ?? "",
        isrNo: isrNo ?? "",
        itService: itService ?? "",
        postDateF: postDateF,
        postDateT: postDateT,
        svcType: svcType ?? "",
        createUserName: createUserName ?? "",
        subject: subject ?? "",
        subsidiaryId: subsidiaryId ?? "",
        subsidiary: subsidiary ?? "",
        status: status ?? "",
        serviceType: serviceType ?? "",
        createdUser: createUserName ?? "",
        skipRecord: 0,
        takeRecord: 20,
        sortColumn: "ISRNo", //* hard
        sortOrder: "ASC", //* hard
        employeeId: globalUser.employeeId.toString(),
        assignTo: assignTo ?? "",
        pageNumber: pageNumber,
        rowNumber: MyConstants.pagingSize);

    final api = await _itRepo.getITService(content: content);
    return api;
  }
}
