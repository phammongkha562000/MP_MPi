import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/widgets/approve/container_panel_color.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';

import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class InterviewApprovalView extends StatefulWidget {
  const InterviewApprovalView({super.key});

  @override
  State<InterviewApprovalView> createState() => _InterviewApprovalViewState();
}

class _InterviewApprovalViewState extends State<InterviewApprovalView> {
  final _navigationService = getIt<NavigationService>();
  late InterviewApprovalBloc interviewApprovalBloc;
  late AppBloc appBloc;

  final ScrollController _scrollController = ScrollController();
  BehaviorSubject<List<InterviewApprovalResult>> interviewLst =
      BehaviorSubject();
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    interviewApprovalBloc = BlocProvider.of<InterviewApprovalBloc>(context)
      ..add(InterviewApprovalLoaded(appBloc: appBloc));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        interviewApprovalBloc.add(InterviewApprovalPaging());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: "approvalinterview",
      ),
      body: BlocListener<InterviewApprovalBloc, InterviewApprovalState>(
        listener: (context, state) {
          if (state is InterviewApprovalFailure) {
            if (state.errorCode != null) {
              switch (state.errorCode) {
                case MyError.errCodeNoInternet:
                  MyDialog.showError(
                    context: context,
                    messageError: state.message,
                    pressTryAgain: () {
                      Navigator.pop(context);
                    },
                    whenComplete: () {
                      BlocProvider.of<InterviewApprovalBloc>(context)
                          .add(InterviewApprovalLoaded(appBloc: appBloc));
                    },
                  );
                  break;
                default:
                  MyDialog.showError(
                    context: context,
                    messageError: state.message,
                    pressTryAgain: () {
                      Navigator.pop(context);
                    },
                    whenComplete: () {},
                  );
              }
            } else {
              MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {},
              );
            }
          }
          if (state is InterviewApprovalLoadSuccess) {
            interviewLst.add(state.listInterview);
            quantity = state.quantity;
          }
          if (state is InterviewApprovalPagingSuccess) {
            interviewLst.add(state.listInterview);
          }
        },
        child: BlocBuilder<InterviewApprovalBloc, InterviewApprovalState>(
            builder: (context, state) {
          if (state is InterviewApprovalLoading) {
            return const ItemLoading();
          }
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<InterviewApprovalBloc>(context)
                  .add(InterviewApprovalLoaded(appBloc: appBloc));
            },
            child: StreamBuilder(
              stream: interviewLst.stream,
              builder: (context, snapshot) {
                return (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty)
                    ? ListView(children: [
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.8,
                            child: const EmptyWidget())
                      ])
                    : Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${"approvalinterview".tr()}: $quantity",
                                style: const TextStyle(
                                  color: MyColor.textBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var item = snapshot.data![index];
                                  return InkWell(
                                    onTap: () {
                                      _navigationService.pushNamed(
                                          MyRoute.interviewApprovalDetailRoute,
                                          args: {
                                            KeyParams.interviewDetail: item
                                          });
                                    },
                                    child: CardCustom(
                                        child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 8.h, 8.w, 8.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ContainerPanelColor(
                                              text:
                                                  item.interviewTypeDesc ?? ''),

                                          /* DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: MyColor.textBlack,
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(16.r),
                                                  bottomRight:
                                                      Radius.circular(16.r),
                                                )),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.r),
                                              child: Text(
                                                item.interviewTypeDesc ?? "",
                                                style: const TextStyle(
                                                  color: MyColor.defaultColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ), */
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h, horizontal: 8.w),
                                            child: RowFlex5and5(
                                              spacer: true,
                                              left: Text(
                                                  "${'interviewname'.tr()}:"),
                                              right: Text(item.cvName ?? "",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h, horizontal: 8.w),
                                            child: RowFlex5and5(
                                              spacer: true,
                                              left: Text(
                                                  "${'interviewdate'.tr()}:"),
                                              right: Text(
                                                  FormatDateLocal
                                                      .format_dd_MM_yyyy_HH_mm(
                                                          item.interviewDate
                                                              .toString()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  );
                                },
                              ),
                            ),
                            state is InterviewApprovalPagingLoading
                                ? const PagingLoading()
                                : const SizedBox()
                          ],
                        ),
                      );
              },
            ),
          );
        }),
      ),
    );
  }
}
