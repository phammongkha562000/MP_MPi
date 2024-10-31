// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:mpi_new/data/services/navigator/navigation_service.dart' as _i4;
import 'package:mpi_new/data/services/network/client.dart' as _i5;

import '../network/client.dart' as _i7;

import 'package:mpi_new/data/repository/login/login_repository.dart' as _i6;

import 'package:mpi_new/data/repository/home/home_repository.dart' as _i7;
import 'package:mpi_new/data/repository/timesheets/timesheets_repository.dart'
    as _i8;
import 'package:mpi_new/data/repository/clock_in_out/clock_in_out_repository.dart'
    as _i9;
import 'package:mpi_new/data/repository/history_in_out/history_repository.dart'
    as _i10;
import 'package:mpi_new/data/repository/employee/employee_repository.dart'
    as _i11;
import 'package:mpi_new/data/repository/booking_meeting/booking_meeting_repository.dart'
    as _i12;
import 'package:mpi_new/data/repository/service_request/service_request_repository.dart'
    as _i13;
import 'package:mpi_new/data/repository/leave/leave_repository.dart' as _i14;
import 'package:mpi_new/data/repository/it_service/it_service_repository.dart'
    as _i15;
import 'package:mpi_new/data/repository/common/common_repository.dart' as _i16;
import 'package:mpi_new/data/repository/interview/interview_repository.dart'
    as _i17;
import 'package:mpi_new/data/repository/inbox/inbox_repository.dart' as _i18;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i4.NavigationService>(() => _i4.NavigationService());
  gh.lazySingleton<_i5.AbstractDioHttpClient>(
      () => _i5.ApiClient(client: gh<_i3.Dio>()));
  gh.factory<_i6.LoginRepository>(
      () => _i6.LoginRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i7.HomeRepository>(
      () => _i7.HomeRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i8.TimesheetsRepository>(
      () => _i8.TimesheetsRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i9.ClockInOutRepository>(
      () => _i9.ClockInOutRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i10.HistoryInOutRepository>(() =>
      _i10.HistoryInOutRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i11.EmployeeRepository>(
      () => _i11.EmployeeRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i12.BookingMeetingRepository>(() =>
      _i12.BookingMeetingRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i13.ServiceRequestRepository>(() =>
      _i13.ServiceRequestRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i14.LeaveRepository>(
      () => _i14.LeaveRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i15.ITServiceRepository>(
      () => _i15.ITServiceRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i16.CommonRepository>(
      () => _i16.CommonRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i17.InterviewRepository>(
      () => _i17.InterviewRepository(client: gh<_i5.AbstractDioHttpClient>()));
  gh.factory<_i18.InboxRepository>(
      () => _i18.InboxRepository(client: gh<_i5.AbstractDioHttpClient>()));
  return getIt;
}

class _$RegisterModule extends _i7.RegisterModule {}
