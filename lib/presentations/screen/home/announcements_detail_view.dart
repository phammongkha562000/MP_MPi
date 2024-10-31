import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mpi_new/presentations/presentations.dart';

import '../../../businesses_logics/bloc/home/announcements/announcements_bloc.dart';

class AnnouncementDetailView extends StatefulWidget {
  const AnnouncementDetailView({super.key});

  @override
  State<AnnouncementDetailView> createState() => _AnnouncementDetailViewState();
}

class _AnnouncementDetailViewState extends State<AnnouncementDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(context, title: "announcement"),
        body: BlocListener<AnnouncementsBloc, AnnouncementsState>(
            listener: (context, state) {},
            child: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
                builder: (context, state) {
              if (state is AnnouncementsSuccess) {
                final item = state.announcementsPayload;
                var create =
                    DateTime.fromMillisecondsSinceEpoch(item.createDate!)
                        .toLocal();
                var createDate = DateFormat("dd/MM/yyyy", "en").format(create);
                return DecoratedBox(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(MyAssets.bg),
                      fit: BoxFit.fill,
                    )),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 32, 8, 32),
                        child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.sizeOf(context).width * 0.02),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.subject ?? "",
                                                style: MyStyle.styleLabelInput),
                                            Text(
                                              "${"createdate".tr()}: $createDate",
                                            ),
                                            const Divider(
                                              color: MyColor.textBlack,
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          HtmlWidget(item.contents!),
                                        ],
                                      )),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Divider(
                                              color: MyColor.textBlack,
                                              thickness: 1,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: Text(
                                                    "${"createby".tr()}: ${item.createUser}",
                                                    style: const TextStyle(
                                                        fontSize: 15)))
                                          ])
                                    ])))));
              }
              return const ItemLoading();
            })));
  }
}
