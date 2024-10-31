class SubsidiaryRes {
  String? subsidiaryId;
  String? subsidiaryName;
  String? address1;
  String? address2;
  String? address3;
  String? zipCode;
  String? tel;
  String? fax;
  String? companyCode;
  String? isUse;
  String? countryId;
  dynamic province;
  dynamic city;
  String? currency;
  String? sDateFormat;
  String? www;
  String? taxCode;

  SubsidiaryRes(
      {this.subsidiaryId,
      this.subsidiaryName,
      this.address1,
      this.address2,
      this.address3,
      this.zipCode,
      this.tel,
      this.fax,
      this.companyCode,
      this.isUse,
      this.countryId,
      this.province,
      this.city,
      this.currency,
      this.sDateFormat,
      this.www,
      this.taxCode});

  factory SubsidiaryRes.fromJson(Map<String, dynamic> json) => SubsidiaryRes(
      subsidiaryId: json["subsidiaryId"],
      subsidiaryName: json["subsidiaryName"],
      address1: json["address1"],
      address2: json["address2"],
      address3: json["address3"],
      zipCode: json["zipCode"],
      tel: json["tel"],
      fax: json["fax"],
      companyCode: json["companyCode"],
      isUse: json["isUse"],
      countryId: json["countryId"],
      province: json["province"],
      city: json["city"],
      currency: json["currency"],
      sDateFormat: json["sDateFormat"],
      www: json["www"],
      taxCode: json["taxCode"]);
}
