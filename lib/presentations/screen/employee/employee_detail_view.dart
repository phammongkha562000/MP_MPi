import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../data/data.dart';

class EmployeeDetailView extends StatefulWidget {
  const EmployeeDetailView({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final EmployeeSearchResult employee;

  @override
  State<EmployeeDetailView> createState() => _EmployeeDetailViewState();
}

class _EmployeeDetailViewState extends State<EmployeeDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(context, title: "employeedetail"),
      body: BlocListener<EmployeeDetailBloc, EmployeeDetailState>(
        listener: (context, state) {
          if (state is EmployeeDetailFailure) {
            MyDialog.showError(
                text: 'close'.tr(),
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                  BlocProvider.of<EmployeeDetailBloc>(context).add(
                      EmployeeDetailViewLoaded(
                          idEmp: widget.employee.employeeId ?? 0));
                });
          }
        },
        child: BlocBuilder<EmployeeDetailBloc, EmployeeDetailState>(
          builder: (context, state) {
            if (state is EmployeeDetailSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.05,
                    bottom: MediaQuery.sizeOf(context).height * 0.08,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: MyColor.outerSpace,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MyColor.outerSpace,
                              blurRadius: 3,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(64.r),
                          child: (widget.employee.avartarThumbnail != null &&
                                  widget.employee.avartarThumbnail!.isNotEmpty)
                              ? InkWell(
                                  onTap: () {
                                    MyDialog.showPopupImage(context,
                                        path:
                                            '${widget.employee.avartarThumbnail}',
                                        type: 1);
                                  },
                                  child: Image.network(
                                    '${widget.employee.avartarThumbnail}',
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        _buildIconUser(
                                            fullName: widget.employee
                                                        .employeeName !=
                                                    ''
                                                ? widget.employee.employeeName!
                                                    .trim()
                                                : ''),
                                  ),
                                )
                              : _buildIconUser(
                                  fullName: widget.employee.employeeName != ''
                                      ? widget.employee.employeeName!.trim()
                                      : ''),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text(
                          widget.employee.employeeName ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      Table(
                        border: TableBorder.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.1)),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.h),
                                child: Text(
                                    state.userProfile.subsidiaryInfo
                                            .divisionDesc ??
                                        '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15)),
                              ),
                              Text(widget.employee.employeeCode ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 15)),
                              Text(
                                  'Since ${FormatDateLocal.format_dd_MM_yyyy(widget.employee.dateofJoin.toString())}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ],
                      ),
                      _buildIconTile(
                          iconData: Icons.apartment,
                          text:
                              state.userProfile.subsidiaryInfo.subsidiaryName ??
                                  ''),
                      _buildIconTile(
                          iconData: Icons.phone,
                          text: state.userProfile.userInfo.mobile ?? '',
                          isPhone: true),
                      _buildIconTile(
                          iconData: Icons.mail,
                          text: state.userProfile.userInfo.email ?? '',
                          isMail: true),
                      _buildIconTile(
                          iconData: Icons.phonelink_outlined,
                          text: state.userProfile.userInfo.tel ?? ''),
                      _buildIconTile(
                          iconData: Icons.work_outlined,
                          text:
                              state.userProfile.subsidiaryInfo.deptDesc ?? ''),
                    ],
                  ),
                ),
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildIconUser({required String fullName}) {
    String firstNameInitial = "";
    String lastNameInitial = "";

    var check = fullName.contains(" ");
    if (check == true) {
      List<String> nameParts = fullName.split(" ");
      firstNameInitial = nameParts[0].substring(0, 1);
      lastNameInitial = nameParts[nameParts.length - 1].substring(0, 1);
    } else {
      firstNameInitial = fullName.substring(0, 1);
      lastNameInitial = fullName.substring(1, 2);
    }

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      width: 120,
      height: 120,
      child: Text(
        "$firstNameInitial$lastNameInitial".toUpperCase(),
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: MyColor.defaultColor,
        ),
      ),
    );
  }

  Widget _buildIconTile(
      {required IconData iconData,
      required String text,
      bool? isPhone,
      bool? isMail}) {
    return Column(
      children: [
        ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            title: Text(text,
                style: TextStyle(
                    color: (isPhone ?? false
                        ? Colors.blue
                        : isMail ?? false
                            ? Colors.blue
                            : Colors.black))),
            onTap: isPhone ?? false
                ? () {
                    text != '' ? _launchTel(tel: text) : null;
                  }
                : isMail ?? false
                    ? () {
                        text != '' ? _launchMail(mail: text) : null;
                      }
                    : null,
            leading: Icon(iconData, color: MyColor.outerSpace)),
      ],
    );
  }

  void _launchTel({required String tel}) =>
      launchUrl(Uri(scheme: 'tel', path: tel));
  void _launchMail({required String mail}) =>
      launchUrl(Uri(scheme: 'mailto', path: mail));
}
