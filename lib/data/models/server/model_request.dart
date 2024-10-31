import 'package:mpi_new/data/data.dart';

class ModelRequest extends AbstractHttpRequest {
  ModelRequest(String path,
      {Map<String, dynamic>? parameters,
      Map<String, dynamic>? body,
      Map<String, dynamic>? header})
      : super(
          path,
          parameters: parameters,
          body: body,
          header: header ??
              {
                "Content-Type": 'application/json',
                "Authorization": 'Bearer ${globalServer.getToken}'
              },
        );
}
