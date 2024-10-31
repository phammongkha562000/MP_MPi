// class MenuChild {
//   MenuChild({
//     this.menuId,
//     this.menuName,
//     this.pageId,
//     this.seqNo,
//     this.isGroup,
//     this.prerentsMenu,
//     this.del,
//     this.excel,
//     this.payloadNew,
//     this.preview,
//     this.sav,
//     this.systemId,
//     this.icon,
//     this.tid,
//     this.component,
//     this.language,
//     this.menuChils,
//   });

//   String? menuId;
//   String? menuName;
//   String? pageId;
//   // dynamic seqNo;
//   // String? isGroup;
//   // String? prerentsMenu;
//   // bool? del;
//   // bool? excel;
//   // bool? payloadNew;
//   // bool? preview;
//   // bool? sav;
//   // String? systemId;
//   // String? icon;
//   // dynamic tid;
//   // String? component;
//   // String? language;
//   // List<MenuChild>? menuChils;

//   factory MenuChild.fromMap(Map<String, dynamic> json) => MenuChild(
//         menuId: json["menuId"],
//         menuName: json["menuName"],
//         pageId: json["pageId"],
//         seqNo: json["seqNo"],
//         isGroup: json["isGroup"],
//         prerentsMenu: json["prerentsMenu"],
//         del: json["del"],
//         excel: json["excel"],
//         payloadNew: json["new"],
//         preview: json["preview"],
//         sav: json["sav"],
//         systemId: json["systemId"],
//         icon: json["icon"],
//         tid: json["tid"],
//         component: json["component"],
//         language: json["language"],
//         menuChils: List<MenuChild>.from(
//             json["menuChils"].map((x) => MenuChild.fromMap(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "menuId": menuId,
//         "menuName": menuName,
//         "pageId": pageId,
//         "seqNo": seqNo,
//         "isGroup": isGroup,
//         "prerentsMenu": prerentsMenu,
//         "del": del,
//         "excel": excel,
//         "new": payloadNew,
//         "preview": preview,
//         "sav": sav,
//         "systemId": systemId,
//         "icon": icon,
//         "tid": tid,
//         "component": component,
//         "language": language,
//         "menuChils": List<dynamic>.from(menuChils!.map((x) => x.toJson())),
//       };
// }
