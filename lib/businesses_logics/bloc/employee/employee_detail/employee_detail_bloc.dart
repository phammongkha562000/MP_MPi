import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../config/server_config.dart';

part 'employee_detail_event.dart';
part 'employee_detail_state.dart';

class EmployeeDetailBloc
    extends Bloc<EmployeeDetailEvent, EmployeeDetailState> {
  final _loginRepo = getIt<LoginRepository>();

  EmployeeDetailBloc() : super(EmployeeDetailInitial()) {
    on<EmployeeDetailViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      EmployeeDetailViewLoaded event, emit) async {
    emit(EmployeeDetailLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
      String serverUpload = serverInfo.serverUpload.toString();
      ApiResult apiResult = await _loginRepo.getUserProfile(
          baseUrl: sharedPref.serverSSO, id: event.idEmp);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(EmployeeDetailFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(EmployeeDetailFailure(message: apiResponse.error.errorMessage));
        return;
      }
      UserProfile userProfile = apiResponse.payload;

      emit(EmployeeDetailSuccess(
          userProfile: userProfile, serverUpload: serverUpload));
    } catch (e) {
      emit(const EmployeeDetailFailure(message: MyError.messError));
    }
  }
}
