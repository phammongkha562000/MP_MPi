part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordLoaded extends ChangePasswordEvent {}

class ChangePasswordSubmit extends ChangePasswordEvent {
  final String newPass;
  final AppBloc appBloc;
  final String oladPass;
  const ChangePasswordSubmit(
      {required this.newPass, required this.appBloc, required this.oladPass});
  @override
  List<Object> get props => [newPass, oladPass];
}
