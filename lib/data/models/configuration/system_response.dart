class ConfigSystemResponse {
  String? address;
  String? administratoremailaddress;
  String? alertandnotifyemail;
  String? boardisactive;
  String? datetimeformat;
  String? defaultcurrency;
  String? empcodepre;
  String? fax;
  String? hotline;
  String? inactivemessage;
  String? systemname;
  String? workingday;

  ConfigSystemResponse({
    this.address,
    this.administratoremailaddress,
    this.alertandnotifyemail,
    this.boardisactive,
    this.datetimeformat,
    this.defaultcurrency,
    this.empcodepre,
    this.fax,
    this.hotline,
    this.inactivemessage,
    this.systemname,
    this.workingday,
  });

  factory ConfigSystemResponse.fromJson(Map<String, dynamic> json) =>
      ConfigSystemResponse(
        address: json["address"],
        administratoremailaddress: json["administratoremailaddress"],
        alertandnotifyemail: json["alertandnotifyemail"],
        boardisactive: json["boardisactive"],
        datetimeformat: json["datetimeformat"],
        defaultcurrency: json["defaultcurrency"],
        empcodepre: json["empcodepre"],
        fax: json["fax"],
        hotline: json["hotline"],
        inactivemessage: json["inactivemessage"],
        systemname: json["systemname"],
        workingday: json["workingday"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "administratoremailaddress": administratoremailaddress,
        "alertandnotifyemail": alertandnotifyemail,
        "boardisactive": boardisactive,
        "datetimeformat": datetimeformat,
        "defaultcurrency": defaultcurrency,
        "empcodepre": empcodepre,
        "fax": fax,
        "hotline": hotline,
        "inactivemessage": inactivemessage,
        "systemname": systemname,
        "workingday": workingday,
      };
}
