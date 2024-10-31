part of 'change_password_bloc.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

final class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordLoadSuccess extends ChangePasswordState {
  final String oldPass;
  const ChangePasswordLoadSuccess({required this.oldPass});
  @override
  List<Object?> get props => [oldPass];
}

class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  final int? errorCode;

  const ChangePasswordFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class ChangePasswordSuccessful extends ChangePasswordState {
  final String severMode;
  final String newPass;
  const ChangePasswordSuccessful(
      {required this.severMode, required this.newPass});
  @override
  List<Object?> get props => [severMode, newPass];
}
