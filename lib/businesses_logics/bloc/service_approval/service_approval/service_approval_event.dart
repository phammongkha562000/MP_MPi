part of 'service_approval_bloc.dart';

abstract class ServiceApprovalEvent extends Equatable {
  const ServiceApprovalEvent();

  @override
  List<Object?> get props => [];
}

class ServiceApprovalViewLoaded extends ServiceApprovalEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  final AppBloc appBloc;
  const ServiceApprovalViewLoaded(
      {this.fromDate, this.toDate, required this.appBloc});
  @override
  List<Object?> get props => [fromDate, toDate, appBloc];
}

class ServiceApprovalChangeDate extends ServiceApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final ApplicationResponse? application;
  final StdCode? costCenter;
  final StdCode? status;
  final String? code;
  final bool? isPending;
  const ServiceApprovalChangeDate({
    required this.fromDate,
    required this.toDate,
    this.application,
    this.costCenter,
    this.status,
    this.code,
    this.isPending,
  });
  @override
  List<Object?> get props =>
      [fromDate, toDate, application, costCenter, status, code, isPending];
}

class ServiceApprovalPaging extends ServiceApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final ApplicationResponse? application;
  final StdCode? costCenter;
  final StdCode? status;
  final String? code;
  final bool? isPending;
  const ServiceApprovalPaging({
    required this.fromDate,
    required this.toDate,
    this.application,
    this.costCenter,
    this.status,
    this.code,
    this.isPending,
  });
  @override
  List<Object?> get props =>
      [fromDate, toDate, application, costCenter, status, code, isPending];
}
