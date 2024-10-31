import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/presentations.dart';

import '../../common/common.dart';

class AvtCustom extends StatelessWidget {
  final String linkAvt;
  final String fullName;
  final double? size;
  const AvtCustom({
    Key? key,
    required this.linkAvt,
    required this.fullName,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color foregroundColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;

    String firstNameInitial = "";
    String lastNameInitial = "";
    String defaultName = "User Name";
    var check = fullName.contains(" ");
    if (check == true) {
      List<String> nameParts = fullName.trim().split(" ");
      firstNameInitial = nameParts[0].substring(0, 1);
      lastNameInitial = nameParts[nameParts.length - 1].substring(0, 1);
    } else if (fullName.trim().isEmpty) {
      firstNameInitial = defaultName.substring(0, 1);
      lastNameInitial = defaultName.substring(1, 2);
    } else {
      firstNameInitial = fullName.trim().substring(0, 1);
      lastNameInitial = fullName.substring(1, 2);
    }

    return linkAvt == ""
        ? Container(
            width: size ?? 70.0,
            height: size ?? 70.0,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: Text(
              "$firstNameInitial$lastNameInitial".toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                  fontSize: 40),
            ),
          )
        : /* Container(
            width: size ?? 70.0,
            height: size ?? 70.0,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: Text(
              "$firstNameInitial$lastNameInitial".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
          ); */
        CachedNetworkImage(
            placeholder: (context, url) => Container(
              width: size ?? 70.0,
              height: size ?? 70.0,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: primaryColor),
              child: Text(
                "$firstNameInitial$lastNameInitial".toUpperCase(),
                style: TextStyle(
                  fontSize: size != null ? size! / 3 : 40,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: size ?? 70.0,
              height: size ?? 70.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: MyColor.outerSpace),
              child: Text(
                "$firstNameInitial$lastNameInitial".toUpperCase(),
                style: TextStyle(
                  fontSize: size != null ? size! / 3 : 40,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
            ),
            imageBuilder: (context, imageProvider) => Container(
              width: size ?? 70.0,
              height: size ?? 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            imageUrl: linkAvt,
            fit: BoxFit.fill,
          );
  }
}
