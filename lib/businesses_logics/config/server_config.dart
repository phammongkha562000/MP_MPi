// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:mpi_new/data/models/server/server_info.dart';

class ServerConfig {
  static getAddressServerInfo(_server) {
    final ServerInfo server = ServerInfo();
    switch (_server) {
      case "DEV":
        server.sso = "https://dev.igls.vn:9110/";
        server.serverHub = "https://dev.igls.vn:8079/";
        server.serverUpload = 'https://dev.mpi.mplogistics.vn:9099/uploads/';
        break;

      case "PROD":
        server.sso = "https://mpi.mplogistics.vn:8187/";
        server.serverHub = "https://pro.igls.vn:8182/";
        server.serverUpload = 'https://mpi.mplogistics.vn/uploads/';
        break;
      case "QA": //add 14/09/2023
        server.sso = "https://qa.igls.vn:9112/";
        server.serverHub = "https://qa.igls.vn:8178/";
        server.serverUpload = 'https://qa.mpi.mplogistics.vn:8088/uploads';
        break;
    }
    return server;
  }
}
