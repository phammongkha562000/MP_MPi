import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/data/models/inbox/notification_response.dart';
import 'package:mpi_new/presentations/widgets/dialog/dialog_platform.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/data.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key, required this.totalNotifications});
  final ValueNotifier<dynamic> totalNotifications;
  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  Map<String, String> mapNavigate = {
    'LEAVE': MyRoute.leaveApprovalRoute,
    'SERVICEREQUEST': MyRoute.serviceApprovalRoute,
    'ITSERVICEREQUEST': MyRoute.itServiceRoute
  };
  final _navigationService = getIt<NavigationService>();
  final ValueNotifier _isSelectNotifier = ValueNotifier(false);

  final ScrollController _scrollController = ScrollController();
  BehaviorSubject<List<NotificationItem>> notificationList = BehaviorSubject();
  int quantity = 0;
  late InboxBloc _bloc;
  late AppBloc appBloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<InboxBloc>(context);
    appBloc = BlocProvider.of<AppBloc>(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _bloc.add(InboxPaging(userId: appBloc.userInfo!.employeeId.toString()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom(
          context,
          title: 'notifications',
          onPressBack: () {
            Navigator.pop(context, 1);
          },
        ),
        body: BlocListener<InboxBloc, InboxState>(
            listener: (context, state) {
              if (state is InboxUpdateSuccessfully) {
                state.gateWayCode == 'SMTPGT0001'
                    ? null
                    : _navigationService
                        .popAndPushNamed(mapNavigate[state.gateWayCode] ?? '');
              }
              if (state is InboxSuccess) {
                notificationList.add(state.notificationList);
                quantity = state.quantity;
              }
              if (state is InboxPagingSuccess) {
                notificationList.add(state.notificationList);
              } else if (state is InboxUpdateMultipleSuccessfully) {
                _isSelectNotifier.value = false;
                _bloc.add(InboxViewLoaded());
              } else if (state is InboxFailure) {
                MyDialog.showError(
                    text: 'close'.tr(),
                    context: context,
                    messageError: state.message,
                    pressTryAgain: () {
                      Navigator.pop(context);
                    });
              }
            },
            child: StreamBuilder(
                stream: notificationList.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      final listSelected = snapshot.data!
                          .where((element) => element.isSelected == true)
                          .toList();
                      final isRead = (listSelected.isEmpty &&
                                  snapshot.data!
                                      .where((element) =>
                                          element.finalStatusMessage == 'NEW')
                                      .toList()
                                      .isNotEmpty ||
                              listSelected.isNotEmpty &&
                                  listSelected
                                      .where((element) =>
                                          element.isSelected == true &&
                                          element.finalStatusMessage == 'NEW')
                                      .toList()
                                      .isNotEmpty)
                          ? true
                          : false;
                      return Column(
                        children: [
                          _buildCountNoti(listSelected: listSelected),
                          _buildListNoti(
                              notificationList: notificationList.value),
                          BlocBuilder<InboxBloc, InboxState>(
                              builder: (context, state) {
                            if (state is InboxPagingLoading) {
                              return Platform.isAndroid
                                  ? const CircularProgressIndicator()
                                  : const CupertinoActivityIndicator();
                            }
                            return const SizedBox();
                          }),
                          _buildOptionsBottom(
                              listSelected: listSelected, isRead: isRead)
                        ],
                      );
                    }
                    return const EmptyWidget();
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  return const ItemLoading();
                })));
  }

  Widget _buildListNoti({required List<NotificationItem> notificationList}) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _isSelectNotifier,
        builder: (context, value, child) {
          return RefreshIndicator(
            onRefresh: () async {
              _bloc.add(InboxViewLoaded());
            },
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: notificationList.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                final item = notificationList[index];
                return InkWell(
                  onTap: _isSelectNotifier.value
                      ? () {
                          _bloc.add(InboxChecked(
                              reqId: item.reqId ?? 0,
                              isChecked: item.isSelected != null
                                  ? !item.isSelected!
                                  : true));
                        }
                      : () {
                          _bloc.add(InboxUpdateStatus(
                              currentStatus: item.sendStatus ?? '',
                              gateWayCode: item.gateWayCode ?? '',
                              status: MyConstants.inboxRead,
                              reqIds: item.reqId.toString(),
                              totalNotification: widget.totalNotifications));
                        },
                  child: ColoredBox(
                      color: item.finalStatusMessage == 'NEW'
                          ? MyColor.bgDrawerColor
                          : Colors.white,
                      child: Row(
                        children: [
                          _isSelectNotifier.value
                              ? Checkbox(
                                  value: item.isSelected ?? false,
                                  onChanged: (value) {
                                    _bloc.add(InboxChecked(
                                        reqId: item.reqId ?? 0,
                                        isChecked: value!));
                                  })
                              : const SizedBox(),
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              leading: DecoratedBox(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 3,
                                            offset: const Offset(0, 3)),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.amber,
                                        size: 36,
                                      ))),
                              title: item.gateWayCode == 'ITSERVICEREQUEST'
                                  ? Text('${item.requestTitle ?? ''} ',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: MyColor.textBlack))
                                  : RichText(
                                      text: TextSpan(children: [
                                      TextSpan(
                                          text: '${item.requestTitle ?? ''} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyColor.textBlack)),
                                      TextSpan(
                                          text: item.requestMessage,
                                          style: const TextStyle(
                                              color: MyColor.textBlack)),
                                    ])),
                              subtitle: Text(
                                FormatDateLocal.parseDateTimeToyyyyMMddHHmm(
                                    item.requestDate.toString()),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountNoti({required List<NotificationItem> listSelected}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$quantity ${'notifications'.tr()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isSelectNotifier,
          builder: (context, value, child) => TextButton(
            child: Text(
              _isSelectNotifier.value ? 'done'.tr() : 'select'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _isSelectNotifier.value = !_isSelectNotifier.value;
              listSelected.isNotEmpty ? {_bloc.add(InboxUnCheckedMulti())} : {};
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsBottom(
      {required List<NotificationItem> listSelected, required bool isRead}) {
    return ValueListenableBuilder(
      valueListenable: _isSelectNotifier,
      builder: (context, value, child) => _isSelectNotifier.value
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: listSelected.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              _bloc.add(InboxUpdateAll(
                                  totalNotification:
                                      widget.totalNotifications));
                            },
                            child: Text('readall'.tr(),
                                style: _buildTextStyleBTN(enable: isRead))),
                        TextButton(
                            onPressed: () {
                              PlatformDialog.showConfirmDialog(context,
                                  onOk: () {
                                _bloc.add(InboxDeleteAll(
                                    employeeId: appBloc.userInfo!.employeeId
                                        .toString()));
                              },
                                  text: 'confirmremoveallnoti',
                                  btnOkText: 'delete');
                            },
                            child: Text('removeall'.tr(),
                                style: _buildTextStyleBTN())),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: isRead
                                ? () {
                                    _bloc.add(InboxUpdateMultiple(
                                        totalNotification:
                                            widget.totalNotifications));
                                  }
                                : null,
                            child: Text(
                                '${'readinbox'.tr()} (${listSelected.where((element) => element.finalStatusMessage == 'NEW').length})',
                                style: _buildTextStyleBTN(enable: isRead))),
                        TextButton(
                            onPressed: () {
                              PlatformDialog.showConfirmDialog(context,
                                  onOk: () {
                                _bloc.add(InboxDeleteMultiple(
                                    employeeId: appBloc.userInfo!.employeeId
                                        .toString()));
                              },
                                  text: 'removenotification'
                                      .tr(args: ["${listSelected.length}"]),
                                  btnOkText: 'delete');
                            },
                            child: Text(
                                '${'delete'.tr()} (${listSelected.length})',
                                style: _buildTextStyleBTN())),
                      ],
                    ),
            )
          : const SizedBox(),
    );
  }


  TextStyle _buildTextStyleBTN({bool? enable}) {
    return TextStyle(color: enable ?? true ? Colors.black : Colors.grey);
  }
}
