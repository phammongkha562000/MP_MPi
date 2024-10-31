part of 'service_request_detail_bloc.dart';

abstract class ServiceRequestDetailState extends Equatable {
  const ServiceRequestDetailState();

  @override
  List<Object?> get props => [];
}

class ServiceRequestDetailInitial extends ServiceRequestDetailState {}

class ServiceRequestDetailLoading extends ServiceRequestDetailState {}

class ServiceRequestDetailSuccess extends ServiceRequestDetailState {
  final ServiceRequestDetailResponse detail;
  final List<FileResponse> fileList;
  const ServiceRequestDetailSuccess(
      {required this.detail, required this.fileList});
  @override
  List<Object> get props => [detail, fileList];
}

class ServiceRequestDetailFailure extends ServiceRequestDetailState {
  final String message;
  final int? errorCode;
  const ServiceRequestDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class ServiceApprovalSuccessful extends ServiceRequestDetailState {}
