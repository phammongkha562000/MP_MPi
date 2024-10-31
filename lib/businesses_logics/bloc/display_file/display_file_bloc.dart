import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/files/file_config.dart';
import '../../../data/data.dart';
import '../../config/server_config.dart';

part 'display_file_event.dart';
part 'display_file_state.dart';

class DisplayFileBloc extends Bloc<DisplayFileEvent, DisplayFileState> {
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();

  DisplayFileBloc() : super(DisplayFileInitial()) {
    on<DisplayFileViewLoaded>(_mapViewLoadedToState);
    on<DisplayFileDownload>(_mapDownloadToState);
  }
  Future<void> _mapViewLoadedToState(DisplayFileViewLoaded event, emit) async {
    try {
      final List<FileDocumentResponse> fileList = [];
      for (var element in event.fileList) {
        final apiResult = await _serviceRequestRepo.getServiceDocument(
            docNo: element.docNo ?? 0);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(DisplayFileFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        fileList.add(apiResponse.payload);
      }

      emit(DisplayFileSuccess(fileList: fileList));
    } catch (e) {
      emit(const DisplayFileFailure(message: MyError.messError));
    }
  }

  void _mapDownloadToState(DisplayFileDownload event, emit) async {
    try {
      final currentState = state;
      if (currentState is DisplayFileSuccess) {
        final sharedPref = await SharedPreferencesService.instance;
        ServerInfo serverInfo =
            await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
        String startUrl = serverInfo.serverUpload.toString();

        String defaultFolder = "D:\\LE\\INTRANET\\MPIS\\";

        final filePath = event.file.filePath ?? '';
        final newLink = "$startUrl${filePath.split(defaultFolder).last}"
            .replaceAll("\\", "/");

        String fileName = newLink.split("/").last;
        final down = await isDownloadFile(pathNew: newLink, fileName: fileName);

        if (down == true) {
          var fileLocation = "";
          fileLocation = await getPathFile(fileName: fileName);
          emit(DisplayFileDownloadSuccess(
            fileLocation: fileLocation,
            fileType: checkFileType(newLink),
          ));
        } else {
          emit(
            const DisplayFileFailure(
              message: "Download File Error",
              errorCode: 1007,
            ),
          );
        }
        emit(currentState);
      }
    } catch (e) {
      DisplayFileFailure(message: e.toString());
    }
  }
}
