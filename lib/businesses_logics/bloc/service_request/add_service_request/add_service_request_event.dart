part of 'add_service_request_bloc.dart';

abstract class AddServiceRequestEvent extends Equatable {
  const AddServiceRequestEvent();

  @override
  List<Object> get props => [];
}

class AddServiceRequestViewLoaded extends AddServiceRequestEvent {
  final AppBloc appBloc;
  const AddServiceRequestViewLoaded({required this.appBloc});
  @override
  List<Object> get props => [appBloc];
}

class AddServiceRequestWorkFlow extends AddServiceRequestEvent {
  final String applicationCode;
  final String localAmount;
  final AppBloc appBloc;

  const AddServiceRequestWorkFlow(
      {required this.applicationCode,
      required this.localAmount,
      required this.appBloc});
  @override
  List<Object> get props => [applicationCode, localAmount, appBloc];
}

class AddServiceRequestSave extends AddServiceRequestEvent {
  final AppBloc appBloc;

  final String svrSubject;
  final String svrServiceType;
  final String requiredDetail;
  final String proiority;
  final String svrStatus;
  final String dueDate;
  final String hasBudget;
  final String localDocAmount;
  final String usdDocAmount;
  final String remark;
  final String thirdParty;
  final String refDocumentNo;
  final String relatedDivision;
  final List<FileInfo> attachmentList;
  const AddServiceRequestSave(
      {required this.hasBudget,
      required this.svrSubject,
      required this.appBloc,
      required this.svrServiceType,
      required this.requiredDetail,
      required this.proiority,
      required this.svrStatus,
      required this.dueDate,
      required this.localDocAmount,
      required this.usdDocAmount,
      required this.remark,
      required this.thirdParty,
      required this.refDocumentNo,
      required this.relatedDivision,
      required this.attachmentList});
  @override
  List<Object> get props => [
        appBloc,
        hasBudget,
        svrSubject,
        svrServiceType,
        requiredDetail,
        proiority,
        svrStatus,
        dueDate,
        localDocAmount,
        usdDocAmount,
        remark,
        thirdParty,
        refDocumentNo,
        relatedDivision,
        attachmentList
      ];
}
