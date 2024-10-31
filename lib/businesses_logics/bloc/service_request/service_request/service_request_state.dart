part of 'service_request_bloc.dart';

abstract class ServiceRequestState extends Equatable {
  const ServiceRequestState();

  @override
  List<Object?> get props => [];
}

class ServiceRequestInitial extends ServiceRequestState {}

class ServiceRequestLoading extends ServiceRequestState {}

class ServiceRequestPagingLoading extends ServiceRequestState {}

class ServiceRequestSuccess extends ServiceRequestState {
  final List<ServiceRequestResult> serviceList;
  final int quantity;
  const ServiceRequestSuccess(
      {required this.serviceList, required this.quantity});
  @override
  List<Object?> get props => [serviceList, quantity];

  ServiceRequestSuccess copyWith(
      {List<ServiceRequestResult>? serviceList, int? quantity}) {
    return ServiceRequestSuccess(
      serviceList: serviceList ?? this.serviceList,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ServiceRequestFailure extends ServiceRequestState {
  final String message;
  final int? errorCode;
  const ServiceRequestFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
