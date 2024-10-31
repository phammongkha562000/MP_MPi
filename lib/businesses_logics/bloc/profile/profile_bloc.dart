import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mpi_new/businesses_logics/api/endpoints.dart';

import '../../../data/data.dart';
import '../../application_bloc/app_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileViewLoaded>(_mapViewToState);
    on<ProfileUploadAvt>(_mapUpdateAvtToState);
    on<BiometricChanged>(_mapBiometricChangedToState);
  }

  Future<void> _mapViewToState(ProfileViewLoaded event, emit) async {
    try {
      emit(ProfileLoading());
      final UserInfo userInfo = event.appBloc.userInfo ?? UserInfo();
      final sharedPref = await SharedPreferencesService.instance;

      final SubsidiaryInfo subsidiaryInfo =
          event.appBloc.subsidiaryInfo ?? SubsidiaryInfo();

      final isAllowBiometric = sharedPref.isAllowBiometrics ?? false;
      final isBiometric = sharedPref.isBiometrics ?? false;

      emit(ProfileLoadSuccess(
          userInfo: userInfo,
          subsidiaryInfo: subsidiaryInfo,
          avt: event.appBloc.linkAvt ?? '',
          serverMode: sharedPref.serverMode.toString(),
          isAllowBiometric: isAllowBiometric,
          isBiometric: isBiometric));
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }

  Future<void> _mapUpdateAvtToState(ProfileUploadAvt event, emit) async {
    try {
      final currentState = state;
      final sharedPref = await SharedPreferencesService.instance;
      if (currentState is ProfileLoadSuccess) {
        emit(ProfileLoading());
        final UserInfo userInfo = event.appBloc.userInfo ?? UserInfo();

        File fileC = File(event.pathImgChoose.toString());
        final fileName = fileC.path.split('/').last;
        List<int> bytes = await fileC.readAsBytes();
        BaseOptions options = BaseOptions(
            headers: {'Authorization': 'Bearer ${globalServer.token}'},
            contentType: Headers.formUrlEncodedContentType);
        final dio = Dio(options);
        final formData = FormData.fromMap({
          'docRefType': 'PAT',
          'refNoType': 'PAT',
          'refNoValue': int.parse(globalUser.employeeId.toString()),
          'createUser': int.parse(globalUser.employeeId.toString()),
          'userId': int.parse(globalUser.employeeId.toString()),
          'systemId': MyConstants.systemID,
          'files': MultipartFile.fromBytes(bytes,
              filename: fileName, contentType: MediaType('image', 'jpg')),
        });
        try {
          final response = await dio.post(
              "${sharedPref.serverSSO}${Endpoint.uploadAvt}",
              data: formData);
          final updateImage = UpdateImgResponse.fromMap(response.data);
          if (updateImage.success == true) {
            var imageUrl = updateImage.payload.first.filePath.toString();
            UserInfo updateImg = userInfo.copyWith(avartarThumbnail: imageUrl);
            event.appBloc.userInfo = updateImg;
            UserInfo test = event.appBloc.userInfo ?? UserInfo();

            // final linkAvt = await ImageHelper.setAvatar(
            //     linkAvt: test.avartarThumbnail.toString(), //hardcode 239
            //     sv: sharedPref.serverMode.toString());
            final linkAvt = test.avartarThumbnail ?? '';
            event.appBloc.linkAvt = linkAvt;
            emit(currentState.copyWith(avt: linkAvt));

            emit(ProfileUpdateAvtSuccessfully());
          } else {
            emit(const ProfileFailure(message: "updatefailure"));
          }
        } catch (e) {
          emit(const ProfileFailure(message: "updatefailure"));
        }
      }
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }

  Future<void> _mapBiometricChangedToState(BiometricChanged event, emit) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoadSuccess) {
        final isAllowBiometric = event.isAllowBiometric;
        final sharedPref = await SharedPreferencesService.instance;
        sharedPref.setIsAllowBiometrics(isAllowBiometric);
        emit(currentState.copyWith(isAllowBiometric: isAllowBiometric));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
