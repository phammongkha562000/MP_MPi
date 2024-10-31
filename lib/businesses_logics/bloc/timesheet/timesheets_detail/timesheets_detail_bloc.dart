import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../application_bloc/app_bloc.dart';

part 'timesheets_detail_event.dart';
part 'timesheets_detail_state.dart';

class TimesheetsDetailBloc
    extends Bloc<TimesheetsDetailEvent, TimesheetsDetailState> {
  final _timesheetsRepo = getIt<TimesheetsRepository>();

  TimesheetsDetailBloc() : super(TimesheetsDetailInitial()) {
    on<TimesheetsDetailViewLoaded>(_mapViewLoadedToState);
    on<TimesheetsDetailUpdate>(_mapUpdateToState);
  }
  Future<void> _mapViewLoadedToState(
      TimesheetsDetailViewLoaded event, emit) async {
    emit(TimesheetsDetailLoading());
    try {
      List<StdCode> listTSPostType = event.appBloc.listTSPostType;
      if (listTSPostType.isEmpty) {
        final getTSPostType = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeTimesheets,
        );
        if (getTSPostType is ApiResult) {
          if (getTSPostType.isFailure) {
            Error error = getTSPostType.getErrorResponse();
            emit(TimesheetsDetailFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listTSPostType = getTSPostType;
        listTSPostType = getTSPostType;
      }

      emit(TimesheetsDetailSuccess(
          timesheetsItem: event.timesheetsItem,
          name: event.appBloc.userInfo?.employeeName ?? '',
          stdCodeList: listTSPostType,
          updateSuccess: false,
          employeeId: globalUser.employeeId ?? 0));
    } catch (e) {
      emit(const TimesheetsDetailFailure(message: MyError.messError));
    }
  }

  Future<void> _mapUpdateToState(TimesheetsDetailUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is TimesheetsDetailSuccess) {
        emit(currentState.copyWith(updateSuccess: false));
        emit(TimesheetsDetailLoading());

        final content = event.timesheets;
        ApiResult apiResult =
            await _timesheetsRepo.updateTimesheets(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(TimesheetsDetailFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiTimesheetDetail = apiResult.data;

        if (!apiTimesheetDetail.success ||
            apiTimesheetDetail.error.errorCode != null) {
          emit(TimesheetsDetailFailure(
              message: apiTimesheetDetail.error.errorMessage));
          return;
        }

        final firstDay =
            '${FormatDateConstants.convertUTCDateTimeShort2(currentState.timesheetsItem.startTime!)} 00:00:00';
        final lastDay =
            '${FormatDateConstants.convertUTCDateTimeShort2(currentState.timesheetsItem.endTime!)} 23:59:59';

        final contentTimesheet = TimesheetsRequest(
            status: '',
            userId: event.appBloc.userInfo?.loginName ?? '',
            employeeId: globalUser.employeeId ?? 0,
            submitDateF: firstDay,
            submitDateT: lastDay,
            isCheckTime: '0',
            skipRecord: 0,
            takeRecord: 10,
            pageNumber: 1,
            rowNumber: 1);
        ApiResult apiResultGetTS =
            await _timesheetsRepo.getTimesheets(content: contentTimesheet);

        if (apiResultGetTS.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(TimesheetsDetailFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiTimesheet = apiResultGetTS.data;
        TimesheetResponse tsRes = apiTimesheet.payload;
        List<TimesheetResult> tsLst = tsRes.result ?? [];

        emit(currentState.copyWith(
            updateSuccess: true, timesheetsItem: tsLst.first));
      }
    } catch (e) {
      emit(const TimesheetsDetailFailure(message: MyError.messError));
    }
  }
}
