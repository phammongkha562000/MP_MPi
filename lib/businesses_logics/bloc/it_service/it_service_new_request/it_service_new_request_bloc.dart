import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mpi_new/businesses_logics/api/endpoints.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../../data/data.dart';
import '../../../application_bloc/app_bloc.dart';

part 'it_service_new_request_event.dart';
part 'it_service_new_request_state.dart';

class ITServiceNewRequestBloc
    extends Bloc<ITServiceNewRequestEvent, ITServiceNewRequestState> {
  final _itRepo = getIt<ITServiceRepository>();

  ITServiceNewRequestBloc() : super(ITServiceNewRequestInitial()) {
    on<ITServiceNewRequestLoaded>(_mapViewToState);
    on<ChangeITService>(_mapChangeITService);
    on<ChangePriorityITService>(_mapChangePriority);
    on<ChangeServiceTypeITService>(_mapChangeSVC);
    on<ITServiceNewRequest>(_mapNewRequestToState);
  }

  Future<void> _mapViewToState(ITServiceNewRequestLoaded event, emit) async {
    try {
      emit(ITServiceNewRequestLoading());

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

      List<StdCode> listPriority = event.appBloc.listPriority;
      if (listPriority.isEmpty) {
        final getSrStatus = await event.appBloc
            .getStdCodeWithType(type: TypeStdCode.typePRIORITY);
        if (getSrStatus is ApiResult) {
          if (getSrStatus.isFailure) {
            Error? error = getSrStatus.getErrorResponse();
            emit(ITServiceNewRequestFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listPriority = getSrStatus;
        listPriority = getSrStatus;
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

      emit(ITServiceNewRequestLoadSuccess(
          listItService: listItService,
          listPriority: listPriority,
          listSVC: listSVC));
    } catch (e) {
      emit(ITServiceNewRequestFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeITService(ChangeITService event, emit) async {
    try {
      final currentState = state;
      if (currentState is ITServiceNewRequestLoadSuccess) {
        emit(currentState.copyWith(itService: event.itServiceId));
      }
    } catch (e) {
      emit(ITServiceNewRequestFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangePriority(ChangePriorityITService event, emit) async {
    try {
      final currentState = state;
      if (currentState is ITServiceNewRequestLoadSuccess) {
        emit(currentState.copyWith(priority: event.priority));
      }
    } catch (e) {
      emit(ITServiceNewRequestFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeSVC(ChangeServiceTypeITService event, emit) async {
    try {
      final currentState = state;
      if (currentState is ITServiceNewRequestLoadSuccess) {
        emit(currentState.copyWith(svc: event.serviceType));
      }
    } catch (e) {
      emit(ITServiceNewRequestFailure(message: e.toString()));
    }
  }

  Future<void> _mapNewRequestToState(ITServiceNewRequest event, emit) async {
    try {
      emit(ITServiceNewRequestLoading());

      final sharedPref = await SharedPreferencesService.instance;
      final content = CreateNewITServiceRequest(
        subject: event.subject,
        details: "<p>${event.description}</p>",
        svcType: event.svcType,
        iTService: event.itService,
        priority: event.priority,
        createUser: globalUser.employeeId.toString(),
        subsidiaryId: sharedPref.subsidiaryId.toString(),
      );

      ApiResult apiResult = await _itRepo.createNewITService(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(ITServiceNewRequestFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse createNew = apiResult.data;
      if (!createNew.success) {
        emit(ITServiceNewRequestFailure(message: createNew.error.errorMessage));
        return;
      }
      if (createNew.payload != '' && createNew.payload != null) {
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
            'docRefType': 'ISR',
            'refNoType': 'ISR',
            'refNoValue': createNew.payload,
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
            emit(ITServiceNewRequestFailure(
                message: response.statusMessage ?? ''));
            return;
          }
        }
      }

      emit(CreateNewITServiceRequestSuccessfully());
    } catch (e) {
      emit(ITServiceNewRequestFailure(message: e.toString()));
    }
  }
}
