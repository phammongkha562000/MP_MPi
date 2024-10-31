class GalleryResponse {
  GalleryResponse({this.small, this.medium, this.big, this.description});

  String? small;
  String? medium;
  String? big;
  String? description;

  factory GalleryResponse.fromJson(Map<String, dynamic> json) =>
      GalleryResponse(
          small: json["small"],
          medium: json["medium"],
          big: json["big"],
          description: json["description"]);
}
