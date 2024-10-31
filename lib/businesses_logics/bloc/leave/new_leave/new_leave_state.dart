part of 'new_leave_bloc.dart';

abstract class NewLeaveState extends Equatable {
  const NewLeaveState();

  @override
  List<Object?> get props => [];
}

class NewLeaveInitial extends NewLeaveState {}

class NewLeaveLoading extends NewLeaveState {}

class NewLeaveLoadSuccess extends NewLeaveState {
  final List<StdCode>? listStdCodeHr;
  final List<WorkFlowResponse>? workFlow;

  final DateTime fromDate;
  final DateTime toDate;
  final StdCode? typeLeave;
  final SessionType sessionType;
  final CheckLeaveResponse? leaveResponse;
  final String? pathImg;
  final String phoneNumber;
  final List<SessionType> sessionTypes;
  final double calDate;
  const NewLeaveLoadSuccess(
      {this.listStdCodeHr,
      this.workFlow,
      required this.fromDate,
      required this.toDate,
      this.typeLeave,
      required this.sessionType,
      this.leaveResponse,
      this.pathImg,
      required this.phoneNumber,
      required this.calDate,
      required this.sessionTypes});
  @override
  List<Object?> get props => [
        listStdCodeHr,
        workFlow,
        fromDate,
        toDate,
        typeLeave,
        sessionType,
        leaveResponse,
        pathImg,
        phoneNumber,
        calDate,
        sessionTypes
      ];

  NewLeaveLoadSuccess copyWith({
    List<StdCode>? listStdCodeHr,
    List<WorkFlowResponse>? workFlow,
    DateTime? fromDate,
    DateTime? toDate,
    StdCode? typeLeave,
    SessionType? sessionType,
    CheckLeaveResponse? leaveResponse,
    String? pathImg,
    String? phoneNumber,
    List<SessionType>? sessionTypes,
    double? calDate,
  }) {
    return NewLeaveLoadSuccess(
      listStdCodeHr: listStdCodeHr ?? this.listStdCodeHr,
      workFlow: workFlow ?? this.workFlow,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      sessionType: sessionType ?? this.sessionType,
      typeLeave: typeLeave ?? this.typeLeave,
      leaveResponse: leaveResponse ?? this.leaveResponse,
      pathImg: pathImg ?? this.pathImg,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      sessionTypes: sessionTypes ?? this.sessionTypes,
      calDate: calDate ?? this.calDate,
    );
  }
}

class NewLeaveFailure extends NewLeaveState {
  final String message;
  final int? errorCode;
  const NewLeaveFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class NewLeaveSuccessfully extends NewLeaveState {}
