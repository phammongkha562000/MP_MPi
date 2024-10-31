part of 'it_service_new_request_bloc.dart';

abstract class ITServiceNewRequestState extends Equatable {
  const ITServiceNewRequestState();

  @override
  List<Object?> get props => [];
}

class ITServiceNewRequestInitial extends ITServiceNewRequestState {}

class ITServiceNewRequestLoading extends ITServiceNewRequestState {}

class ITServiceNewRequestLoadSuccess extends ITServiceNewRequestState {
  final List<StdCode>? listItService;
  final List<StdCode>? listPriority;
  final List<StdCode>? listSVC;

  final String? itService;
  final String? priority;
  final String? svc;

  const ITServiceNewRequestLoadSuccess({
    this.listItService,
    this.listPriority,
    this.listSVC,
    this.itService,
    this.priority,
    this.svc,
  });

  ITServiceNewRequestLoadSuccess copyWith(
      {List<StdCode>? listItService,
      List<StdCode>? listPriority,
      List<StdCode>? listSVC,
      String? itService,
      String? priority,
      String? svc}) {
    return ITServiceNewRequestLoadSuccess(
        listItService: listItService ?? this.listItService,
        listPriority: listPriority ?? this.listPriority,
        listSVC: listSVC ?? this.listSVC,
        itService: itService ?? this.itService,
        priority: priority ?? this.priority,
        svc: svc ?? this.svc);
  }

  @override
  List<Object?> get props =>
      [listItService, listPriority, listSVC, itService, priority, svc];
}

class ITServiceNewRequestFailure extends ITServiceNewRequestState {
  final String message;
  final int? errorCode;
  const ITServiceNewRequestFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class CreateNewITServiceRequestSuccessfully extends ITServiceNewRequestState {}
