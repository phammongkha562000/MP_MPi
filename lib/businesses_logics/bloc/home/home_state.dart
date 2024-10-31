part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeNoInternet extends HomeState {}

class HomeSuccess extends HomeState {
  final String serverMode;
  final List<AnnouncementsResponse> listAnn;
  final List<GalleryResponse> listGallery;
  final double remainAnnualLeave;
  final DateTime? checkIn;

  final List<RequestServiceResponse>? listRequestService;
  final List<InterviewApprovalResult>? listInterview;

  const HomeSuccess({
    required this.serverMode,
    required this.listAnn,
    required this.listGallery,
    required this.remainAnnualLeave,
    this.checkIn,
    this.listRequestService,
    this.listInterview,
  });
  @override
  List<Object?> get props =>
      [listAnn, listGallery, serverMode, remainAnnualLeave, checkIn];

  HomeSuccess copyWith({
    String? serverMode,
    UserInfo? userInfo,
    SubsidiaryInfo? subsidiaryInfo,
    List<AnnouncementsResponse>? listAnn,
    List<GalleryResponse>? listGallery,
    List<String>? listBigImg,
    double? remainAnnualLeave,
    DateTime? checkIn,
    List<RequestServiceResponse>? listRequestService,
    List<InterviewApprovalResult>? listInterview,
  }) {
    return HomeSuccess(
      serverMode: serverMode ?? this.serverMode,
      listAnn: listAnn ?? this.listAnn,
      listGallery: listGallery ?? this.listGallery,
      remainAnnualLeave: remainAnnualLeave ?? this.remainAnnualLeave,
      checkIn: checkIn ?? this.checkIn,
      listRequestService: listRequestService ?? this.listRequestService,
      listInterview: listInterview ?? this.listInterview,
    );
  }
}

class HomeFailure extends HomeState {
  final String message;
  final int? errorCode;
  const HomeFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class UserDefaultPassState extends HomeState {}
