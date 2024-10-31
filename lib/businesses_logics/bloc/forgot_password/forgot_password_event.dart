part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordViewLoaded extends ForgotPasswordEvent {
  final String username;
  const ForgotPasswordViewLoaded({required this.username});
  @override
  List<Object> get props => [username];
}
