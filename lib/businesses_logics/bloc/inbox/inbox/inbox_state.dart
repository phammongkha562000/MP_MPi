part of 'inbox_bloc.dart';

abstract class InboxState extends Equatable {
  const InboxState();

  @override
  List<Object?> get props => [];
}

class InboxInitial extends InboxState {}

class InboxLoading extends InboxState {}

class InboxPagingLoading extends InboxState {}

class InboxSuccess extends InboxState {
  final List<NotificationItem> notificationList;
  final int quantity;
  const InboxSuccess({
    required this.notificationList,
    required this.quantity,
  });
  @override
  List<Object?> get props => [notificationList, quantity];

  InboxSuccess copyWith(
      {List<NotificationItem>? notificationList, int? quantity}) {
    return InboxSuccess(
      notificationList: notificationList ?? this.notificationList,
      quantity: quantity ?? this.quantity,
    );
  }
}

class InboxPagingSuccess extends InboxState {
  final List<NotificationItem> notificationList;

  const InboxPagingSuccess({required this.notificationList});
  @override
  List<Object?> get props => [notificationList];
}

class InboxFailure extends InboxState {
  final String message;
  final int? errorCode;
  const InboxFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class InboxUpdateSuccessfully extends InboxState {
  final String gateWayCode;
  const InboxUpdateSuccessfully({
    required this.gateWayCode,
  });
  @override
  List<Object?> get props => [gateWayCode];
}

class InboxUpdateMultipleSuccessfully extends InboxState {}
