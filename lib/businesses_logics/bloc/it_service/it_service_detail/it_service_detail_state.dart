part of 'it_service_detail_bloc.dart';

abstract class ITServiceDetailState extends Equatable {
  const ITServiceDetailState();

  @override
  List<Object?> get props => [];
}

class ItServiceDetailInitial extends ITServiceDetailState {}

class ITServiceDetailLoading extends ITServiceDetailState {}

class ITServiceSending extends ITServiceDetailState {}

class ITServiceSendSuccess extends ITServiceDetailState {}

class ITServiceDetailLoadSuccess extends ITServiceDetailState {
  final String irsNo;
  final ITServiceDetailResponse itServiceDetailResponse;
  final List<StdCode>? listItService;
  final List<StdCode>? listSVC;
  final List<StdCode>? listSrStatus;
  final List<ITAdminResponse>? listITAdmin;
  final StdCode? selectedStatus;

  const ITServiceDetailLoadSuccess(
      {required this.irsNo,
      required this.itServiceDetailResponse,
      this.listItService,
      this.listSVC,
      this.listSrStatus,
      this.listITAdmin,
      this.selectedStatus});

  ITServiceDetailLoadSuccess copyWith(
      {String? irsNo,
      ITServiceDetailResponse? itServiceDetailResponse,
      List<StdCode>? listItService,
      List<StdCode>? listSVC,
      List<StdCode>? listSrStatus,
      List<ITAdminResponse>? listITAdmin,
      StdCode? selectedStatus}) {
    return ITServiceDetailLoadSuccess(
      irsNo: irsNo ?? this.irsNo,
      itServiceDetailResponse:
          itServiceDetailResponse ?? this.itServiceDetailResponse,
      listItService: listItService ?? this.listItService,
      listSVC: listSVC ?? this.listSVC,
      listSrStatus: listSrStatus ?? this.listSrStatus,
      listITAdmin: listITAdmin ?? this.listITAdmin,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [
        irsNo,
        itServiceDetailResponse,
        listItService,
        listSVC,
        listSrStatus,
        listITAdmin,
        selectedStatus
      ];
}

class ITServiceDetailFailure extends ITServiceDetailState {
  final String? irsNo;
  final String message;
  final int? errorCode;
  const ITServiceDetailFailure(
      {this.irsNo, required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode, irsNo];
}
