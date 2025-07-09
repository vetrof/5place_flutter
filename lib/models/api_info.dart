class ApiInfo {
  final String message;
  final String version;
  final String swagger;

  ApiInfo({required this.message, required this.version, required this.swagger});

  factory ApiInfo.fromJson(Map<String, dynamic> json) {
    return ApiInfo(
      message: json['message'],
      version: json['version'],
      swagger: json['swagger'],
    );
  }
}
