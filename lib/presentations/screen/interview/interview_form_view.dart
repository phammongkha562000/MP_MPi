import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mpi_new/presentations/presentations.dart';

import '../../../businesses_logics/bloc/interview/interview_form/interview_form_bloc.dart';

class InterviewFormView extends StatefulWidget {
  const InterviewFormView({super.key});

  @override
  State<InterviewFormView> createState() => _InterviewFormViewState();
}

class _InterviewFormViewState extends State<InterviewFormView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: "details",
      ),
      body: BlocListener<InterviewFormBloc, InterviewFormState>(
        listener: (context, state) {},
        child: BlocBuilder<InterviewFormBloc, InterviewFormState>(
          builder: (context, state) {
            if (state is InterviewFormLoadSuccess) {
              final itemForm = state.form;
              final item = state.interviewApproval;
              return ListView(
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 32.h),
                children: [
                  _buildItemForm(
                      itemTop: "name", itemBottom: item.cvName ?? ""),
                  _buildItemForm(
                      itemTop: "permanentaddress",
                      itemBottom: itemForm.permanentAddr ?? ""),
                  RowFlex5and5(
                      widthSpacer: 0.05,
                      left: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildItemForm(
                              itemTop: "tempaddress",
                              itemBottom: itemForm.tempAddr ?? ""),
                          _buildItemForm(
                              itemTop: "idno", itemBottom: itemForm.idNo ?? ""),
                          _buildItemForm(
                              itemTop: "placeofiss",
                              itemBottom: itemForm.placeOfIssue ?? ""),
                          _buildItemForm(
                              itemTop: "availabledate",
                              itemBottom: itemForm.availableDate ?? ""),
                          _buildItemForm(
                              itemTop: "educationlevel",
                              itemBottom: itemForm.educationLevel ?? ""),
                          _buildItemForm(
                              itemTop: "currentsalary",
                              type: 1,
                              itemBottom: itemForm.currentSalary.toString()),
                        ],
                      ),
                      right: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildItemForm(
                              itemTop: "nativeplace",
                              itemBottom: itemForm.nativePlace ?? ""),
                          _buildItemForm(
                              itemTop: "idissuedate",
                              itemBottom: itemForm.idIssueDate.toString()),
                          _buildItemForm(
                              itemTop: "maritalstatus",
                              itemBottom: itemForm.marialStatus ?? ""),
                          _buildItemForm(
                              itemTop: "langavailable",
                              itemBottom: itemForm.languageAvailable ?? ""),
                          _buildItemForm(
                              itemTop: "expectedsalary",
                              type: 1,
                              itemBottom: itemForm.expectedSalary.toString()),
                          _buildItemForm(
                              itemTop: "salarycomment",
                              itemBottom: itemForm.salaryComment ?? ""),
                        ],
                      ),
                      spacer: true),
                  _buildItemForm(
                      itemTop: "otherskill",
                      itemBottom: itemForm.otherSkills ?? ""),
                  _buildItemForm(
                      itemTop: "experience",
                      itemBottom: "${itemForm.experience ?? ''}\n\n"),
                  _buildItemForm(
                      itemTop: "interviewcomment",
                      itemBottom: "${itemForm.interviewComment ?? ''}\n\n"),
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildItemForm({
    required String itemTop,
    required String itemBottom,
    int? type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 6.h),
          child: Text(itemTop.tr(),
              style: _styleLeft(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32.r)),
              color: Theme.of(context).primaryColor.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(itemBottom.isEmpty || itemBottom == "null"
                    ? type == 1
                        ? "0"
                        : ""
                    : itemBottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _styleLeft() {
    return const TextStyle(
        color: MyColor.textBlack, fontWeight: FontWeight.bold);
  }
}
