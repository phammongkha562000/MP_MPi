import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key, required this.isAddLeave});
  final bool isAddLeave;
  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  final _navigationService = getIt<NavigationService>();
  DateTime date = DateTime.now();
  BehaviorSubject<List<LeaveResult>> leaveLst = BehaviorSubject();
  final ScrollController _scrollController = ScrollController();
  int quantity = 0;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        BlocProvider.of<LeaveBloc>(context)
            .add(LeavePaging(date: DateTime.now()));
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarCustom(context,
            title: "leave",
            onPressBack: widget.isAddLeave == true
                ? () {
                    _navigationService.pushNamed(MyRoute.homePageRoute);
                  }
                : null,
            actionRight: [
              IconButton(
                onPressed: () {
                  _navigationService.pushNamed(MyRoute.newLeave);
                },
                icon: const Icon(Icons.add),
              )
            ]),
        body: BlocConsumer<LeaveBloc, LeaveState>(
          listener: (context, state) {
            if (state is LeaveFailure) {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    BlocProvider.of<LeaveBloc>(context)
                        .add(LeaveLoaded(date: date));
                  });
            }
            if (state is LeaveLoadSuccess) {
              leaveLst.add(state.leavePayload ?? []);
              quantity = state.quantity;
            }
          },
          builder: (context, state) {
            if (state is LeaveLoading) {
              return const ItemLoading();
            }
            return StreamBuilder(
              stream: leaveLst.stream,
              builder: (context, snapshot) {
                return PickDatePreviousNextWidget(
                    isMonth: true,
                    onTapPrevious: () {
                      date = DateTime(date.year, date.month - 1, 1);
                      BlocProvider.of<LeaveBloc>(context)
                          .add(LeaveLoaded(date: date));
                    },
                    onTapNext: () {
                      date = DateTime(date.year, date.month + 1, 1);
                      BlocProvider.of<LeaveBloc>(context)
                          .add(LeaveLoaded(date: date));
                    },
                    onTapPick: (selectedDate) {
                      date = selectedDate;
                      BlocProvider.of<LeaveBloc>(context)
                          .add(LeaveLoaded(date: selectedDate));
                    },
                    stateDate: date,
                    quantityText: "${"quantity".tr()}: $quantity",
                    lstChild: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            BlocProvider.of<LeaveBloc>(context)
                                .add(LeaveLoaded(date: date));
                          },
                          child: (!snapshot.hasData ||
                                  snapshot.data == null ||
                                  snapshot.data!.isEmpty)
                              ? ListView(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.8,
                                      child: const EmptyWidget(),
                                    ),
                                  ],
                                )
                              : Scrollbar(
                                  controller: _scrollController,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.only(
                                        bottom: 48.h, left: 16.w, right: 16.w),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var item = snapshot.data![index];

                                      return _buildCard(item: item);
                                    },
                                  ),
                                ),
                        ),
                      ),
                      (state is LeavePagingLoading)
                          ? const PagingLoading()
                          : const SizedBox()
                    ]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({required LeaveResult item}) {
    return InkWell(
      onTap: () {
        _navigationService.pushNamed(MyRoute.leaveDetailRoute, args: {
          KeyParams.lvNoLeave: item.lvNo,
          KeyParams.isApproveLeave: false,
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w, top: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerPanelColor(text: item.lvNo ?? ''),
                  TextByTypeStatus(status: item.leaveStatus.toString())
                ],
              ),
            ),
            _buildDate(
              title: 'from',
              content:
                  FormatDateLocal.format_dd_MM_yyyy(item.fromDate.toString()),
            ),
            _buildDate(
              title: 'to',
              content:
                  FormatDateLocal.format_dd_MM_yyyy(item.toDate.toString()),
            ),
            _buildDate(
              title: 'leavedate',
              content: '${item.leaveDays} - ${item.marker}',
            ),
            _buildLeaveType(item)
          ],
        ),
      ),
    );
  }

  TextStyle styleItem() {
    return const TextStyle(
      color: MyColor.textBlack,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle styleContent() {
    return const TextStyle(
      color: MyColor.textBlack,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildDate({required String title, required String content}) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text(
            title.tr(),
            style: styleItem(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            content,
            style: styleContent(),
          ),
        ),
      ]),
    );
  }

  Padding _buildLeaveType(LeaveResult item) {
    return Padding(
      padding: LayoutCustom.paddingItemView,
      child: Row(children: [
        Expanded(
          child: Text(
            "leavetype".tr(),
            style: styleItem(),
          ),
        ),
        Expanded(
          child: Text(
            item.leaveTypeDesc.toString(),
            style: styleContent(),
          ),
        ),
        Expanded(
          child: Text(
            FormatDateLocal.format_dd_MM_yyyy(item.submitDate.toString()),
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: MyColor.textGrey,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3),
          ),
        ),
      ]),
    );
  }

  String getTextType(String type) {
    switch (type) {
      case "NEW":
        return "new".tr();
      case "INPR":
        return "inpr".tr();
      case "CLOS":
        return "close".tr();
      default:
        return "";
    }
  }

  Color getColor(String type) {
    switch (type) {
      case "NEW":
        return MyColor.btnGreen;
      case "INPR":
        return MyColor.defaultColor;
      case "CLOS":
        return MyColor.textRed;
      default:
        return MyColor.btnGreen;
    }
  }
}
