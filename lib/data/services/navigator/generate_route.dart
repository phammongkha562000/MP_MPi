import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/businesses_logics/bloc/contact/contact_bloc.dart';
import 'package:mpi_new/data/services/navigator/import_generate.dart';

import '../../../businesses_logics/bloc/forgot_password/forgot_password_bloc.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MyRoute.loginViewRoute:
      var loginServer = (settings.arguments
          as Map<dynamic, dynamic>?)?[KeyParams.loginServer];
      final isLogout =
          (settings.arguments as Map<dynamic, dynamic>?)?[KeyParams.isLogout];

      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginBloc()
                ..add(LoginViewLoaded(
                    defaultServerMode: loginServer,
                    isLogOut: isLogout ?? false)),
            ),
            BlocProvider(
              create: (context) => LangBloc(),
            ),
          ],
          child: const LoginViewNew(),
        ),
      );
    case MyRoute.homePageRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HomeBloc(),
          child: const HomeView(),
        ),
      );
    case MyRoute.clockInOutRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ClockInOutBloc(),
          child: const ClockInOutView2(),
        ),
      );
    case MyRoute.historyInOutRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              HistoryInOutBloc()..add(HistoryInOutViewLoaded()),
          child: const HistoryInOutView(),
        ),
      );
    case MyRoute.timesheetsRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    TimesheetsBloc()..add(const TimesheetsViewLoaded()),
                child: const TimesheetsView(),
              ));
    case MyRoute.timesheetsDetailRoute:
      final timesheets = (settings.arguments as Map)[KeyParams.timesheets];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TimesheetsDetailBloc(),
                child: TimesheetsDetailView(timesheetsResponse: timesheets),
              ));

    case MyRoute.announcementRoute:
      final AnnouncementsResponse announcementsPayload =
          (settings.arguments as Map)[KeyParams.announcements];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AnnouncementsBloc()
            ..add(AnnouncementsLoaded(
                announcementsPayload: announcementsPayload)),
          child: const AnnouncementDetailView(),
        ),
      );
    case MyRoute.employeeRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => EmployeeBloc(),
                child: const EmployeeView(),
              ));
    case MyRoute.employeeDetailRoute:
      final EmployeeSearchResult employee =
          (settings.arguments as Map)[KeyParams.employee];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => EmployeeDetailBloc()
                  ..add(EmployeeDetailViewLoaded(
                      idEmp: employee.employeeId ?? 0)),
                child: EmployeeDetailView(
                  employee: employee,
                ),
              ));
    case MyRoute.bookingMeetingRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => BookingMeetingBloc()
                  ..add(BookingMeetingViewLoaded(date: DateTime.now())),
                child: const BookingMeetingView(),
              ));
    case MyRoute.addBookingMeetingRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    AddBookingMeetingBloc()..add(AddBookingMeetingViewLoaded()),
                child: const AddBookingMeetingView(),
              ));

    case MyRoute.proFileRoute:

      // *type =1 - Không upload avt
      // *type = 2 - Upload avt
      int type = (settings.arguments as Map)[KeyParams.uploadImg];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ProfileBloc(),
          child: ProfileView(
            type: type,
          ),
        ),
      );

    case MyRoute.serviceRequestRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              ServiceRequestBloc()..add(ServiceRequestViewLoaded()),
          child: const ServiceRequestView(),
        ),
      );
    case MyRoute.addServiceRequestRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AddServiceRequestBloc(),
          child: const AddServiceRequestView(),
        ),
      );
    case MyRoute.serviceRequestDetailRoute:
      String svrNo = (settings.arguments as Map)[KeyParams.svrNo];
      final isApprove = (settings.arguments as Map)[KeyParams.isApproveSVR];

      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ServiceRequestDetailBloc()
                  ..add(ServiceRequestDetailViewLoaded(svrNo: svrNo)),
                child: ServiceRequestDetailView(
                  svrNo: svrNo,
                  isApprove: isApprove,
                ),
              ));
    case MyRoute.leaveRoute:
      final isAddLeave = (settings.arguments as Map)[KeyParams.isAddLeave];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              LeaveBloc()..add(LeaveLoaded(date: DateTime.now())),
          child: LeaveView(isAddLeave: isAddLeave ?? false),
        ),
      );

    case MyRoute.leaveDetailRoute:
      final lvNo = (settings.arguments as Map)[KeyParams.lvNoLeave];
      final isApprove = (settings.arguments as Map)[KeyParams.isApproveLeave];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    LeaveDetailBloc()..add(LeaveDetailLoaded(lvNo: lvNo)),
                child: LeaveDetailView(
                  isApprove: isApprove,
                  lvNo: lvNo,
                ),
              ));
    case MyRoute.newLeave:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => NewLeaveBloc(),
          child: const NewLeaveView(),
        ),
      );
    case MyRoute.displayFileRoute:
      final fileList = (settings.arguments as Map)[KeyParams.fileList];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              DisplayFileBloc()..add(DisplayFileViewLoaded(fileList: fileList)),
          child: const DisplayFileView(),
        ),
      );

    case MyRoute.itServiceRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ITServiceBloc(),
          child: const ITServiceView(),
        ),
      );
    case MyRoute.itServiceDetailRoute:
      final irsNo = (settings.arguments as Map)[KeyParams.irsNo];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ITServiceDetailBloc(),
          child: ITServiceDetailView(irsNo: irsNo),
        ),
      );
    case MyRoute.itServiceNewRequestRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ITServiceNewRequestBloc(),
          child: const CreateNewITServiceView(),
        ),
      );
    case MyRoute.serviceApprovalRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ServiceApprovalBloc(),
                child: const ServiceApprovalView(),
              ));
    case MyRoute.leaveApprovalRoute:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => LeaveApprovalBloc(),
                child: const LeaveApprovalView(),
              ));

    case MyRoute.interviewApprovalRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InterviewApprovalBloc(),
          child: const InterviewApprovalView(),
        ),
      );
    case MyRoute.interviewApprovalDetailRoute:
      InterviewApprovalResult item =
          (settings.arguments as Map)[KeyParams.interviewDetail];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => InterviewApprovalDetailBloc()
            ..add(
                InterviewApprovalDetailLoaded(interviewApprovalResponse: item)),
          child: const InterviewApprovalViewDetail(),
        ),
      );
    case MyRoute.interviewFormRoute:
      RecruitInterviewFormResponse form =
          (settings.arguments as Map)[KeyParams.interviewForm];
      InterviewApprovalResult interviewApproval =
          (settings.arguments as Map)[KeyParams.interviewApproval];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => InterviewFormBloc()
                  ..add(InterviewFormLoaded(
                      form: form, interviewApproval: interviewApproval)),
                child: const InterviewFormView(),
              ));

    case MyRoute.documentViewRoute:
      String fileLocation = (settings.arguments as Map)[KeyParams.documentFile];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              DocumentBloc()..add(DocumentLoaded(fileLocation: fileLocation)),
          child: const DocumentView(),
        ),
      );

    case MyRoute.timesheetApprovalRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TimesheetApprovalBloc(),
          child: const TimesheetApprovalView(),
        ),
      );

    case MyRoute.pdfViewRoute:
      String pathPDF = (settings.arguments as Map)[KeyParams.pdfPath];

      return MaterialPageRoute(
        builder: (context) => PDFView(
          path: pathPDF,
        ),
      );
    case MyRoute.inboxRoute:
      ValueNotifier<dynamic> totalNotifications =
          (settings.arguments as Map)[KeyParams.totalNoti];
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => InboxBloc()..add(InboxViewLoaded()),
                child: InboxView(
                  totalNotifications: totalNotifications,
                ),
              ));

    case MyRoute.changePasswordRoute:
      bool isBackLogin = (settings.arguments as Map)[KeyParams.isBackLogin];
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              ChangePasswordBloc()..add(ChangePasswordLoaded()),
          child: ChangePasswordView(
            isBackLogin: isBackLogin,
          ),
        ),
      );

    case MyRoute.contactRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ContactBloc()..add(ContactViewLoaded()),
          child: const ContactView(),
        ),
      );

    case MyRoute.forgotPasswordRoute:
      final username = (settings.arguments as Map)[KeyParams.username];

      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ForgotPasswordBloc(),
          child: WebViewPluginView(username: username),
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('No path ${settings.name}')),
        ),
      );
  }
}
