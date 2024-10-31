part of 'employee_detail_bloc.dart';

abstract class EmployeeDetailEvent extends Equatable {
  const EmployeeDetailEvent();

  @override
  List<Object> get props => [];
}

class EmployeeDetailViewLoaded extends EmployeeDetailEvent {
  final int idEmp;
  const EmployeeDetailViewLoaded({
    required this.idEmp,
  });
  @override
  List<Object> get props => [idEmp];
}
