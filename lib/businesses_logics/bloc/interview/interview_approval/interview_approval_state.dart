part of 'interview_approval_bloc.dart';

abstract class InterviewApprovalState extends Equatable {
  const InterviewApprovalState();

  @override
  List<Object?> get props => [];
}

class InterviewApprovalInitial extends InterviewApprovalState {}

class InterviewApprovalLoading extends InterviewApprovalState {}

class InterviewApprovalLoadSuccess extends InterviewApprovalState {
  final List<InterviewApprovalResult> listInterview;
  final int quantity;
  const InterviewApprovalLoadSuccess(
      {required this.listInterview, required this.quantity});

  @override
  List<Object?> get props => [listInterview, quantity];
}

class InterviewApprovalFailure extends InterviewApprovalState {
  final String message;
  final int? errorCode;
  const InterviewApprovalFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class InterviewApprovalPagingLoading extends InterviewApprovalState {}

class InterviewApprovalPagingSuccess extends InterviewApprovalState {
  final List<InterviewApprovalResult> listInterview;

  const InterviewApprovalPagingSuccess({
    required this.listInterview,
  });

  @override
  List<Object?> get props => [listInterview];
}
