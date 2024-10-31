import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/businesses_logics/bloc/contact/contact_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
        appBar: AppBarCustom(context, title: 'contactpage'),
        body: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ContactFailure) {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    BlocProvider.of<ContactBloc>(context)
                        .add(ContactViewLoaded());
                  });
            }
          },
          builder: (context, state) {
            if (state is ContactSuccess) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Text(
                        state.subsidiaryRes.subsidiaryName ?? '',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    _buildInfoCompany(
                        icon: const Icon(Icons.map),
                        title: 'address',
                        subTitle:
                            '${state.subsidiaryRes.address1 ?? ''}${state.subsidiaryRes.address2 ?? ''}${state.subsidiaryRes.address3 ?? ''} '),
                    _buildInfoTel(
                        icon: const Icon(Icons.phone),
                        title: 'tel',
                        subTitle: state.subsidiaryRes.tel ?? ''),
                    _buildInfoCompany(
                        icon: const Icon(Icons.fax),
                        title: 'fax',
                        subTitle: state.subsidiaryRes.fax ?? ''),
                    _buildInfoWeb(
                        icon: const Icon(Icons.web),
                        title: 'Website',
                        subTitle: state.subsidiaryRes.www ?? ''),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text('moreinfoapp'.tr()),
                    ),
                    Container(
                      margin: EdgeInsets.all(16.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.r),
                          color: MyColor.aliceBlue),
                      child: Column(
                        children: [
                          _buildInfo(
                              title: 'version',
                              trailing:
                                  '${globalApp.version} (${globalApp.versionBuild})'),
                          _divider(),
                          _buildInfo(
                              title: 'updateddate', trailing: '25/10/2024'),
                          _divider(),
                          _divider(),
                          _buildInfo(title: 'language', trailing: 'envi'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const ItemLoading();
          },
        ));
  }

  Widget _divider() {
    return const Divider(
      indent: 16,
      endIndent: 16,
      color: MyColor.darkLiver,
      height: 0,
    );
  }

  Widget _buildInfo({required String title, required String trailing}) {
    return ListTile(
      title: Text(title.tr()),
      trailing: Text(trailing.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildInfoCompany(
      {required String title, required String subTitle, required Icon icon}) {
    return ListTile(
      leading: icon,
      title: Text(title.tr()),
      subtitle: Text(subTitle),
    );
  }

  Widget _buildInfoWeb(
      {required String title, required String subTitle, required Icon icon}) {
    return ListTile(
      onTap: () {
        _launchWebsite(website: subTitle);
      },
      leading: icon,
      title: Text(title.tr()),
      subtitle: Text(subTitle,
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: Colors.blue)),
    );
  }

  Widget _buildInfoTel(
      {required String title, required String subTitle, required Icon icon}) {
    return ListTile(
      onTap: () {
        _launchTel(tel: subTitle);
      },
      leading: icon,
      title: Text(title.tr()),
      subtitle: Text(subTitle,
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: Colors.blue)),
    );
  }

  void _launchTel({required String tel}) =>
      launchUrl(Uri(scheme: 'tel', path: tel));

  void _launchWebsite({required String website}) => launchUrl(
        Uri.parse(website),
        mode: LaunchMode.inAppWebView,
      );
}
