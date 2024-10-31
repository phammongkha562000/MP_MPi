class TokenErrorResponse {
  String? error;
  String? errorDescription;

  TokenErrorResponse({this.error, this.errorDescription});

  factory TokenErrorResponse.fromJson(Map<String, dynamic> json) =>
      TokenErrorResponse(
          error: json["error"], errorDescription: json["error_description"]);
}
