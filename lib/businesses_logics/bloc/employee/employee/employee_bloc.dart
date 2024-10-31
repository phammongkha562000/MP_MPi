import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../config/server_config.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final _employeeRepo = getIt<EmployeeRepository>();
  int pageNumberDivision = 1;
  bool endPageDivision = false;
  List<EmployeeSearchResult> empDivisionLst = [];
  int quantityDivision = 0;

  int pageNumberAll = 1;
  bool endPageAll = false;
  List<EmployeeSearchResult> empAllLst = [];
  int quantityAll = 0;

  EmployeeBloc() : super(EmployeeInitial()) {
    on<EmployeeSearchViewLoaded>(_mapViewLoadedToState);
    on<EmployeeSearchSearchName>(_mapSearchToState);
    on<EmployeeByDivisionPaging>(_mapPagingDivisionToState);
    on<EmployeeAllPaging>(_mapPagingAllToState);
  }
  Future<void> _mapViewLoadedToState(
      EmployeeSearchViewLoaded event, emit) async {
    emit(EmployeeLoading());
    try {
      endPageDivision = false;
      pageNumberDivision = 1;
      empDivisionLst.clear();
      endPageAll = false;
      pageNumberAll = 1;
      empAllLst.clear();

      final results = await Future.wait([
        _getEmployee(
            division: event.divisionCode,
            name: '',
            pageNumber: pageNumberDivision),
        _getEmployee(division: '', name: '', pageNumber: pageNumberAll)
      ]);
      ApiResult apiResult = results[0];
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(EmployeeFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse employeeListDepartment = apiResult.data;
      if (employeeListDepartment.success == false) {
        emit(EmployeeFailure(
            message: employeeListDepartment.error.errorMessage));
        return;
      }
      EmployeeSearchResponse empRes = employeeListDepartment.payload;

      ApiResult apiResultAll = results[1];
      if (apiResultAll.isFailure) {
        emit(EmployeeFailure(message: apiResultAll.getErrorMessage()));
        return;
      }
      ApiResponse employeeListAll = apiResultAll.data;
      if (employeeListAll.success == false) {
        emit(EmployeeFailure(message: employeeListAll.error.errorMessage));
        return;
      }
      EmployeeSearchResponse empAllRes = employeeListAll.payload;

      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
      String serverUpload = serverInfo.serverUpload.toString();
      empDivisionLst.addAll(empRes.result ?? []);
      empAllLst.addAll(empAllRes.result ?? []);
      quantityDivision = empRes.totalRecord ?? 0;
      quantityAll = empAllRes.totalRecord ?? 0;
      emit(
        EmployeeSuccess(
            employeeList: empRes.result ?? [],
            employeeListAll: empAllRes.result ?? [],
            serverUpload: serverUpload,
            divisionQty: quantityDivision,
            allQty: quantityAll),
      );
    } catch (e) {
      emit(const EmployeeFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSearchToState(EmployeeSearchSearchName event, emit) async {
    try {
      endPageDivision = false;
      pageNumberDivision = 1;
      empDivisionLst.clear();
      endPageAll = false;
      pageNumberAll = 1;
      empAllLst.clear();

      quantityDivision = 0;
      quantityAll = 0;
      final results = await Future.wait([
        _getEmployee(
            division: event.divisionCode,
            name: event.name,
            pageNumber: pageNumberDivision),
        _getEmployee(division: '', name: event.name, pageNumber: pageNumberAll)
      ]);
      ApiResult apiResult = results[0];
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(EmployeeFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse employeeListDepartment = apiResult.data;
      if (employeeListDepartment.success == false) {
        emit(EmployeeFailure(
            message: employeeListDepartment.error.errorMessage));
        return;
      }
      EmployeeSearchResponse empRes = employeeListDepartment.payload;

      ApiResult apiResultAll = results[1];
      if (apiResultAll.isFailure) {
        emit(EmployeeFailure(message: apiResultAll.getErrorMessage()));
        return;
      }
      ApiResponse employeeListAll = apiResultAll.data;
      if (employeeListAll.success == false) {
        emit(EmployeeFailure(message: employeeListAll.error.errorMessage));
        return;
      }
      EmployeeSearchResponse empAllRes = employeeListAll.payload;

      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
      String serverUpload = serverInfo.serverUpload.toString();
      empDivisionLst.addAll(empRes.result ?? []);
      empAllLst.addAll(empAllRes.result ?? []);
      quantityDivision = empRes.totalRecord ?? 0;
      quantityAll = empAllRes.totalRecord ?? 0;
      emit(
        EmployeeSuccess(
            employeeList: empRes.result ?? [],
            employeeListAll: empAllRes.result ?? [],
            serverUpload: serverUpload,
            divisionQty: quantityDivision,
            allQty: quantityAll),
      );
    } catch (e) {
      emit(const EmployeeFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPagingDivisionToState(
      EmployeeByDivisionPaging event, emit) async {
    try {
      if (quantityDivision == empDivisionLst.length) {
        endPageDivision = true;
        return;
      }
      if (endPageDivision == false) {
        emit(EmployeePagingDivisionLoading());
        pageNumberDivision++;
        final apiEmp = await _getEmployee(
            division: event.divisionCode,
            name: event.name,
            pageNumber: pageNumberDivision);
        if (apiEmp.isFailure) {
          Error error = apiEmp.getErrorResponse();
          emit(EmployeeFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse empResponse = apiEmp.data;
        if (empResponse.success == false) {
          emit(EmployeeFailure(message: empResponse.error.errorMessage));
          return;
        }
        EmployeeSearchResponse empRes = empResponse.payload;
        List<EmployeeSearchResult> empLst = empRes.result ?? [];

        if (empLst.isNotEmpty && empLst != []) {
          empDivisionLst.addAll(empLst);
        } else {
          endPageDivision = true;
        }
        emit(EmployeeByDivisionSuccess(empDivisionLst: empDivisionLst));
      }
    } catch (e) {
      emit(const EmployeeFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPagingAllToState(EmployeeAllPaging event, emit) async {
    try {
      if (quantityAll == empAllLst.length) {
        endPageAll = true;
        return;
      }
      if (endPageAll == false) {
        emit(EmployeePagingAllLoading());
        pageNumberAll++;
        final apiEmp = await _getEmployee(
            division: "", name: event.name, pageNumber: pageNumberAll);
        if (apiEmp.isFailure) {
          Error error = apiEmp.getErrorResponse();
          emit(EmployeeFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse empResponse = apiEmp.data;
        if (empResponse.success == false) {
          emit(EmployeeFailure(message: empResponse.error.errorMessage));
          return;
        }
        EmployeeSearchResponse empRes = empResponse.payload;
        List<EmployeeSearchResult> empLst = empRes.result ?? [];

        if (empLst.isNotEmpty && empLst != []) {
          empAllLst.addAll(empLst);
        } else {
          endPageAll = true;
        }
        emit(EmployeeAllSuccess(empAllLst: empAllLst));
      }
    } catch (e) {
      emit(const EmployeeFailure(message: MyError.messError));
    }
  }

  Future<ApiResult> _getEmployee(
      {required String division,
      required String name,
      required int pageNumber}) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      final contentAll = EmployeeSearchRequest(
          employeeName: name,
          mobile: '',
          subsidary: sharedPref.subsidiaryId ?? '',
          division: division,
          department: '',
          employeecode: '',
          designation: '',
          isLeftEmployee: '',
          emplStatus: 'WORK',
          pageNumber: pageNumber,
          rowNumber: MyConstants.pagingSize);
      final apiResponse = await _employeeRepo.getEmployee(content: contentAll);
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }
}
