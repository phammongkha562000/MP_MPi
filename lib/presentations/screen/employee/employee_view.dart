import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';

import 'package:mpi_new/data/models/employee/employee_search_response.dart';
import 'package:mpi_new/data/services/injection/injection_mpi.dart';
import 'package:mpi_new/data/services/navigator/navigation_service.dart';
import 'package:mpi_new/data/services/navigator/route_path.dart';
import 'package:mpi_new/presentations/presentations.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';
import 'package:rxdart/rxdart.dart';
import '../../../businesses_logics/bloc/employee/employee/employee_bloc.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final _navigationService = getIt<NavigationService>();
  final TextEditingController _nameController = TextEditingController();
  late AppBloc appBloc;
  late EmployeeBloc _bloc;
  final ScrollController _scrollDivisionController = ScrollController();
  final ScrollController _scrollAllController = ScrollController();

  BehaviorSubject<List<EmployeeSearchResult>> empDivisionList =
      BehaviorSubject();

  BehaviorSubject<List<EmployeeSearchResult>> empAllList = BehaviorSubject();

  int qtyDivision = 0;
  int qtyAll = 0;

  String serverUpload = '';

  @override
  void initState() {
    appBloc = BlocProvider.of<AppBloc>(context);
    _bloc = BlocProvider.of<EmployeeBloc>(context);
    _bloc.add(EmployeeSearchViewLoaded(
        divisionCode: appBloc.subsidiaryInfo?.divisionCode ?? ''));
    _scrollDivisionController.addListener(() {
      if (_scrollDivisionController.position.pixels ==
          _scrollDivisionController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(EmployeeByDivisionPaging(
            divisionCode: appBloc.subsidiaryInfo?.divisionCode ?? '',
            name: _nameController.text));
      }
    });
    _scrollAllController.addListener(() {
      if (_scrollAllController.position.pixels ==
          _scrollAllController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(EmployeeAllPaging(name: _nameController.text));
      }
    });
    super.initState();
  }

  Color primaryColor = MyColor.defaultColor;
  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    return BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
      if (state is EmployeeFailure) {
        MyDialog.showError(
            text: 'close'.tr(),
            context: context,
            messageError: state.message,
            pressTryAgain: () {
              Navigator.pop(context);
              _bloc.add(EmployeeSearchViewLoaded(
                  divisionCode: appBloc.subsidiaryInfo?.divisionCode ?? ''));
            });
      }
      if (state is EmployeeSuccess) {
        empDivisionList.add(state.employeeList);
        empAllList.add(state.employeeListAll);
        qtyAll = state.allQty;
        qtyDivision = state.divisionQty;

        serverUpload = state.serverUpload;
      }
      if (state is EmployeeByDivisionSuccess) {
        empDivisionList.add(state.empDivisionLst);
      }
      if (state is EmployeeAllSuccess) {
        empAllList.add(state.empAllLst);
      }
    }, builder: (context, state) {
      if (state is EmployeeLoading) {
        return const ItemLoading();
      }
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
              title: Container(
                  margin: EdgeInsets.all(8.w),
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.r)),
                  child: TextFormField(
                      controller: _nameController,
                      onChanged: (value) {
                        _bloc.add(EmployeeSearchSearchName(
                            name: _nameController.text,
                            divisionCode:
                                appBloc.subsidiaryInfo?.divisionCode ?? ''));
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon:
                                const Icon(Icons.clear, color: MyColor.textRed),
                            onPressed: () {
                              _nameController.clear();
                              _bloc.add(EmployeeSearchSearchName(
                                  name: _nameController.text,
                                  divisionCode:
                                      appBloc.subsidiaryInfo?.divisionCode ??
                                          ''));
                            },
                          ),
                          hintText: '${'search'.tr()}...')))),
          body: Column(children: [
            Expanded(
                child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(children: [
                      TabBar(
                          tabs: [
                            _buildTitleTab(title: 'department'.tr()),
                            _buildTitleTab(title: 'all'.tr())
                          ],
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          labelColor: primaryColor,
                          unselectedLabelColor: MyColor.outerSpace,
                          indicatorColor: primaryColor),
                      const Divider(height: 1),
                      Expanded(
                          child: TabBarView(children: [
                        _buildListEmployees(
                            empCtrl: empDivisionList,
                            scrollController: _scrollDivisionController,
                            state: state,
                            qty: qtyDivision),
                        _buildListEmployees(
                            empCtrl: empAllList,
                            scrollController: _scrollAllController,
                            state: state,
                            qty: qtyAll)
                      ])),
                    ])))
          ]));
    });
  }

  Widget _buildTitleTab({required String title}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: Text(title, textAlign: TextAlign.center));
  }

  Widget _buildListEmployees(
      {required BehaviorSubject<List<EmployeeSearchResult>> empCtrl,
      required ScrollController scrollController,
      required EmployeeState state,
      required int qty}) {
    return StreamBuilder(
      stream: empCtrl.stream,
      builder: (context, snapshot) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          (!snapshot.hasData ||
                  snapshot.data == [] ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty)
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text('${'quantity'.tr()} $qty',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: (!snapshot.hasData ||
                      snapshot.data == [] ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty)
                  ? const EmptyWidget()
                  : Scrollbar(
                      controller: scrollController,
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(
                            left: 12.w, top: 12.h, bottom: 48.h),
                        itemBuilder: (context, index) {
                          return Card(
                              surfaceTintColor: Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(64.r),
                                      bottomLeft: Radius.circular(64.r))),
                              child: ListTile(
                                  onTap: () => _navigationService
                                      .pushNamed(MyRoute.employeeDetailRoute,
                                          args: {KeyParams.employee: snapshot.data![index]}),
                                  leading: CircleAvatar(
                                      backgroundColor: MyColor.outerSpace,
                                      child: (snapshot.data![index].avartarThumbnail != null && snapshot.data![index].avartarThumbnail!.isNotEmpty)
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32.r),
                                              child: Image.network(
                                                  '${snapshot.data![index].avartarThumbnail}',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => _buildIconUser(fullName: snapshot.data![index].employeeName != '' ? snapshot.data![index].employeeName!.trim() : '')))
                                          : _buildIconUser(fullName: snapshot.data![index].employeeName != '' ? snapshot.data![index].employeeName!.trim() : '')),
                                  title: Text(snapshot.data![index].employeeName != null ? snapshot.data![index].employeeName!.trim() : '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(snapshot.data![index].deptDesc ?? '')));
                        },
                        itemCount: snapshot.data!.length,
                      ))),
          (state is EmployeePagingAllLoading ||
                  state is EmployeePagingDivisionLoading)
              ? const PagingLoading()
              : const SizedBox()
        ]);
      },
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

    return Text("$firstNameInitial$lastNameInitial".toUpperCase(),
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColor.defaultColor));
  }
}
