part of 'interview_approval_detail_bloc.dart';

abstract class InterviewApprovalDetailEvent extends Equatable {
  const InterviewApprovalDetailEvent();

  @override
  List<Object> get props => [];
}

class InterviewApprovalDetailLoaded extends InterviewApprovalDetailEvent {
  final InterviewApprovalResult interviewApprovalResponse;
  const InterviewApprovalDetailLoaded({
    required this.interviewApprovalResponse,
  });
  @override
  List<Object> get props => [interviewApprovalResponse];
}

class InterviewApprovalUpdateComment extends InterviewApprovalDetailEvent {
  final String comment;
  const InterviewApprovalUpdateComment({
    required this.comment,
  });
  @override
  List<Object> get props => [comment];
}

class InterviewApprovalViewFile extends InterviewApprovalDetailEvent {
  final String pathFile;
  const InterviewApprovalViewFile({
    required this.pathFile,
  });
  @override
  List<Object> get props => [pathFile];
}
