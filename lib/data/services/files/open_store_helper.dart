import 'package:mpi_new/presentations/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenStoreHelper {
  static Future openWordWithCHPlay() async {
    launchUrl(
      Uri.parse(MyConstants.urlGGWord),
      mode: LaunchMode.externalApplication,
    );
  }

  static Future openExcelWithCHPlay() async {
    launchUrl(
      Uri.parse(MyConstants.urlGGExcel),
      mode: LaunchMode.externalApplication,
    );
  }

  static Future openCHPlay() async {
    launchUrl(
      Uri.parse(MyConstants.urlCHPlay),
      mode: LaunchMode.externalApplication,
    );
  }
}
