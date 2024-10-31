import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mpi_new/businesses_logics/api/endpoints.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../application_bloc/app_bloc.dart';

part 'add_service_request_event.dart';
part 'add_service_request_state.dart';

class AddServiceRequestBloc
    extends Bloc<AddServiceRequestEvent, AddServiceRequestState> {
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();
  final _commonRepo = getIt<CommonRepository>();

  AddServiceRequestBloc() : super(AddServiceRequestInitial()) {
    on<AddServiceRequestViewLoaded>(_mapViewLoadedToState);
    on<AddServiceRequestSave>(_mapSaveToState);
    on<AddServiceRequestWorkFlow>(_mapWorkFlowToState);
  }
  Future<void> _mapViewLoadedToState(
      AddServiceRequestViewLoaded event, emit) async {
    emit(AddServiceRequestLoading());
    try {
      List<ApplicationResponse> applicationList = [];
      final getApplication = await event.appBloc.getApplication();
      if (getApplication is ApiResult) {
        if (getApplication.isFailure) {
          Error? error = getApplication.getErrorResponse();
          emit(AddServiceRequestFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
      }
      applicationList = getApplication;

      List<StdCode> listPriority = event.appBloc.listPriority;
      if (listPriority.isEmpty) {
        final getPriority = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typePRIORITY,
        );
        if (getPriority is ApiResult) {
          if (getPriority.isFailure) {
            Error? error = getPriority.getErrorResponse();
            emit(AddServiceRequestFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listPriority = getPriority;
        listPriority = getPriority;
      }

      ApiResult apiResult = await _serviceRequestRepo.getDivisions();
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(AddServiceRequestFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiDivision = apiResult.data;
      if (apiDivision.success == false) {
        emit(AddServiceRequestFailure(message: apiDivision.error.errorMessage));
        return;
      }
      emit(AddServiceRequestSuccess(
        applicationList: applicationList,
        priorityList: listPriority,
        divisionList: apiDivision.payload,
      ));
    } catch (e) {
      emit(const AddServiceRequestFailure(message: MyError.messError));
    }
  }

  Future<void> _mapWorkFlowToState(
      AddServiceRequestWorkFlow event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddServiceRequestSuccess) {
        emit(currentState.copyWith(saveSuccess: null));
        final sharedPref = await SharedPreferencesService.instance;

        final content = WorkFlowRequest(
            applicationCode: event.applicationCode,
            deptCode: event.appBloc.subsidiaryInfo?.deptCode ?? '',
            divisionCode: event.appBloc.subsidiaryInfo?.divisionCode ?? '',
            empId: globalUser.employeeId.toString(),
            localAmount: int.parse(event.localAmount),
            subsidiryId: sharedPref.subsidiaryId ?? '');
        ApiResult apiResult = await _commonRepo.getWorkFlow(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(AddServiceRequestFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(AddServiceRequestFailure(
              message: apiResponse.error.errorMessage));
          return;
        }
        emit(currentState.copyWith(workflowList: apiResponse.payload));
      }
    } catch (e) {
      emit(const AddServiceRequestFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSaveToState(AddServiceRequestSave event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddServiceRequestSuccess) {
        emit(AddServiceRequestLoading());
        final sharedPref = await SharedPreferencesService.instance;

        final content = AddServiceRequestRequest(
            hasBudget: event.hasBudget,
            svrSubject: event.svrSubject,
            svrServiceType: event.svrServiceType,
            requiredDetail: event.requiredDetail,
            proiority: event.proiority,
            svrStatus: event.svrStatus,
            dueDate: event.dueDate,
            subsidiaryId: sharedPref.subsidiaryId!,
            createUser: globalUser.employeeId!,
            divisionCode: event.appBloc.subsidiaryInfo?.divisionCode ?? '',
            localDocAmount: event.localDocAmount,
            usdDocAmount: event.usdDocAmount,
            remark: event.remark,
            thirdParty: event.thirdParty,
            refDocumentNo: event.refDocumentNo,
            relatedDivision: event.relatedDivision);

        ApiResult apiResult =
            await _serviceRequestRepo.postCreateServiceRequests(content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(AddServiceRequestFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiSave = apiResult.data;
        if (apiSave.success == false) {
          emit(AddServiceRequestFailure(message: apiSave.error.errorMessage));
          return;
        }
        if (apiSave.payload != '' && apiSave.payload != null) {
          List<File> files = [];
          for (var item in event.attachmentList) {
            File file = File(item.path);
            files.add(file);
          }
          BaseOptions options = BaseOptions(
            headers: {
              'Authorization': 'Bearer ${globalServer.getToken}',
            },
            contentType: Headers.formUrlEncodedContentType,
          );
          for (var element in files) {
            final fileName = element.path.split('/').last;
            List<int> bytes = await element.readAsBytes();
            final dio = Dio(options);
            final formData = FormData.fromMap({
              'docRefType': 'SVR',
              'refNoType': 'SVR',
              'refNoValue': apiSave.payload,
              'createUser': globalUser.employeeId ?? 0,
              'userId': globalUser.employeeId ?? 0,
              'files': MultipartFile.fromBytes(
                bytes,
                filename: fileName,
                contentType: MediaType('image', 'jpg'),
              ),
            });
            final response = await dio.post(
                "${sharedPref.serverSSO}${Endpoint.postDocumentService}",
                data: formData);
            if (response.statusCode != 200) {
              emit(AddServiceRequestFailure(
                  message: response.statusMessage ?? ''));
              return;
            }
          }
          emit(currentState.copyWith(saveSuccess: true));
        } else {
          emit(AddServiceRequestFailure(message: apiSave.error.errorMessage));
        }
      }
    } catch (e) {
      emit(const AddServiceRequestFailure(message: MyError.messError));
    }
  }
}
