part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final String url;

  const ForgotPasswordSuccess({required this.url});
  @override
  List<Object> get props => [url];
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  final int? errorCode;
  const ForgotPasswordFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
