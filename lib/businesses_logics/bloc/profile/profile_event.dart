part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileViewLoaded extends ProfileEvent {
  final AppBloc appBloc;
  final int typeUpdate;
  // * typeUpdate = 1 là mặc định, = 2 là khi upload hình
  const ProfileViewLoaded({required this.typeUpdate, required this.appBloc});
  @override
  List<Object?> get props => [typeUpdate, appBloc];
}

class ProfileUploadAvt extends ProfileEvent {
  final String? pathImgChoose;
  final AppBloc appBloc;
  const ProfileUploadAvt({this.pathImgChoose, required this.appBloc});
  @override
  List<Object?> get props => [pathImgChoose, appBloc];
}

class BiometricChanged extends ProfileEvent {
  final bool isAllowBiometric;
  const BiometricChanged({
    required this.isAllowBiometric,
  });
  @override
  List<Object?> get props => [isAllowBiometric];
}
