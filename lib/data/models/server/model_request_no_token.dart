import 'package:mpi_new/data/data.dart';

class ModelRequestNoToken extends AbstractHttpRequest {
  ModelRequestNoToken(String path,
      {Map<String, dynamic>? parameters,
      Map<String, dynamic>? body,
      Map<String, dynamic>? header})
      : super(path, parameters: parameters, body: body);
}
