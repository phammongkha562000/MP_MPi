part of 'add_service_request_bloc.dart';

abstract class AddServiceRequestState extends Equatable {
  const AddServiceRequestState();

  @override
  List<Object?> get props => [];
}

class AddServiceRequestInitial extends AddServiceRequestState {}

class AddServiceRequestLoading extends AddServiceRequestState {}

class AddServiceRequestSuccess extends AddServiceRequestState {
  final List<ApplicationResponse> applicationList;
  final List<StdCode> priorityList;
  final List<DivisionResponse> divisionList;
  final List<WorkFlowResponse>? workflowList;
  final bool? saveSuccess;
  const AddServiceRequestSuccess(
      {required this.applicationList,
      required this.priorityList,
      required this.divisionList,
      this.workflowList,
      this.saveSuccess});
  @override
  List<Object?> get props =>
      [applicationList, priorityList, divisionList, workflowList, saveSuccess];

  AddServiceRequestSuccess copyWith(
      {List<ApplicationResponse>? applicationList,
      List<StdCode>? priorityList,
      List<DivisionResponse>? divisionList,
      List<WorkFlowResponse>? workflowList,
      bool? saveSuccess}) {
    return AddServiceRequestSuccess(
      applicationList: applicationList ?? this.applicationList,
      priorityList: priorityList ?? this.priorityList,
      divisionList: divisionList ?? this.divisionList,
      workflowList: workflowList ?? this.workflowList,
      saveSuccess: saveSuccess,
    );
  }
}

class AddServiceRequestFailure extends AddServiceRequestState {
  final String message;
  final int? errorCode;
  const AddServiceRequestFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
