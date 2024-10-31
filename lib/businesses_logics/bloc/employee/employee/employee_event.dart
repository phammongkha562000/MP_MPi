part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeSearchViewLoaded extends EmployeeEvent {
  final String divisionCode;
  const EmployeeSearchViewLoaded({required this.divisionCode});
  @override
  List<Object?> get props => [divisionCode];
}

class EmployeeSearchSearchName extends EmployeeEvent {
  final String name;
  final String divisionCode;
  const EmployeeSearchSearchName(
      {required this.name, required this.divisionCode});

  @override
  List<Object?> get props => [name];
}

class EmployeeByDivisionPaging extends EmployeeEvent {
  final String divisionCode;
  final String name;
  const EmployeeByDivisionPaging(
      {required this.divisionCode, required this.name});
  @override
  List<Object?> get props => [divisionCode, name];
}

class EmployeeAllPaging extends EmployeeEvent {
  final String name;

  const EmployeeAllPaging({required this.name});
  @override
  List<Object?> get props => [name];
}
