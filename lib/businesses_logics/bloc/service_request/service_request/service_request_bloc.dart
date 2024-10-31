import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'service_request_event.dart';
part 'service_request_state.dart';

class ServiceRequestBloc
    extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<ServiceRequestResult> svrLst = [];
  ServiceRequestBloc() : super(ServiceRequestInitial()) {
    on<ServiceRequestViewLoaded>(_mapViewLoadedToState);
    on<ServiceRequestPaging>(_mapPagingToState);
    on<ServiceRequestChangeDate>(_mapChangeDateToState);
  }
  Future<void> _mapViewLoadedToState(
      ServiceRequestViewLoaded event, emit) async {
    emit(ServiceRequestLoading());
    try {
      svrLst.clear();
      pageNumber = 1;
      endPage = false;
      final DateTime fromDate =
          DateTime.now().subtract(const Duration(days: 7));
      final DateTime toDate = DateTime.now();

      ApiResult apiResult =
          await _getServiceRequest(fromDate: fromDate, toDate: toDate);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ServiceRequestFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(ServiceRequestFailure(message: apiResponse.error.errorMessage));
        return;
      }
      if (apiResponse.error.errorCode == null) {
        ServiceRequestResponse svr = apiResponse.payload;
        List<ServiceRequestResult> lstSvr = svr.result ?? [];
        svrLst.addAll(lstSvr);
        quantity = svr.totalRecord ?? 0;
        emit(ServiceRequestSuccess(serviceList: svrLst, quantity: quantity));
      } else {
        emit(ServiceRequestFailure(message: apiResponse.error.errorMessage));
      }
    } catch (e) {
      emit(const ServiceRequestFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPagingToState(ServiceRequestPaging event, emit) async {
    try {
      if (quantity == svrLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(ServiceRequestPagingLoading());
        pageNumber++;
        DateTime fromDate = event.fromDate;
        DateTime toDate = event.toDate;

        ApiResult apiResult =
            await _getServiceRequest(fromDate: fromDate, toDate: toDate);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(ServiceRequestFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(ServiceRequestFailure(message: apiResponse.error.errorMessage));
          return;
        }
        if (apiResponse.error.errorCode == null) {
          ServiceRequestResponse svr = apiResponse.payload;
          List<ServiceRequestResult> lstSvr = svr.result ?? [];

          if (lstSvr != [] && lstSvr.isNotEmpty) {
            svrLst.addAll(lstSvr);
          } else {
            endPage = true;
          }
          emit(ServiceRequestSuccess(
              serviceList: svrLst, quantity: svr.totalRecord ?? 0));
        } else {
          emit(ServiceRequestFailure(message: apiResponse.error.errorMessage));
        }
      }
    } catch (e) {
      emit(ServiceRequestFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeDateToState(
      ServiceRequestChangeDate event, emit) async {
    try {
      emit(ServiceRequestLoading());
      svrLst.clear();
      pageNumber = 1;
      endPage = false;
      DateTime fromDate = event.fromDate;
      DateTime toDate = event.toDate;

      ApiResult apiResult =
          await _getServiceRequest(fromDate: fromDate, toDate: toDate);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ServiceRequestFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(ServiceRequestFailure(message: apiResponse.error.errorMessage));
        return;
      }
      ServiceRequestResponse svr = apiResponse.payload;
      List<ServiceRequestResult> lstSvr = svr.result ?? [];
      svrLst.addAll(lstSvr);
      quantity = svr.totalRecord ?? 0;
      emit(ServiceRequestSuccess(
          serviceList: svrLst, quantity: svr.totalRecord ?? 0));
    } catch (e) {
      emit(const ServiceRequestFailure(message: MyError.messError));
    }
  }

  Future<ApiResult> _getServiceRequest(
      {required DateTime fromDate, required DateTime toDate}) async {
    final fromEvent = DateFormat(MyConstants.yyyyMMdd).format(fromDate);
    final toEvent = DateFormat(MyConstants.yyyyMMdd).format(toDate);
    final content = ServiceRequestRequest(
        type: "0",
        status: "",
        submitDateF: fromEvent,
        submitDateT: toEvent,
        userId: globalUser.employeeId ?? 0,
        skipRecord: 0,
        takeRecord: 12,
        pageNumber: pageNumber,
        rowNumber: MyConstants.pagingSize);
    ApiResult apiResult =
        await _serviceRequestRepo.postServiceRequest(content: content);
    return apiResult;
  }
}
