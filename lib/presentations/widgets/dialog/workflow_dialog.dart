import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../data/data.dart';

AwesomeDialog showDialogWorkFlow(
    {required BuildContext context,
    required List<WorkFlowResponse> workflowList}) {
  Color primaryColor = Theme.of(context).primaryColor;
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: SizedBox(
        height: 400,
        child: Column(
          children: [
            Text(
              "viewworkflow".tr().toUpperCase(),
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            workflowList.isEmpty
                ? Text("nodata".tr())
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      itemCount: workflowList.length,
                      itemBuilder: (context, index) {
                        var itemWorkFlow = workflowList[index];
                        return TimelineTile(
                          indicatorStyle: IndicatorStyle(
                              color: primaryColor,
                              width: 12,
                              padding: const EdgeInsets.symmetric(vertical: 4)),
                          beforeLineStyle:
                              LineStyle(thickness: 3, color: primaryColor),
                          endChild: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemWorkFlow.namedRoleName ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(itemWorkFlow.namedRoleDesc ?? ''),
                                    Text(itemWorkFlow.roleDesc ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isFirst: index == 0 ? true : false,
                          isLast:
                              index == workflowList.length - 1 ? true : false,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ));
}
