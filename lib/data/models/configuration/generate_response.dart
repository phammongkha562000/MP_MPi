class ConfigGenerateResponse {
  String? colortheme;
  String? floatlogo;
  String? loginbG1;
  String? loginbG2;
  String? loginbG3;
  String? loginlogo;
  String? norfontclor;
  String? norframfontcolor;
  String? ownerlogo;
  String? showfloatlogo;
  String? systemlogo;

  ConfigGenerateResponse({
    this.colortheme,
    this.floatlogo,
    this.loginbG1,
    this.loginbG2,
    this.loginbG3,
    this.loginlogo,
    this.norfontclor,
    this.norframfontcolor,
    this.ownerlogo,
    this.showfloatlogo,
    this.systemlogo,
  });

  factory ConfigGenerateResponse.fromJson(Map<String, dynamic> json) =>
      ConfigGenerateResponse(
        colortheme: json["colortheme"],
        floatlogo: json["floatlogo"],
        loginbG1: json["loginbG1"],
        loginbG2: json["loginbG2"],
        loginbG3: json["loginbG3"],
        loginlogo: json["loginlogo"],
        norfontclor: json["norfontclor"],
        norframfontcolor: json["norframfontcolor"],
        ownerlogo: json["ownerlogo"],
        showfloatlogo: json["showfloatlogo"],
        systemlogo: json["systemlogo"],
      );
}

class ColorThemeResponse {
  int? currentTheme;
  List<ThemeItem>? themes;

  ColorThemeResponse({
    this.currentTheme,
    this.themes,
  });

  factory ColorThemeResponse.fromJson(Map<String, dynamic> json) =>
      ColorThemeResponse(
        currentTheme: json["current-theme"],
        themes: json["themes"] == null
            ? []
            : List<ThemeItem>.from(
                json["themes"]!.map((x) => ThemeItem.fromJson(x))),
      );
}

class ThemeItem {
  int? id;
  String? name;
  String? hex;
  String? frameFontColor;
  String? normalFontColor;
  String? primaryColor;
  String? secondaryColor;
  String? backgroundPanel;
  String? colorPanel;
  ThemeItem({
    this.id,
    this.name,
    this.hex,
    this.frameFontColor,
    this.normalFontColor,
    this.primaryColor,
    this.secondaryColor,
    this.backgroundPanel,
    this.colorPanel,
  });

  factory ThemeItem.fromJson(Map<String, dynamic> json) => ThemeItem(
        id: json["id"],
        name: json["name"],
        hex: json["hex"],
        frameFontColor: json["frame-font-color"],
        normalFontColor: json["normal-font-color"],
        primaryColor: json["primaryColor"],
        secondaryColor: json["secondaryColor"],
        backgroundPanel: json["backgroundPanel"],
        colorPanel: json["colorPanel"],
      );
}
