part of 'interview_form_bloc.dart';

abstract class InterviewFormState extends Equatable {
  const InterviewFormState();

  @override
  List<Object?> get props => [];
}

class InterviewFormInitial extends InterviewFormState {}

class InterviewFormLoading extends InterviewFormState {}

class InterviewFormLoadSuccess extends InterviewFormState {
  final RecruitInterviewFormResponse form;
  final InterviewApprovalResult interviewApproval;

  const InterviewFormLoadSuccess({
    required this.form,
    required this.interviewApproval,
  });
  @override
  List<Object?> get props => [form, interviewApproval];
}

class InterviewFormLoadFailure extends InterviewFormState {
  final String message;
  final int? errorCode;
  const InterviewFormLoadFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
