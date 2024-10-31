part of 'interview_approval_bloc.dart';

abstract class InterviewApprovalEvent extends Equatable {
  const InterviewApprovalEvent();

  @override
  List<Object> get props => [];
}

class InterviewApprovalLoaded extends InterviewApprovalEvent {
  final AppBloc appBloc;
  const InterviewApprovalLoaded({required this.appBloc});

  @override
  List<Object> get props => [appBloc];
}

class InterviewApprovalPaging extends InterviewApprovalEvent {}
