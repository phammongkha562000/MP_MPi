part of 'it_service_detail_bloc.dart';

abstract class ITServiceDetailEvent extends Equatable {
  const ITServiceDetailEvent();

  @override
  List<Object?> get props => [];
}

class ITServiceDetailLoaded extends ITServiceDetailEvent {
  final String irsNo;
  final AppBloc appBloc;
  const ITServiceDetailLoaded({required this.irsNo, required this.appBloc});
  @override
  List<Object> get props => [irsNo, appBloc];
}

class ITServiceDetailChangeAssign extends ITServiceDetailEvent {
  final String irsNo;
  final bool? isSelected;
  final int? itAdmin;
  const ITServiceDetailChangeAssign(
      {required this.irsNo, this.isSelected, this.itAdmin});
  @override
  List<Object?> get props => [
        isSelected,
        irsNo,
        itAdmin,
      ];
}

class ITServiceDetailChooseStatus extends ITServiceDetailEvent {
  final String irsNo;
  final StdCode? stdSelected;
  const ITServiceDetailChooseStatus({required this.irsNo, this.stdSelected});
  @override
  List<Object?> get props => [irsNo, stdSelected];
}

class ITServiceDetailReply extends ITServiceDetailEvent {
  final String irsNo;
  final AppBloc appBloc;
  final String detailsChat;

  final String srStatus;
  const ITServiceDetailReply(
      {required this.irsNo,
      required this.detailsChat,
      required this.srStatus,
      required this.appBloc});
  @override
  List<Object?> get props => [detailsChat, srStatus, irsNo, appBloc];
}
