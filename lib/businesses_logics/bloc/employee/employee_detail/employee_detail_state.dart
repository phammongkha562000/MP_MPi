part of 'employee_detail_bloc.dart';

abstract class EmployeeDetailState extends Equatable {
  const EmployeeDetailState();

  @override
  List<Object?> get props => [];
}

class EmployeeDetailInitial extends EmployeeDetailState {}

class EmployeeDetailLoading extends EmployeeDetailState {}

class EmployeeDetailSuccess extends EmployeeDetailState {
  final UserProfile userProfile;
  final String serverUpload;
  const EmployeeDetailSuccess(
      {required this.userProfile, required this.serverUpload});
  @override
  List<Object> get props => [userProfile, serverUpload];
}

class EmployeeDetailFailure extends EmployeeDetailState {
  final String message;
  final int? errorCode;
  const EmployeeDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
