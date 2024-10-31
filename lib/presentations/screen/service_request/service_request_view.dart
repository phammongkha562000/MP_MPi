import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/navigator/import_generate.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';

import 'package:mpi_new/presentations/widgets/date_previous_next/date_previous_next.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';

class ServiceRequestView extends StatefulWidget {
  const ServiceRequestView({super.key});

  @override
  State<ServiceRequestView> createState() => _ServiceRequestViewState();
}

class _ServiceRequestViewState extends State<ServiceRequestView> {
  late ServiceRequestBloc _bloc;
  final _navigationService = getIt<NavigationService>();
  final ScrollController _scrollController = ScrollController();

  BehaviorSubject<List<ServiceRequestResult>> svrLst = BehaviorSubject();
  int quantity = 0;
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();
  @override
  void initState() {
    _bloc = BlocProvider.of<ServiceRequestBloc>(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(ServiceRequestPaging(
            fromDate: fromDate, toDate: toDate)); //hardcode
      }
    });
    super.initState();
  }

  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;
  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return Scaffold(
        appBar: AppBarCustom(context, title: 'servicerequest'),
        body: BlocConsumer<ServiceRequestBloc, ServiceRequestState>(
          listener: (context, state) {
            if (state is ServiceRequestFailure) {
              MyDialog.showError(
                  text: 'close'.tr(),
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    _bloc.add(ServiceRequestViewLoaded());
                  });
            }
            if (state is ServiceRequestSuccess) {
              svrLst.add(state.serviceList);
              quantity = state.quantity;
            }
          },
          builder: (context, state) {
            if (state is ServiceRequestLoading) {
              return const ItemLoading();
            }
            return StreamBuilder(
              stream: svrLst.stream,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DatePreviousNextView(
                      fromDate: fromDate,
                      toDate: toDate,
                      onTapPrevious: () {
                        fromDate = fromDate.subtract(const Duration(days: 1));
                        _bloc.add(ServiceRequestChangeDate(
                            fromDate: fromDate, toDate: toDate));
                      },
                      onPickFromDate: (selectedDate) {
                        fromDate = selectedDate;
                        _bloc.add(ServiceRequestChangeDate(
                            fromDate: selectedDate, toDate: toDate));
                      },
                      onPickToDate: (selectedDate) {
                        toDate = selectedDate;
                        _bloc.add(ServiceRequestChangeDate(
                            fromDate: fromDate, toDate: selectedDate));
                      },
                      onTapNext: () {
                        toDate = toDate.add(const Duration(days: 1));
                        _bloc.add(ServiceRequestChangeDate(
                            fromDate: fromDate, toDate: toDate));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 0, 8.h),
                      child: Text(
                        '$quantity ${'request'.tr()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async {
                        _bloc.add(ServiceRequestChangeDate(
                            fromDate: fromDate, toDate: toDate));
                      },
                      child: (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty)
                          ? ListView(children: [
                              SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  child: const EmptyWidget())
                            ])
                          : Scrollbar(
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.only(
                                    bottom: 48.h, left: 16.w, right: 16.w),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) =>
                                    _buildItem(item: snapshot.data![index]),
                              ),
                            ),
                    )),
                    state is ServiceRequestPagingLoading
                        ? const PagingLoading()
                        : const SizedBox()
                  ],
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await _navigationService
                  .navigateAndDisplaySelection(MyRoute.addServiceRequestRoute,
                      args: {KeyParams.employeeId: globalUser.employeeId});
              if (result != null) {
                _bloc.add(ServiceRequestViewLoaded());
              }
            },
            label: Row(
              children: [
                Text('addrequest'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const WidthSpacer(width: 0.02),
                const Icon(Icons.add)
              ],
            )));
  }

  Widget _buildItem({required ServiceRequestResult item}) {
    return Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: InkWell(
            onTap: () {
              _navigationService.pushNamed(MyRoute.serviceRequestDetailRoute,
                  args: {
                    KeyParams.svrNo: item.svrNo,
                    KeyParams.isApproveSVR: false
                  });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.w, top: 8.h),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ContainerPanelColor(text: item.svrNo ?? ''),
                      TextByTypeStatus(status: item.svrStatus.toString())
                    ],
                  ),
                  Padding(
                    padding: LayoutCustom.paddingItemCard,
                    child: Column(
                      children: [
                        _buildRowItem(
                            label: 'subject', content: item.svrSubject ?? ''),
                        _buildRowItem(
                            label: 'servicetype',
                            content: item.svrServiceTypeDesc ?? ''),
                        _buildRowItem3(
                            label: 'duedate',
                            content: convertDate(item.dueDate ?? 0),
                            item3: item.createDate ?? 0),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _buildRowItem({required String label, required String content}) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(
                '${label.tr()}:',
                style: TextStyle(
                  color: MyColor.getTextColor(),
                ),
              )),
          Expanded(
            flex: 2,
            child: Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColor.getTextColor(), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem3(
      {required String label, required String content, required int item3}) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            '${label.tr()}:',
            style: TextStyle(
              color: MyColor.getTextColor(),
            ),
          )),
          Expanded(
            child: Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColor.getTextColor(), fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(convertDate(item3),
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  )),
            ],
          )),
        ],
      ),
    );
  }

  String convertDate(int datetime) {
    var timeConvert = FormatDateLocal.format_dd_MM_yyyy(datetime.toString());
    return timeConvert;
  }

  Color getColorStatus(String status) {
    switch (status) {
      case 'CLOS':
        return Colors.red;
      case 'NEW':
        return MyColor.getTextColor();
      default:
        return Colors.orange;
    }
  }
}
