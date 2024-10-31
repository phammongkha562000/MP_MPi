part of 'service_request_detail_bloc.dart';

abstract class ServiceRequestDetailEvent extends Equatable {
  const ServiceRequestDetailEvent();

  @override
  List<Object?> get props => [];
}

class ServiceRequestDetailViewLoaded extends ServiceRequestDetailEvent {
  final String svrNo;
  const ServiceRequestDetailViewLoaded({
    required this.svrNo,
  });
  @override
  List<Object> get props => [svrNo];
}

class SaveServiceApproval extends ServiceRequestDetailEvent {
  final String approvalType;
  final String comment;

  final String hLvNo;
  const SaveServiceApproval({
    required this.comment,
    required this.approvalType,
    required this.hLvNo,
  });
  @override
  List<Object?> get props => [comment, approvalType, hLvNo];
}
