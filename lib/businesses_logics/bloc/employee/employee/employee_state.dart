part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeePagingDivisionLoading extends EmployeeState {}

class EmployeePagingAllLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final List<EmployeeSearchResult> employeeList;
  final List<EmployeeSearchResult> employeeListAll;
  final String serverUpload;
  final int divisionQty;
  final int allQty;
  const EmployeeSuccess(
      {required this.employeeList,
      required this.employeeListAll,
      required this.serverUpload,
      required this.divisionQty,
      required this.allQty});
  @override
  List<Object?> get props =>
      [employeeList, employeeListAll, serverUpload, divisionQty, allQty];

  EmployeeSuccess copyWith(
      {List<EmployeeSearchResult>? employeeList,
      List<EmployeeSearchResult>? employeeListAll,
      String? serverUpload,
      int? divisionQty,
      int? allQty}) {
    return EmployeeSuccess(
      employeeList: employeeList ?? this.employeeList,
      employeeListAll: employeeListAll ?? this.employeeListAll,
      serverUpload: serverUpload ?? this.serverUpload,
      divisionQty: divisionQty ?? this.divisionQty,
      allQty: allQty ?? this.allQty,
    );
  }
}

class EmployeeFailure extends EmployeeState {
  final String message;
  final int? errorCode;
  const EmployeeFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class EmployeeByDivisionSuccess extends EmployeeState {
  final List<EmployeeSearchResult> empDivisionLst;

  const EmployeeByDivisionSuccess({required this.empDivisionLst});
  @override
  List<Object?> get props => [empDivisionLst];
}

class EmployeeAllSuccess extends EmployeeState {
  final List<EmployeeSearchResult> empAllLst;

  const EmployeeAllSuccess({required this.empAllLst});
  @override
  List<Object?> get props => [empAllLst];
}
