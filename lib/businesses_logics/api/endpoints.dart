class Endpoint {
  static const String apitoken = "token";
  static const String getUserProfile = "api/authentication/userprofile/%s";
  static const String getStatussummary =
      "api/employeeservice/employee/statussummary";
  static const String getVersion =
      "api/ssocommonservice/getlastedversions/MB_MPI";
  static const String getMenu = "api/ssocommonservice/menus";
  static const String getAnnouncements =
      "api/mpi/announceservice/announce/dashboard";
  static const String getTimeSheetService = "api/timesheetservice/timesheets";
  static const String getStdcode = "api/mpi/commonservice/stdcodes/%s";

  static const String putTimeSheetService =
      "api/mpi/timesheetservice/timesheet";
  static const String getAnnounceDoc = "api/announceservice/announce/%s/%s";
  static const String getGallery =
      "api/mpi/documentservice/document/gallerys/ALL";

  static const String getcoworklocs = "api/mpi/coworklocservice/coworklocs";
  static const String validationLocation =
      "api/timesheetservice/validatelocation";
  static const String postCheckInOut =
      "api/timesheetservice/checkinoutapps"; //11/11/2023
  static const String getHistoryInOut =
      "api/timesheetservice/timesheets/detail/employee";
  static const String getEmployee = "api/employeeservice/employee/search";
  static const String getFacilitybookings =
      "api/facilitybookingservice/facilitybookings";

  static const String uploadAvt = "api/userprofile/saveavatar";
  static const String getLeave = "api/leaveservice/leaves";
  static const String getLeaveDetail = "api/leaveservice/leave/23/lvid/%s";
  static const String checkLeaveWithType =
      "api/leaveservice/leaveentitle/seach";
  static const String getWorkFlow =
      "api/mpi/documentservice/document/getdocumentworkflow";

  static const String postFacilityValidate =
      "api/facilitybookingservice/validate";
  static const String getFacilities =
      "api/mpi/commonservice/facilities/subsidiaryid/S1";
  static const String postSavefacilityBooking =
      "api/facilitybookingservice/savefacilitybooking";

  //18/09/24
  static const String deleteFacilityBooking =
      'api/mpi/facilitybookingservice/cancelfacilitybooking/%s/userid/%s';
  static const String getApplications = "api/mpi/commonservice/applications";
  static const String getDivisions = "api/ssocommonservice/divisions";
  static const String postCreateServiceRequests =
      "api/servicerequests/servicerequests";
  static const String postServiceRequests = "api/servicerequests/search";
  static const String getServiceRequestDetail =
      "api/servicerequests/id/%s/userId/%s";

  static const String createNewLeave = "api/leaveservice/save";
  static const String getDocumentServiceRequest =
      "api/mpi/documentservice/documents/%s/%s";
  static const String postDocumentService = "api/mpi/documentservice/document";
  static const String getDocumentService =
      "api/mpi/documentservice/document/%s";
  static const String getITServiceSearch =
      "api/mpi/requestservice/ITServiceRequests/search";
  static const String getITServiceDetail =
      'api/mpi/requestservice/ITServiceRequest/%s';
  static const String getITAdmin = "api/employeeservice/itadmin/%s";
  static const String replyITServiceDetail =
      "api/requestservice/ITServiceRequest/reply";

  static const String createITServiceRequests =
      "api/requestservice/ITServiceRequest";

  static const String searchITService =
      "api/requestservice/ITServiceRequests/search";

  static const String getServicePending =
      "/api/mpi/commonservice/requestservice/pendding/%s/%s";

  static const String postServiceApprovals =
      "api/servicerequests/search/approvallist";
  static const String getInterviewApproval =
      "api/mpi/recruitmentservice/recruitInterview/getschedules";

  static const String getRecruitInterview =
      "api/mpi/recruitmentservice/recruitInterview/getschedule/%s";
  static const String getRecruitInterviewForm =
      "api/mpi/recruitmentservice/RecruitInterview/%s";
//  api/mpi/recruitmentservice/RecruitCVInterviewee
  static const String recruitCVInterviewee =
      "api/mpi/recruitmentservice/RecruitCVInterviewee";
  static const String postSaveServiceApproval =
      "api/mpi/servicerequests/servicerequests/approval";

  static const String postLeaveApprovals =
      "api/leaveservice/leaves/approvallist";

  static const String postUpdateLeaveApproval =
      "api/leaveservice/leave/approval";

  static const String getDocumentByInterview =
      "api/mpi/documentservice/documents/RECRCV/%s";

  //9/6/2023
  static const String getTimesheetApproval =
      "api/mpi/timesheetservice/timesheetapproval";
  static const String saveTimesheetApproval =
      "api/mpi/timesheetservice/timesheet/approval";

  //12/06/2023
  static const String getMultilange = "api/mpi/commonservice/resources/%s";

//14/06/2024 - paging load
  static const String getNotification = "api/GetMessage/%s/%s/%s/%s/%s";
  static const String deleteNotifications = "/api/DeleteNotifi";

  //21/07/2023
  static const String updateStatusNotification = "api/UpdateMsgStatus";
  static const String getTotalNotifications = "api/CountMessageByUser/%s/%s";
  //12/06/2024
  // static const String deleteNotifications = "api/DeleteMessage/%s/%s";

  static const String loginHub = "api/UserLogin";
  static const String logoutHub = "api/UserLogout";

  //change password
  static const String changePassword = "api/authentication/changepassword";

  static const String getSubsidiary = 'api/ssocommonservice/GetSubsidiary/%s';

  //14/09/2024
  static const String getGenerateConfig =
      'api/ssocommonservice/getconfiguration/%s/GENERATE';
  static const String getSystemConfig =
      'api/ssocommonservice/getconfiguration/%s/SYSTEM';
}
