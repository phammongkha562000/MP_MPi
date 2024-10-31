part of 'interview_approval_detail_bloc.dart';

abstract class InterviewApprovalDetailState extends Equatable {
  const InterviewApprovalDetailState();

  @override
  List<Object?> get props => [];
}

class InterviewApprovalDetailInitial extends InterviewApprovalDetailState {}

class InterviewApprovalDetailLoading extends InterviewApprovalDetailState {}

class InterviewApprovalDetailLoadSuccess extends InterviewApprovalDetailState {
  final InterviewApprovalResult interviewApprovalResponse;
  final RecruitInterviewFormResponse? recruitInterviewFormResponse;
  final List<DocumentInterview>? listDocument;

  const InterviewApprovalDetailLoadSuccess({
    required this.interviewApprovalResponse,
    this.recruitInterviewFormResponse,
    this.listDocument,
  });
  @override
  List<Object?> get props => [interviewApprovalResponse];

  InterviewApprovalDetailLoadSuccess copyWith({
    InterviewApprovalResult? interviewApprovalResponse,
    RecruitInterviewFormResponse? recruitInterviewFormResponse,
    List<DocumentInterview>? listDocument,
  }) {
    return InterviewApprovalDetailLoadSuccess(
      interviewApprovalResponse:
          interviewApprovalResponse ?? this.interviewApprovalResponse,
      recruitInterviewFormResponse:
          recruitInterviewFormResponse ?? this.recruitInterviewFormResponse,
      listDocument: listDocument ?? this.listDocument,
    );
  }
}

class InterviewApprovalDetailFailure extends InterviewApprovalDetailState {
  final String message;
  final int? errorCode;
  const InterviewApprovalDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class UpdateCommentSuccessfully extends InterviewApprovalDetailState {}

class InterviewApprovalDownloadSuccessfully
    extends InterviewApprovalDetailState {
  final String fileLocation;
  final String fileType;
  const InterviewApprovalDownloadSuccessfully({
    required this.fileLocation,
    required this.fileType,
  });
  @override
  List<Object?> get props => [fileLocation, fileType];
}
