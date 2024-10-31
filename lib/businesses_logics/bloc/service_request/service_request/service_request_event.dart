part of 'service_request_bloc.dart';

abstract class ServiceRequestEvent extends Equatable {
  const ServiceRequestEvent();

  @override
  List<Object?> get props => [];
}

class ServiceRequestViewLoaded extends ServiceRequestEvent {}

class ServiceRequestChangeDate extends ServiceRequestEvent {
  final DateTime fromDate;
  final DateTime toDate;
  const ServiceRequestChangeDate({
    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object?> get props => [fromDate, toDate];
}

class ServiceRequestPaging extends ServiceRequestEvent {
  final DateTime fromDate;
  final DateTime toDate;
  const ServiceRequestPaging({
    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object?> get props => [fromDate, toDate];
}
