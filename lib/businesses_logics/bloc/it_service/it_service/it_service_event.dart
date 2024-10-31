
part of 'it_service_bloc.dart';

abstract class ITServiceEvent extends Equatable {
  const ITServiceEvent();

  @override
  List<Object?> get props => [];
}

class ITServiceLoaded extends ITServiceEvent {
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool? isSearch;
  final AppBloc appBloc;
  final String? irsNo;
  final String? createUser;
  final String? srStatus;
  final String? stdITServiceType;
  final String? subject;
  final String? svc;

  const ITServiceLoaded(
      {required this.dateFrom,
      required this.dateTo,
      this.isSearch,
      this.irsNo,
      this.createUser,
      this.srStatus,
      this.stdITServiceType,
      this.subject,
      this.svc,
      required this.appBloc});
  @override
  List<Object?> get props => [
        dateFrom,
        dateTo,
        isSearch,
        irsNo,
        createUser,
        srStatus,
        stdITServiceType,
        subject,
        svc,
        appBloc
      ];
}

class ITServiceChangeMonth extends ITServiceEvent {
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool? isSearch;
  final String? irsNo;
  final String? createUser;
  final String? srStatus;
  final String? stdITServiceType;
  final String? subject;
  final String? svc;

  const ITServiceChangeMonth({
    required this.dateFrom,
    required this.dateTo,
    this.isSearch,
    this.irsNo,
    this.createUser,
    this.srStatus,
    this.stdITServiceType,
    this.subject,
    this.svc,
  });
  @override
  List<Object?> get props => [
        dateFrom,
        dateTo,
        isSearch,
        irsNo,
        createUser,
        srStatus,
        stdITServiceType,
        subject,
        svc,
      ];
}

class ITServicePaging extends ITServiceEvent {
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool? isSearch;
  final String? irsNo;
  final String? createUser;
  final String? srStatus;
  final String? stdITServiceType;
  final String? subject;
  final String? svc;

  const ITServicePaging({
    required this.dateFrom,
    required this.dateTo,
    this.isSearch,
    this.irsNo,
    this.createUser,
    this.srStatus,
    this.stdITServiceType,
    this.subject,
    this.svc,
  });
  @override
  List<Object?> get props => [
        dateFrom,
        dateTo,
        isSearch,
        irsNo,
        createUser,
        srStatus,
        stdITServiceType,
        subject,
        svc,
      ];
}
