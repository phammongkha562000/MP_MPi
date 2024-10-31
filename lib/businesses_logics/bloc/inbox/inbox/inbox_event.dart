part of 'inbox_bloc.dart';

abstract class InboxEvent extends Equatable {
  const InboxEvent();

  @override
  List<Object> get props => [];
}

class InboxViewLoaded extends InboxEvent {}

class InboxUpdateStatus extends InboxEvent {
  final String reqIds;
  final String status;
  final String currentStatus;
  final String gateWayCode;
  final ValueNotifier<dynamic> totalNotification;

  const InboxUpdateStatus(
      {required this.reqIds,
      required this.status,
      required this.currentStatus,
      required this.gateWayCode,
      required this.totalNotification});
  @override
  List<Object> get props =>
      [reqIds, status, gateWayCode, totalNotification, currentStatus];
}

class InboxChecked extends InboxEvent {
  final int reqId;
  final bool isChecked;
  const InboxChecked({
    required this.reqId,
    required this.isChecked,
  });
  @override
  List<Object> get props => [reqId, isChecked];
}

class InboxUnCheckedMulti extends InboxEvent {}

class InboxUpdateMultiple extends InboxEvent {
  final ValueNotifier<dynamic> totalNotification;
  const InboxUpdateMultiple({required this.totalNotification});
  @override
  List<Object> get props => [totalNotification];
}

class InboxUpdateAll extends InboxEvent {
  final ValueNotifier<dynamic> totalNotification;
  const InboxUpdateAll({required this.totalNotification});
  @override
  List<Object> get props => [totalNotification];
}

class InboxDeleteAll extends InboxEvent {
  final String employeeId;

  const InboxDeleteAll({required this.employeeId});
  @override
  List<Object> get props => [employeeId];
}

class InboxDelete extends InboxEvent {
  final int reqId;
  final String employeeId;

  const InboxDelete({required this.reqId, required this.employeeId});
  @override
  List<Object> get props => [reqId, employeeId];
}

class InboxDeleteMultiple extends InboxEvent {
  final String employeeId;
  const InboxDeleteMultiple({
    required this.employeeId,
  });
  @override
  List<Object> get props => [employeeId];
}

class InboxPaging extends InboxEvent {
  final String userId;
  const InboxPaging({
    required this.userId,
  });
  @override
  List<Object> get props => [userId];
}
