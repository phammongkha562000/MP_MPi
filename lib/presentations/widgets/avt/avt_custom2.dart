import 'dart:io';

// import 'package:avatar_glow/avatar_glow.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/presentations.dart';

import '../../common/common.dart';

class AvatarCustom2 extends StatelessWidget {
  final String imageUrl;
  final double? size;
  final String fullName;

  const AvatarCustom2({
    super.key,
    required this.imageUrl,
    required this.fullName,
    this.size,
  });

  Widget _buildDefaultAvatar() {
    String firstNameInitial = "";
    String lastNameInitial = "";

    var check = fullName.contains(" ");
    if (check == true) {
      List<String> nameParts = fullName.split(" ");
      firstNameInitial = nameParts[0].substring(0, 1);
      lastNameInitial = nameParts[nameParts.length - 1].substring(0, 1);
    } else {
      firstNameInitial = fullName.substring(0, 1);
      lastNameInitial = fullName.substring(1, 2);
    }
    return Material(
      elevation: 8.0,
      shape: const CircleBorder(),
      child: CircleAvatar(
        backgroundColor: MyColor.outerSpace,
        radius: size ?? 50.0,
        child: Text(
          "$firstNameInitial$lastNameInitial".toUpperCase(),
          style: TextStyle(
            fontSize: size ?? 40.0,
            fontWeight: FontWeight.bold,
            color: MyColor.defaultColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkAvatar() {
    return /* AvatarGlow(
      endRadius: size ?? 50.0,
      glowColor: MyColor.defaultColor,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: const Duration(milliseconds: 100),
      child: */
        Material(
      shape: const CircleBorder(),
      child: CircleAvatar(
        backgroundColor: Colors.grey[100],
        backgroundImage: NetworkImage(
          imageUrl,
        ),
        radius: size ?? 50.0,
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isImage(url: imageUrl, sv: ""),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError || !(snapshot.data ?? false)) {
          return _buildDefaultAvatar();
        } else {
          return _buildNetworkAvatar();
        }
      },
    );
  }
}

Future<bool> isImage({
  required String url,
  required String sv,
}) async {
  try {
    var newUrl = url.replaceAll("\\", "/");
    final dio = Dio();

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    final response = await dio.head(
      newUrl,
    );

    final headers = response.headers.map;
    final contentType = headers['content-type']?.first;
    if (contentType?.startsWith('image/') == true) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
