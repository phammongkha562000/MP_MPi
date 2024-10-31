part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final UserInfo userInfo;
  final SubsidiaryInfo subsidiaryInfo;
  final String avt;
  final String? serverMode;
  final bool isAllowBiometric;
  final bool isBiometric;

  const ProfileLoadSuccess(
      {required this.userInfo,
      required this.subsidiaryInfo,
      required this.avt,
      this.serverMode,
      required this.isAllowBiometric,
      required this.isBiometric});

  @override
  List<Object?> get props => [
        userInfo,
        avt,
        serverMode,
        subsidiaryInfo,
        isAllowBiometric,
        isBiometric
      ];

  ProfileLoadSuccess copyWith(
      {UserInfo? userInfo,
      SubsidiaryInfo? subsidiaryInfo,
      String? avt,
      String? serverMode,
      bool? isAllowBiometric,
      bool? isBiometric}) {
    return ProfileLoadSuccess(
        userInfo: userInfo ?? this.userInfo,
        subsidiaryInfo: subsidiaryInfo ?? this.subsidiaryInfo,
        avt: avt ?? this.avt,
        serverMode: serverMode ?? this.serverMode,
        isAllowBiometric: isAllowBiometric ?? this.isAllowBiometric,
        isBiometric: isBiometric ?? this.isBiometric);
  }
}

class ProfileFailure extends ProfileState {
  final String message;
  final int? errorCode;
  final String? serverMode;
  const ProfileFailure(
      {required this.message, this.errorCode, this.serverMode});
  @override
  List<Object?> get props => [message, errorCode, serverMode];
}

class ProfileUpdateAvtSuccessfully extends ProfileState {}
