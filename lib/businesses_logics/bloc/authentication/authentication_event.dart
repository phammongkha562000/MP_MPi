part of 'authentication_bloc.dart';

class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AddInterceptor extends AuthenticationEvent {
  final AppBloc appBloc;
  const AddInterceptor({required this.appBloc});
  @override
  List<Object> get props => [];
}
