part of 'it_service_bloc.dart';

abstract class ITServiceState extends Equatable {
  const ITServiceState();

  @override
  List<Object?> get props => [];
}

class ITServiceInitial extends ITServiceState {}

class ITServiceLoading extends ITServiceState {}

class ITServicePagingLoading extends ITServiceState {}

class ITServiceLoadSuccess extends ITServiceState {
  final DateTime dateF;
  final DateTime dateT;

  final List<StdCode>? listItService;
  final List<StdCode>? listSVC;
  final List<StdCode>? listSrStatus;
  final List<StdCode>? listPriority;
  final List<ITServiceResult> listITServiceSearch;
  final int quantity;
  const ITServiceLoadSuccess(
      {required this.dateF,
      required this.dateT,
      this.listItService,
      this.listSVC,
      this.listSrStatus,
      this.listPriority,
      required this.listITServiceSearch,
      required this.quantity});
  @override
  List<Object?> get props => [
        listItService,
        listSVC,
        listSrStatus,
        listPriority,
        listITServiceSearch,
        quantity
      ];

  ITServiceLoadSuccess copyWith(
      {DateTime? dateF,
      DateTime? dateT,
      List<StdCode>? listItService,
      List<StdCode>? listSVC,
      List<StdCode>? listSrStatus,
      List<StdCode>? listPriority,
      List<ITServiceResult>? listITServiceSearch,
      int? quantity}) {
    return ITServiceLoadSuccess(
      dateF: dateF ?? this.dateF,
      dateT: dateT ?? this.dateT,
      listItService: listItService ?? this.listItService,
      listSVC: listSVC ?? this.listSVC,
      listSrStatus: listSrStatus ?? this.listSrStatus,
      listPriority: listPriority ?? this.listPriority,
      listITServiceSearch: listITServiceSearch ?? this.listITServiceSearch,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ITServiceFailure extends ITServiceState {
  final String message;
  final int? errorCode;
  const ITServiceFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}

class ITServiceSearchSuccess extends ITServiceState {
  final List<ITServiceResult> listITServiceSearch;
  final int quantity;
  final DateTime dateF;
  final DateTime dateT;

  const ITServiceSearchSuccess({
    required this.listITServiceSearch,
    required this.quantity,
    required this.dateF,
    required this.dateT,
  });
  @override
  List<Object?> get props => [listITServiceSearch, quantity];
}
