part of 'it_service_new_request_bloc.dart';

abstract class ITServiceNewRequestEvent extends Equatable {
  const ITServiceNewRequestEvent();

  @override
  List<Object> get props => [];
}

class ITServiceNewRequestLoaded extends ITServiceNewRequestEvent {
  final AppBloc appBloc;
  const ITServiceNewRequestLoaded({required this.appBloc});
  @override
  List<Object> get props => [appBloc];
}

class ITServiceNewRequest extends ITServiceNewRequestEvent {
  final String subject;
  final String description;
  final String svcType;
  final String itService;
  final String priority;
  final List<FileInfo> attachmentList;

  const ITServiceNewRequest(
      {required this.subject,
      required this.description,
      required this.svcType,
      required this.itService,
      required this.priority,
      required this.attachmentList});
  @override
  List<Object> get props =>
      [subject, description, svcType, itService, priority, attachmentList];
}

class ChangeITService extends ITServiceNewRequestEvent {
  final String itServiceId;
  const ChangeITService({
    required this.itServiceId,
  });
  @override
  List<Object> get props => [itServiceId];
}

class ChangeServiceTypeITService extends ITServiceNewRequestEvent {
  final String serviceType;
  const ChangeServiceTypeITService({
    required this.serviceType,
  });
  @override
  List<Object> get props => [serviceType];
}

class ChangePriorityITService extends ITServiceNewRequestEvent {
  final String priority;
  const ChangePriorityITService({
    required this.priority,
  });
  @override
  List<Object> get props => [priority];
}
