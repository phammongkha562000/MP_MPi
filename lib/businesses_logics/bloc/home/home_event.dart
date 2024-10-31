part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeViewLoaded extends HomeEvent {
  final AppBloc appBloc;

  const HomeViewLoaded({
    required this.appBloc,
  });
  @override
  List<Object> get props => [appBloc];
}
