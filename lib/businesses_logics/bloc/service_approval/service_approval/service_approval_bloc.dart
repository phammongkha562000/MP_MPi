import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../application_bloc/app_bloc.dart';

part 'service_approval_event.dart';
part 'service_approval_state.dart';

class ServiceApprovalBloc
    extends Bloc<ServiceApprovalEvent, ServiceApprovalState> {
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<ServiceApprovalResult> svrApprLst = [];
  ServiceApprovalBloc() : super(ServiceApprovalInitial()) {
    on<ServiceApprovalViewLoaded>(_mapViewLoadedToState);
    on<ServiceApprovalChangeDate>(_mapChangeDateToState);
    on<ServiceApprovalPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(
      ServiceApprovalViewLoaded event, emit) async {
    emit(ServiceApprovalLoading());
    try {
      svrApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      bool isPending = true;
      List<ApplicationResponse> applicationList = [
        ApplicationResponse(applicationCode: '', applicationDesc: 'all'.tr())
      ];
      final getApplication = await event.appBloc.getApplication();
      if (getApplication is ApiResult) {
        if (getApplication.isFailure) {
          Error? error = getApplication.getErrorResponse();
          emit(ServiceApprovalFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
      }
      applicationList.addAll(getApplication);

      final StdCode stdFirst = StdCode(codeDesc: 'all'.tr(), codeId: '');
      //std status
      List<StdCode> stdStatusList = [stdFirst];
      if (event.appBloc.listStdStatus.isEmpty) {
        final getStatusList = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeDOCGENSTATUSTSPOSTTYPE,
        );
        if (getStatusList is ApiResult) {
          if (getStatusList.isFailure) {
            Error? error = getStatusList.getErrorResponse();
            emit(ServiceApprovalFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listStdStatus = getStatusList;
        stdStatusList.addAll(getStatusList);
      } else {
        stdStatusList.addAll(event.appBloc.listStdStatus);
      }

      //std cost center
      List<StdCode> stdCostCenterList = [stdFirst];
      if (event.appBloc.listStdCostCenter.isEmpty) {
        final getCostCenterList = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeCOSTCENTER,
        );
        if (getCostCenterList is ApiResult) {
          if (getCostCenterList.isFailure) {
            Error? error = getCostCenterList.getErrorResponse();
            emit(ServiceApprovalFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listStdCostCenter = getCostCenterList;
        stdCostCenterList.addAll(getCostCenterList);
      } else {
        stdCostCenterList.addAll(event.appBloc.listStdCostCenter);
      }

      final fromDate = event.fromDate ??
          DateTime(DateTime.now().year, DateTime.now().month - 3,
              DateTime.now().day);
      final toDate = event.toDate ?? DateTime.now();
      final firstDay = event.fromDate == null
          ? DateFormat(MyConstants.yyyyMMdd).format(DateTime(
              DateTime.now().year,
              DateTime.now().month - 3,
              DateTime.now().day))
          : DateFormat(MyConstants.yyyyMMdd).format(event.fromDate ??
              DateTime(DateTime.now().year, DateTime.now().month - 3,
                  DateTime.now().day));
      final lastDay = event.toDate == null
          ? DateFormat(MyConstants.yyyyMMdd).format(DateTime.now())
          : DateFormat(MyConstants.yyyyMMdd)
              .format(event.toDate ?? DateTime.now());
      final content = ServiceApprovalRequest(
          submitDateF: firstDay,
          submitDateT: lastDay,
          userId: globalUser.employeeId ?? 0,
          isPending: isPending == true ? 1 : 0, //init //1 hoặc != 1
          pageNumber: pageNumber,
          rowNumber: MyConstants.pagingSize);

      ApiResult apiResult =
          await _serviceRequestRepo.postServicePending(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ServiceApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiServiceApproval = apiResult.data;
      if (apiServiceApproval.success == false) {
        emit(ServiceApprovalFailure(
            message: apiServiceApproval.error.errorMessage));
        return;
      }

      if (apiServiceApproval.error.errorCode != null) {
        emit(ServiceApprovalFailure(
            message: apiServiceApproval.error.errorMessage));
        return;
      }
      ServiceApprovalResponse svrApprRes = apiServiceApproval.payload;
      List<ServiceApprovalResult> serviceApprovalList = [];

      serviceApprovalList = svrApprRes.result ?? [];
      svrApprLst.addAll(serviceApprovalList);
      quantity = svrApprRes.totalRecord ?? 0;
      emit(ServiceApprovalSuccess(
          applicationList: applicationList,
          stdCodeList: stdStatusList,
          stdCodeCostCenterList: stdCostCenterList,
          serviceApprovalList: svrApprLst,
          fromDate: fromDate,
          toDate: toDate,
          quantity: quantity,
          isPending: true));
    } catch (e) {
      emit(const ServiceApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapChangeDateToState(
      ServiceApprovalChangeDate event, emit) async {
    try {
      emit(ServiceApprovalLoading());

      svrApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      final fromDate = event.fromDate;
      final toDate = event.toDate;

      final firstDay = FindDate.convertDateyyyyMMdd(today: event.fromDate);

      final lastDay = FindDate.convertDateyyyyMMdd(today: event.toDate);
      log(firstDay.toString());
      log(lastDay.toString());

      final content = ServiceApprovalRequest(
          type: event.application?.applicationCode == ''
              ? null
              : event.application?.applicationCode,
          submitDateF: firstDay,
          submitDateT: lastDay,
          status: event.status?.codeId == '' ? null : event.status?.codeId,
          userId: globalUser.employeeId ?? 0,
          isPending: event.isPending == true ? 1 : 0,
          costCenter:
              event.costCenter?.codeId == '' ? null : event.costCenter?.codeId,
          code: event.code,
          pageNumber: pageNumber,
          rowNumber: MyConstants.pagingSize);
      ApiResult apiResult =
          await _serviceRequestRepo.postServicePending(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ServiceApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiServiceApproval = apiResult.data;
      if (apiServiceApproval.success == false) {
        emit(ServiceApprovalFailure(
            message: apiServiceApproval.error.errorMessage));
        return;
      }
      if (!apiServiceApproval.success) {
        emit(ServiceApprovalFailure(
            message: apiServiceApproval.error.errorMessage));
        return;
      }

      if (apiServiceApproval.error.errorCode != null) {
        emit(ServiceApprovalFailure(
            message: apiServiceApproval.error.errorMessage));
        return;
      }

      ServiceApprovalResponse svrApprRes = apiServiceApproval.payload;
      List<ServiceApprovalResult> serviceApprovalList = [];

      serviceApprovalList = svrApprRes.result ?? [];
      svrApprLst.addAll(serviceApprovalList);
      quantity = svrApprRes.totalRecord ?? 0;
      emit(GetServiceApprovalSuccess(
          fromDate: fromDate,
          toDate: toDate,
          serviceApprovalList: svrApprLst,
          quantity: quantity));
    } catch (e) {
      emit(const ServiceApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPagingToState(ServiceApprovalPaging event, emit) async {
    try {
      if (quantity == svrApprLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(ServiceApprovalPagingLoading());
        pageNumber++;
        final fromDate = event.fromDate;
        final toDate = event.toDate;

        final firstDay = FindDate.convertDateyyyyMMdd(today: event.fromDate);

        final lastDay = FindDate.convertDateyyyyMMdd(today: event.toDate);
        log(firstDay.toString());
        log(lastDay.toString());

        final content = ServiceApprovalRequest(
            type: event.application?.applicationCode,
            submitDateF: firstDay,
            submitDateT: lastDay,
            status: event.status?.codeId,
            userId: globalUser.employeeId ?? 0,
            isPending: event.isPending == true ? 1 : 0,
            costCenter: event.costCenter?.codeId,
            code: event.code,
            pageNumber: pageNumber,
            rowNumber: MyConstants.pagingSize);
        ApiResult apiResult =
            await _serviceRequestRepo.postServicePending(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(ServiceApprovalFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiServiceApproval = apiResult.data;
        if (apiServiceApproval.success == false) {
          emit(ServiceApprovalFailure(
              message: apiServiceApproval.error.errorMessage));
          return;
        }
        if (!apiServiceApproval.success) {
          emit(ServiceApprovalFailure(
              message: apiServiceApproval.error.errorMessage));
          return;
        }

        if (apiServiceApproval.error.errorCode != null) {
          emit(ServiceApprovalFailure(
              message: apiServiceApproval.error.errorMessage));
          return;
        }

        ServiceApprovalResponse svrApprRes = apiServiceApproval.payload;
        List<ServiceApprovalResult> serviceApprovalList = [];

        serviceApprovalList = svrApprRes.result ?? [];
        if (serviceApprovalList.isNotEmpty && serviceApprovalList != []) {
          svrApprLst.addAll(serviceApprovalList);
          quantity = svrApprRes.totalRecord ?? 0;
        } else {
          endPage = true;
        }
        emit(GetServiceApprovalSuccess(
            fromDate: fromDate,
            serviceApprovalList: svrApprLst,
            toDate: toDate,
            quantity: quantity));
      }
    } catch (e) {
      emit(ServiceApprovalFailure(message: e.toString()));
    }
  }
}
