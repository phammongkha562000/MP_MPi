import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/files/file_config.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../config/server_config.dart';

part 'interview_approval_detail_event.dart';
part 'interview_approval_detail_state.dart';

class InterviewApprovalDetailBloc
    extends Bloc<InterviewApprovalDetailEvent, InterviewApprovalDetailState> {
  final _interviewRepo = getIt<InterviewRepository>();

  InterviewApprovalDetailBloc() : super(InterviewApprovalDetailInitial()) {
    on<InterviewApprovalDetailLoaded>(_mapViewToState);
    on<InterviewApprovalUpdateComment>(_mapUpdateToState);
    on<InterviewApprovalViewFile>(_mapViewFileToState);
  }

  void _mapViewToState(InterviewApprovalDetailLoaded event, emit) async {
    try {
      emit(InterviewApprovalDetailLoading());

      var hecviveeId = event.interviewApprovalResponse.hecviveeId;

      ApiResult apiResultGetRecruit = await _interviewRepo
          .getSchedulersHecviveeId(hecviveeId: hecviveeId.toString());
      if (apiResultGetRecruit.isFailure) {
        Error? error = apiResultGetRecruit.getErrorResponse();
        emit(InterviewApprovalDetailFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse getRecruitInterview = apiResultGetRecruit.data;
      if (!getRecruitInterview.success) {
        emit(InterviewApprovalDetailFailure(
            message: getRecruitInterview.error.errorMessage));
        return;
      }

      var hecvId = event.interviewApprovalResponse.hecvId;
      ApiResult apiResultGetRecruitForm = await _interviewRepo
          .getRecruitInterviewForm(hecId: hecvId.toString());
      if (apiResultGetRecruitForm.isFailure) {
        Error? error = apiResultGetRecruitForm.getErrorResponse();
        emit(InterviewApprovalDetailFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse getRecruitInterviewForm = apiResultGetRecruitForm.data;
      if (getRecruitInterviewForm.success != true) {
        emit(InterviewApprovalDetailFailure(
            message: getRecruitInterviewForm.error.errorMessage));
        return;
      }

      ApiResult apiResult =
          await _interviewRepo.getDocumentInterview(hecvId: hecvId.toString());
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();

        emit(InterviewApprovalDetailFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse getDocumentsInterview = apiResult.data;
      if (!getDocumentsInterview.success) {
        emit(InterviewApprovalDetailFailure(
            message: getDocumentsInterview.error.errorMessage));
        return;
      }

      if (getRecruitInterview.success == true &&
          getRecruitInterviewForm.success == true) {
        emit(InterviewApprovalDetailLoadSuccess(
          interviewApprovalResponse: getRecruitInterview.payload,
          recruitInterviewFormResponse: getRecruitInterviewForm.payload,
          listDocument: getDocumentsInterview.payload,
        ));
      } else if (getRecruitInterview.success == true) {
        emit(InterviewApprovalDetailLoadSuccess(
          interviewApprovalResponse: getRecruitInterview.payload,
          listDocument: getDocumentsInterview.payload,
        ));
      } else {
        emit(const InterviewApprovalDetailFailure(message: "Load fail"));
      }
    } catch (e) {
      emit(InterviewApprovalDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateToState(
      InterviewApprovalUpdateComment event, emit) async {
    try {
      final currentState = state;
      if (currentState is InterviewApprovalDetailLoadSuccess) {
        emit(InterviewApprovalDetailLoading());
        final content = UpdateInterviewRequest(
          interviewRemark: event.comment,
          updateUser: globalUser.employeeId.toString(),
          hecviveeId: currentState.interviewApprovalResponse.hecviveeId ?? 0,
        );
        ApiResult apiResultUpdate =
            await _interviewRepo.updateInterviewComment(content: content);
        if (apiResultUpdate.isFailure) {
          Error error = apiResultUpdate.getErrorResponse();
          emit(InterviewApprovalDetailFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse updateComment = apiResultUpdate.data;
        if (updateComment.success == true && updateComment.payload == 1) {
          var hecviveeId = currentState.interviewApprovalResponse.hecviveeId;

          ApiResult apiResult = await _interviewRepo.getSchedulersHecviveeId(
              hecviveeId: hecviveeId.toString());
          if (apiResult.isFailure) {
            Error error = apiResult.getErrorResponse();

            emit(InterviewApprovalDetailFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          ApiResponse api = apiResult.data;
          if (!api.success) {
            emit(InterviewApprovalDetailFailure(
                message: api.error.errorMessage));
          }
          emit(UpdateCommentSuccessfully());
          emit(currentState.copyWith(
            interviewApprovalResponse: api.payload,
          ));
        } else {
          emit(const InterviewApprovalDetailFailure(message: "update_fail"));
        }
      }
    } catch (e) {
      emit(InterviewApprovalDetailFailure(message: e.toString()));
    }
  }

  Future<void> _mapViewFileToState(
      InterviewApprovalViewFile event, emit) async {
    try {
      //Check server
      final currentState = state;
      if (state is InterviewApprovalDetailLoadSuccess) {
        final sharedPref = await SharedPreferencesService.instance;

        ServerInfo serverInfo =
            await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
        String startUrl = serverInfo.serverUpload.toString();

        String defaultFolder = "D:\\LE\\INTRANET\\MPIS\\";

        final filePath = event.pathFile;
        final newLink = "$startUrl${filePath.split(defaultFolder).last}"
            .replaceAll("\\", "/");

        String fileName = newLink.split("/").last;

        try {
          final down =
              await isDownloadFile(pathNew: newLink, fileName: fileName);

          if (down == true) {
            var fileLocation = "";
            fileLocation = await getPathFile(fileName: fileName);
            emit(InterviewApprovalDownloadSuccessfully(
              fileLocation: fileLocation,
              fileType: checkFileType(newLink),
            ));
          } else {
            emit(
              const InterviewApprovalDetailFailure(
                message: "Download File Error",
                errorCode: 1007,
              ),
            );
          }
        } catch (e) {
          emit(
            const InterviewApprovalDetailFailure(
              message: "Download File Error",
              errorCode: 1007,
            ),
          );
        }
        emit(currentState);
      }
    } catch (e) {
      emit(InterviewApprovalDetailFailure(message: e.toString()));
    }
  }
}
