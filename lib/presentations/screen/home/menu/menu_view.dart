// import 'dart:developer';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// import '../../../../data/data.dart';

// class MenuView extends StatefulWidget {
//   const MenuView({
//     super.key,
//     required this.empName,
//     required this.listMenu,
//     required this.linkAvt,
//     required this.serverMode,
//   });
//   final String serverMode;
//   final String empName;
//   final List<MenuChild> listMenu;
//   final String linkAvt;

//   @override
//   State<MenuView> createState() => _MenuViewState();
// }

// class _MenuViewState extends State<MenuView> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: MyColor.bgDrawerColor,
//         height: MediaQuery.sizeOf(context).height,
//         child: Column(
//           children: [
//             HeaderMenu(
//               empName: widget.empName,
//               linkAvt: widget.linkAvt,
//               serverMode: widget.serverMode,
//             ),
//             Expanded(child: buildMenu()),
//             btnLogOut(serverMode: widget.serverMode),
//           ],
//         ),
//       ),
//     );
//   }

//   ListView buildMenu() {
//     return ListView(
//       padding: EdgeInsets.zero,
//       children: List.generate(
//         widget.listMenu.length,
//         (index) {
//           final item = widget.listMenu[index];
//           return ExpansionTile(
//             title: Text(
//               item.menuName.toString(),
//               style: const TextStyle(
//                 color: MyColor.textBlack,
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             children: [
//               for (final itemDetails in item.menuChils ?? [])
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: InkWell(
//                     onTap: () {
//                       log("pageId: ${itemDetails.component}");
//                       voidCallBack(context, path: "${itemDetails.component}");
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 4, horizontal: 8),
//                       decoration: const BoxDecoration(
//                         color: MyColor.textWhite,
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       child: ListTile(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 4),
//                         leading: IconCustom(
//                           iConURL: getImage(itemDetails.menuId.toString()),
//                           size: 25,
//                         ),
//                         title: Text(
//                           itemDetails.menuName.toString(),
//                           style: const TextStyle(
//                             color: MyColor.textBlack,
//                           ),
//                         ),
//                         trailing: const Icon(Icons.arrow_forward_ios_sharp,
//                             color: MyColor.textBlack, size: 20),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget btnLogOut({required String serverMode}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         margin: const EdgeInsets.symmetric(vertical: 16),
//         decoration: const BoxDecoration(
//           color: MyColor.textWhite,
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//         child: ListTile(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 4),
//           horizontalTitleGap: 1,
//           onTap: () {
//             _navigationService.pushNamedAndRemoveUntil(
//               MyRoute.loginViewRoute,
//               args: {
//                 KeyParams.loginServer: serverMode.toString(),
//                 KeyParams.isLogout: true
//               },
//             );
//           },
//           leading: const Icon(
//             Icons.logout,
//             color: MyColor.defaultColor,
//           ),
//           trailing: const Icon(Icons.arrow_forward_ios_sharp,
//               color: MyColor.textBlack, size: 20),
//           title: Text(
//             "log_out".tr(),
//             style: const TextStyle(
//               color: MyColor.textDarkBlue,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// voidCallBack(context, {required String path}) {
//   switch (path) {
//     case NavigatorWithPageId.profile:
//       _onNavigate(context, MyRoute.proFileRoute);
//       break;

//     default:
//       return MyDialog().showInfos(
//         context: context,
//         turnOffAutoHide: true,
//         pressOk: () {
//           Navigator.pop(context);
//         },
//         turnOffCancel: true,
//       );
//   }
// }

// final _navigationService = getIt<NavigationService>();

// void _onNavigate(BuildContext context, String routeName) {
//   switch (routeName) {
//     case MyRoute.proFileRoute:
//       _navigationService.pushNamed(routeName, args: {KeyParams.uploadImg: 1});
//       break;
//     case MyRoute.inboxRoute:
//       _navigationService.pushNamed(routeName);
//       break;

//     default:
//       throw Exception('Invalid route name');
//   }
// }
