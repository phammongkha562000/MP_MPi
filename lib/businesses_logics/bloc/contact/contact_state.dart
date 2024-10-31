part of 'contact_bloc.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

final class ContactInitial extends ContactState {}

final class ContactLoading extends ContactState {}

final class ContactSuccess extends ContactState {
  final SubsidiaryRes subsidiaryRes;

  const ContactSuccess({required this.subsidiaryRes});
  @override
  List<Object?> get props => [subsidiaryRes];
}

final class ContactFailure extends ContactState {
  final int? errorCode;
  final String message;

  const ContactFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}
