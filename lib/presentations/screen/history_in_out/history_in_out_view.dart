import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/data.dart';

class HistoryInOutView extends StatefulWidget {
  const HistoryInOutView({super.key});

  @override
  State<HistoryInOutView> createState() => _HistoryInOutViewState();
}

late HistoryInOutBloc _bloc;

class _HistoryInOutViewState extends State<HistoryInOutView> {
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HistoryInOutBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom(context, title: "historyinout"),
        body: BlocConsumer<HistoryInOutBloc, HistoryInOutState>(
            listener: (context, state) {
          if (state is HistoryInOutFailure) {
            MyDialog.showError(
                text: 'close'.tr(),
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                  _bloc.add(HistoryInOutViewLoaded());
                });
          }
        }, builder: (context, state) {
          if (state is HistoryInOutSuccess) {
            return PickDatePreviousNextWidget(
                onTapNext: () {
                  _bloc.add(const HistoryInOutChangeDate(typeDate: 1));
                }, //1 là tiến
                onTapPick: (selectedDate) {
                  _bloc.add(HistoryInOutPickDate(date: selectedDate));
                },
                onTapPrevious: () {
                  _bloc.add(
                      const HistoryInOutChangeDate(typeDate: 0)); //0 là lùi
                },
                stateDate: state.date,
                child: Expanded(
                    child: RefreshIndicator(
                        onRefresh: () async {
                          _bloc.add(HistoryInOutPickDate(date: state.date));
                        },
                        child: state.historyList.isEmpty
                            ? ListView(children: [
                                SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.8,
                                    child: const EmptyWidget())
                              ])
                            : state.isLoading
                                ? const ItemLoading()
                                : ListView.builder(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w, 16.h, 16.w, 48.h),
                                    itemBuilder: (context, index) => _buildItem(
                                        item: state.historyList[index]),
                                    itemCount: state.historyList.length))));
          }
          return const ItemLoading();
        }));
  }

  Widget _buildItem({required HistoryInOutResponse item}) {
    return Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(64.r)),
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: item.type == 'I'
                    ? Colors.blue
                    : item.type == 'O'
                        ? MyColor.textRed
                        : MyColor.textGreen,
                child: Icon(
                  item.type == 'I'
                      ? Icons.login
                      : item.type == 'O'
                          ? Icons.logout
                          : Icons.check,
                  color: Colors.white,
                )), //hard
            title: Text(
                item.type == 'I'
                    ? 'Check In'
                    : item.type == 'O'
                        ? 'Check Out'
                        : 'Check',
                style: const TextStyle(fontWeight: FontWeight.bold)), //hard
            subtitle: Text(
                FormatDateConstants.convertUTCTime2(item.actionDate ?? 0))));
  }
}
