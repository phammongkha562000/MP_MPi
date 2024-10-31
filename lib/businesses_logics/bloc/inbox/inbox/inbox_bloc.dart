import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/models/inbox/notification_delete_request.dart';
import 'package:mpi_new/data/models/inbox/notification_response.dart';
import 'package:mpi_new/data/models/inbox/notification_update_request.dart';
import 'package:mpi_new/data/repository/inbox/inbox_repository.dart';

import '../../../../data/data.dart';

part 'inbox_event.dart';
part 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  int numberOfPage = 1;
  bool endPage = false;
  static const int numberOfRow = 20;
  int quantity = 0;

  final _inboxRepo = getIt<InboxRepository>();
  InboxBloc() : super(InboxInitial()) {
    on<InboxViewLoaded>(_mapViewLoadedToState);
    on<InboxUpdateStatus>(_mapUpdateStatusToState);
    on<InboxChecked>(_mapCheckedToState);
    on<InboxUnCheckedMulti>(_mapUnCheckedMultiToState);
    on<InboxUpdateMultiple>(_mapUpdateMultipleToState);
    on<InboxUpdateAll>(_mapUpdateAllToState);
    //delete
    on<InboxDeleteAll>(_mapDeleteAllToState);
    on<InboxDelete>(_mapDeleteToState);
    on<InboxDeleteMultiple>(_mapDeleteMultipleToState);
    //paging
    on<InboxPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(InboxViewLoaded event, emit) async {
    endPage = false;
    numberOfPage = 1;
    quantity = 0;
    emit(InboxLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final apiResult = await _inboxRepo.getInbox(
          userId: globalUser.employeeId.toString(),
          sourceType: MyConstants.systemIDMB,
          messageType: MyConstants.inboxNotification,
          numberOfPage: numberOfPage.toString(),
          numberOfRow: numberOfRow.toString(),
          baseUrl: sharedPref.serverSSO ?? '',
          serverHub: sharedPref.serverHub ?? '');
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(InboxFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      NotificationResponse notiRes = apiResult.data;
      List<NotificationItem> notiList = notiRes.result ?? [];
      quantity = notiRes.totalRecord ?? 0;
      emit(InboxSuccess(notificationList: notiList, quantity: quantity));
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateStatusToState(InboxUpdateStatus event, emit) async {
    try {
      if (event.currentStatus == MyConstants.inboxRead) {
        emit(InboxUpdateSuccessfully(gateWayCode: event.gateWayCode));
        return;
      }
      final sharedPref = await SharedPreferencesService.instance;

      final content = NotificationUpdateRequest(
          username: globalUser.employeeId.toString(),
          finalStatusMessage: event.status,
          reqIds: event.reqIds);
      final apiResult = await _inboxRepo.updateInbox(
          content: content,
          baseUrl: sharedPref.serverSSO ?? '',
          serverHub: sharedPref.serverHub ?? '');
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(InboxFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      final countNotification = await _inboxRepo.getTotalNotifications(
          userId: globalUser.employeeId.toString(),
          sourceType: MyConstants.systemIDMB,
          baseUrl: sharedPref.serverSSO.toString(),
          serverHub: sharedPref.serverHub.toString());
      if (countNotification.isFailure) {
        Error error = countNotification.getErrorResponse();
        emit(InboxFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      globalApp.setCountNotification = int.parse(countNotification.data);
      event.totalNotification.value = int.parse(countNotification.data);
      emit(InboxUpdateSuccessfully(gateWayCode: event.gateWayCode));
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  void _mapCheckedToState(InboxChecked event, emit) {
    try {
      final currentState = state;
      if (currentState is InboxSuccess) {
        final newList = currentState.notificationList
            .map((e) => e.reqId == event.reqId
                ? e.copyWith(isSelected: event.isChecked)
                : e)
            .toList();
        emit(currentState.copyWith(notificationList: newList));
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateMultipleToState(
      InboxUpdateMultiple event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is InboxSuccess) {
        emit(InboxLoading());

        final listSelected = currentState.notificationList
            .where((element) => element.isSelected == true)
            .toList();
        final listNew = listSelected
            .where((element) => element.sendStatus == MyConstants.inboxNew)
            .toList();

        final content = NotificationUpdateRequest(
            username: globalUser.employeeId.toString(),
            finalStatusMessage: MyConstants.inboxRead,
            reqIds: listNew.map((e) => e.reqId).join(','));
        final apiResultUpdate = await _inboxRepo.updateInbox(
            content: content,
            baseUrl: sharedPref.serverSSO ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiResultUpdate.isFailure) {
          Error error = apiResultUpdate.getErrorResponse();
          emit(InboxFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        final countNotification = await _inboxRepo.getTotalNotifications(
            userId: globalUser.employeeId.toString(),
            sourceType: MyConstants.systemIDMB,
            baseUrl: sharedPref.serverSSO.toString(),
            serverHub: sharedPref.serverHub.toString());

        if (countNotification.isFailure) {
          Error error = countNotification.getErrorResponse();
          emit(InboxFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);
        event.totalNotification.value = int.parse(countNotification.data);

        emit(InboxUpdateMultipleSuccessfully());
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateAllToState(InboxUpdateAll event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is InboxSuccess) {
        emit(InboxLoading());
        final listNew = currentState.notificationList
            .where((element) => element.sendStatus == MyConstants.inboxNew)
            .toList();
        if (listNew != [] && listNew.isNotEmpty) {
          final content = NotificationUpdateRequest(
              username: globalUser.employeeId.toString(),
              finalStatusMessage: MyConstants.inboxRead,
              reqIds: listNew.map((e) => e.reqId).join(','));
          final apiResultUpdate = await _inboxRepo.updateInbox(
              content: content,
              baseUrl: sharedPref.serverSSO ?? '',
              serverHub: sharedPref.serverHub ?? '');
          if (apiResultUpdate.isFailure) {
            Error error = apiResultUpdate.getErrorResponse();
            emit(InboxFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }

          final countNotification = await _inboxRepo.getTotalNotifications(
              userId: globalUser.employeeId.toString(),
              sourceType: MyConstants.systemIDMB,
              baseUrl: sharedPref.serverSSO.toString(),
              serverHub: sharedPref.serverHub.toString());

          if (countNotification.isFailure) {
            Error error = countNotification.getErrorResponse();
            emit(InboxFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          globalApp.setCountNotification = int.parse(countNotification.data);
          event.totalNotification.value = int.parse(countNotification.data);
          emit(InboxUpdateMultipleSuccessfully());
        } else {
          emit(currentState);
        }
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  void _mapUnCheckedMultiToState(InboxUnCheckedMulti event, emit) {
    try {
      final currentState = state;
      if (currentState is InboxSuccess) {
        final newList = currentState.notificationList
            .map((e) => e.copyWith(isSelected: false))
            .toList();
        emit(currentState.copyWith(notificationList: newList));
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteAllToState(InboxDeleteAll event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is InboxSuccess) {
        final apiDelete = await _inboxRepo.deleteNotification(
            content: NotificationDeleteRequest(
                strReqIds: event.employeeId,
                strSoueceType: MyConstants.systemIDMB,
                notifyType: MyConstants.inboxNotification,
                isDelAll: true),
            baseUrl: sharedPref.serverSSO ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiDelete.isFailure) {
          emit(InboxFailure(message: apiDelete.getErrorMessage()));
          return;
        }

        final countNotification = await _inboxRepo.getTotalNotifications(
            userId: event.employeeId,
            sourceType: MyConstants.systemIDMB,
            baseUrl: sharedPref.serverSSO ?? '',
            serverHub: sharedPref.serverHub.toString());
        if (countNotification.isFailure) {
          emit(InboxFailure(message: countNotification.getErrorMessage()));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);
        emit(InboxUpdateMultipleSuccessfully());
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteToState(InboxDelete event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final apiDelete = await _inboxRepo.deleteNotification(
          content: NotificationDeleteRequest(
              strReqIds: event.reqId.toString(),
              strSoueceType: MyConstants.systemIDMB,
              notifyType: MyConstants.inboxNotification,
              isDelAll: false),
          baseUrl: sharedPref.serverAddress ?? '',
          serverHub: sharedPref.serverHub.toString());
      if (apiDelete.isFailure) {
        emit(InboxFailure(message: apiDelete.getErrorMessage()));
        return;
      }
      final countNotification = await _inboxRepo.getTotalNotifications(
          userId: event.employeeId,
          sourceType: MyConstants.systemIDMB,
          baseUrl: sharedPref.serverSSO ?? '',
          serverHub: sharedPref.serverHub.toString());
      if (countNotification.isFailure) {
        emit(InboxFailure(message: countNotification.getErrorMessage()));
        return;
      }
      globalApp.setCountNotification = int.parse(countNotification.data);
      emit(InboxUpdateMultipleSuccessfully());
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteMultipleToState(
      InboxDeleteMultiple event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is InboxSuccess) {
        final listSelected = currentState.notificationList
            .where((element) => element.isSelected == true)
            .toList();
        final listReq = listSelected.map((e) => e.reqId).join(',');

        final apiDelete = await _inboxRepo.deleteNotification(
            content: NotificationDeleteRequest(
                strReqIds: listReq,
                strSoueceType: MyConstants.systemIDMB,
                notifyType: MyConstants.inboxNotification,
                isDelAll: false),
            baseUrl: sharedPref.serverSSO ?? '',
            serverHub: sharedPref.serverHub ?? '');
        if (apiDelete.isFailure) {
          emit(InboxFailure(message: apiDelete.getErrorMessage()));
          return;
        }
        final countNotification = await _inboxRepo.getTotalNotifications(
            userId: event.employeeId,
            sourceType: MyConstants.systemIDMB,
            baseUrl: sharedPref.serverSSO ?? '',
            serverHub: sharedPref.serverHub.toString());
        if (countNotification.isFailure) {
          emit(InboxFailure(message: countNotification.getErrorMessage()));
          return;
        }
        globalApp.setCountNotification = int.parse(countNotification.data);
        emit(InboxUpdateMultipleSuccessfully());
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(InboxPaging event, emit) async {
    try {
      if (endPage == false) {
        numberOfPage++;
        final currentState = state;
        if (currentState is InboxSuccess) {
          if (quantity == currentState.notificationList.length) {
            endPage = true;
            return;
          }
          emit(InboxPagingLoading());
          final sharedPref = await SharedPreferencesService.instance;

          final apiResult = await _inboxRepo.getInbox(
              userId: event.userId,
              sourceType: MyConstants.systemIDMB,
              messageType: MyConstants.inboxNotification,
              numberOfPage: numberOfPage.toString(),
              numberOfRow: numberOfRow.toString(),
              baseUrl: sharedPref.serverAddress ?? '',
              serverHub: sharedPref.serverHub ?? '');
          if (apiResult.isFailure) {
            emit(InboxFailure(
              message: apiResult.getErrorMessage(),
            ));
            return;
          }

          NotificationResponse notificationRes = apiResult.data;
          if (notificationRes.result != [] &&
              notificationRes.result != null &&
              notificationRes.result!.isNotEmpty) {
            emit(currentState.copyWith(notificationList: [
              ...currentState.notificationList,
              ...notificationRes.result ?? [],
            ]));
          } else {
            endPage = true;
            emit(currentState);
          }
        }
      }
    } catch (e) {
      emit(InboxFailure(message: e.toString()));
    }
  }
}
