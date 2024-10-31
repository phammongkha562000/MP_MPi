part of 'interview_form_bloc.dart';

abstract class InterviewFormEvent extends Equatable {
  const InterviewFormEvent();

  @override
  List<Object> get props => [];
}

class InterviewFormLoaded extends InterviewFormEvent {
  final RecruitInterviewFormResponse form;
  final InterviewApprovalResult interviewApproval;
  const InterviewFormLoaded({
    required this.form,
    required this.interviewApproval,
  });
  @override
  List<Object> get props => [form, interviewApproval];
}
