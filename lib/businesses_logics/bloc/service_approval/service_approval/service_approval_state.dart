part of 'service_approval_bloc.dart';

abstract class ServiceApprovalState extends Equatable {
  const ServiceApprovalState();

  @override
  List<Object?> get props => [];
}

class ServiceApprovalInitial extends ServiceApprovalState {}

class ServiceApprovalLoading extends ServiceApprovalState {}

class ServiceApprovalPagingLoading extends ServiceApprovalState {}

class ServiceApprovalSuccess extends ServiceApprovalState {
  final List<ApplicationResponse>? applicationList;
  final List<StdCode>? stdCodeList;
  final List<StdCode>? stdCodeCostCenterList;
  final List<ServiceApprovalResult> serviceApprovalList;
  final DateTime fromDate;
  final DateTime toDate;
  final ApplicationResponse? application;
  final StdCode? stdStatus;
  final StdCode? stdCenterCost;
  final bool isPending;
  final int quantity;

  const ServiceApprovalSuccess(
      {this.applicationList,
      this.stdCodeList,
      this.stdCodeCostCenterList,
      required this.fromDate,
      required this.toDate,
      required this.serviceApprovalList,
      required this.isPending,
      this.application,
      this.stdStatus,
      this.stdCenterCost,
      required this.quantity});
  @override
  List<Object?> get props => [
        applicationList,
        stdCodeList,
        stdCodeCostCenterList,
        fromDate,
        toDate,
        serviceApprovalList,
        isPending,
        application,
        stdStatus,
        stdCenterCost,
        quantity
      ];

  ServiceApprovalSuccess copyWith(
      {List<ApplicationResponse>? applicationList,
      List<StdCode>? stdCodeList,
      List<StdCode>? stdCodeCostCenterList,
      DateTime? fromDate,
      DateTime? toDate,
      List<ServiceApprovalResult>? serviceApprovalList,
      ApplicationResponse? application,
      StdCode? stdStatus,
      StdCode? stdCenterCost,
      bool? isPending,
      int? quantity}) {
    return ServiceApprovalSuccess(
        applicationList: applicationList ?? this.applicationList,
        stdCodeList: stdCodeList ?? this.stdCodeList,
        stdCodeCostCenterList:
            stdCodeCostCenterList ?? this.stdCodeCostCenterList,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        serviceApprovalList: serviceApprovalList ?? this.serviceApprovalList,
        application: application ?? this.application,
        stdStatus: stdStatus ?? this.stdStatus,
        stdCenterCost: stdCenterCost ?? this.stdCenterCost,
        quantity: quantity ?? this.quantity,
        isPending: isPending ?? this.isPending);
  }
}

class ServiceApprovalFailure extends ServiceApprovalState {
  final String message;
  final int? errorCode;
  const ServiceApprovalFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class GetServiceApprovalSuccess extends ServiceApprovalState {
  final List<ServiceApprovalResult> serviceApprovalList;
  final DateTime fromDate;
  final DateTime toDate;
  final int quantity;

  const GetServiceApprovalSuccess(
      {required this.serviceApprovalList,
      required this.fromDate,
      required this.toDate,
      required this.quantity});
  @override
  List<Object?> get props => [serviceApprovalList, fromDate, toDate, quantity];
}
