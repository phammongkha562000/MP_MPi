import 'package:mpi_new/data/models/configuration/system_response.dart';
import 'package:mpi_new/data/models/configuration/generate_response.dart';
import 'package:mpi_new/data/models/login/subsidiary_response.dart';
import 'package:mpi_new/data/models/timesheet_approval/timesheet_approval_response.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

class ApiResponse {
  ApiResponse({
    required this.success,
    this.payload,
    required this.error,
  });

  bool success;
  dynamic payload;
  Error error;

  factory ApiResponse.fromJson(Map<String, dynamic> json,
          {required String endpoint}) =>
      ApiResponse(
        success: json["success"],
        payload: fromJson(endpoint, json),
        error: Error.fromJson(json["error"]),
      );
}

class Error {
  Error({
    this.errorCode,
    this.errorMessage,
  });

  dynamic errorCode;
  dynamic errorMessage;

  Error copyWith({
    dynamic errorCode,
    dynamic errorMessage,
  }) =>
      Error(
        errorCode: errorCode ?? this.errorCode,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "errorMessage": errorMessage,
      };
}

dynamic fromJson(String endpoint, Map<String, dynamic> json) {
  switch (endpoint) {
    //endpoint nào thì map về model đó
    case Endpoint.getStatussummary:
      return json['payload'] == null
          ? null
          : LeaveListRemainResponse.fromJson(json["payload"]);
    case Endpoint.getUserProfile:
      return json['payload'] == null
          ? null
          : UserProfile.fromJson(json["payload"]);
    case Endpoint.getTimeSheetService:
      return json['payload'] == null
          ? null
          : TimesheetResponse.fromJson(json["payload"]);

    case Endpoint.getStdcode:
      return json['payload'] == null
          ? null
          : List<StdCode>.from(json["payload"].map((x) => StdCode.fromJson(x)));
    case Endpoint.getcoworklocs:
      return json['payload'] == null
          ? null
          : List<WifiResponse>.from(
              json["payload"].map((x) => WifiResponse.fromJson(x)));
    case Endpoint.validationLocation:
      return json['payload'] == null
          ? ValidationLocationResponse()
          : ValidationLocationResponse.fromJson(json["payload"]);

    case Endpoint.postCheckInOut:
      return json['payload'];

    case Endpoint.getAnnouncements:
      return json['payload'] == null
          ? null
          : List<AnnouncementsResponse>.from(
              json["payload"].map((x) => AnnouncementsResponse.fromJson(x)));
    case Endpoint.getGallery:
      return json["payload"] == null
          ? null
          : List<GalleryResponse>.from(
              json["payload"].map((x) => GalleryResponse.fromJson(x)));
    case Endpoint.getHistoryInOut:
      return json["payload"] == null
          ? null
          : List<HistoryInOutResponse>.from(
              json["payload"].map((x) => HistoryInOutResponse.fromJson(x)));

    case Endpoint.getEmployee:
      return json["payload"] == null
          ? null
          : EmployeeSearchResponse.fromJson(json["payload"]);
    case Endpoint.getFacilitybookings:
      return json["payload"] == null
          ? null
          : List<BookingMeetingResponse>.from(
              json["payload"].map((x) => BookingMeetingResponse.fromJson(x)));

    case Endpoint.getLeave:
      return json["payload"] == null
          ? null
          : LeavePayload.fromJson(json["payload"]);
    case Endpoint.getLeaveDetail:
      return json["payload"] == null
          ? null
          : LeaveDetailPayload.fromJson(json["payload"]);
    // Endpoint.checkLeaveWithType
    case Endpoint.checkLeaveWithType:
      return json["payload"] == null
          ? null
          : CheckLeaveResponse.fromJson(json["payload"]);
    case Endpoint.getWorkFlow:
      return json["payload"] == null
          ? null
          : List<WorkFlowResponse>.from(
              json["payload"].map((x) => WorkFlowResponse.fromJson(x)));
    case Endpoint.getFacilities:
      return json["payload"] == null
          ? null
          : List<FacilitiesResponse>.from(
              json["payload"].map((x) => FacilitiesResponse.fromJson(x)));
    case Endpoint.getApplications:
      return json["payload"] == null
          ? null
          : List<ApplicationResponse>.from(
              json["payload"].map((x) => ApplicationResponse.fromJson(x)));
    case Endpoint.getDivisions:
      return json["payload"] == null
          ? null
          : List<DivisionResponse>.from(
              json["payload"].map((x) => DivisionResponse.fromJson(x)));
    case Endpoint.postServiceRequests:
      return json["payload"] == null
          ? null
          : ServiceRequestResponse.fromJson(json["payload"]);
    case Endpoint.getServiceRequestDetail:
      return json["payload"] == null
          ? null
          : ServiceRequestDetailResponse.fromJson(json["payload"]);

    case Endpoint.createNewLeave:
      return json["payload"];

    case Endpoint.postCreateServiceRequests:
      return json["payload"];
    case Endpoint.getDocumentServiceRequest:
      return json["payload"] == null
          ? null
          : List<FileResponse>.from(
              json["payload"].map((x) => FileResponse.fromJson(x)));
    case Endpoint.getDocumentService:
      return json["payload"] == null
          ? null
          : FileDocumentResponse.fromJson(json["payload"]);

    case Endpoint.getITServiceSearch:
      return json["payload"] == null
          ? null
          : ITServiceResponse.fromJson(json["payload"]);

    case Endpoint.getITServiceDetail:
      return json["payload"] == null
          ? null
          : ITServiceDetailResponse.fromJson(json["payload"]);
    case Endpoint.getITAdmin:
      return json["payload"] == null
          ? null
          : List<ITAdminResponse>.from(
              json["payload"].map((x) => ITAdminResponse.fromJson(x)));
    case Endpoint.replyITServiceDetail:
      return json["payload"];

    case Endpoint.createITServiceRequests:
      return json["payload"];

    case Endpoint.postServiceApprovals:
      return json["payload"] == null
          ? null
          : ServiceApprovalResponse.fromJson(json["payload"]);
    case Endpoint.getInterviewApproval:
      return json["payload"] == null
          ? null
          : InterviewApprovalResponse.fromJson(json["payload"]);

    case Endpoint.postLeaveApprovals:
      return json["payload"] == null
          ? null
          : LeaveApprovalResponse.fromJson(json["payload"]);
    case Endpoint.postUpdateLeaveApproval:
      return json["payload"];
    case Endpoint.getRecruitInterview:
      return json["payload"] == null
          ? null
          : InterviewApprovalResult.fromJson(json["payload"]);

    case Endpoint.recruitCVInterviewee:
      return json["payload"];

    case Endpoint.getRecruitInterviewForm:
      return json["payload"] == null
          ? null
          : RecruitInterviewFormResponse.fromJson(json["payload"]);
    case Endpoint.postFacilityValidate:
      return json["payload"] == null
          ? null
          : List<ValidateBookMeetingResponse>.from(json["payload"]
              .map((x) => ValidateBookMeetingResponse.fromJson(x)));
    case Endpoint.getDocumentByInterview:
      return json["payload"] == null
          ? null
          : List<DocumentInterview>.from(
              json["payload"].map((x) => DocumentInterview.fromJson(x)));
    case Endpoint.getTimesheetApproval:
      return json["payload"] == null
          ? null
          : TimesheetApprovalResponse.fromJson(json["payload"]);
    case Endpoint.getSubsidiary:
      return json["payload"] == null
          ? null
          : List<SubsidiaryRes>.from(
              json["payload"].map((e) => SubsidiaryRes.fromJson(e)));
    case Endpoint.getGenerateConfig:
      return json["payload"] == null
          ? null
          : ConfigGenerateResponse.fromJson(json["payload"]);

    case Endpoint.getSystemConfig:
      return json["payload"] == null
          ? null
          : ConfigSystemResponse.fromJson(json["payload"]);

    case Endpoint.deleteFacilityBooking:
      return json["payload"];
    default:
      return null;
  }
}
