class CommonMaster {
  final bool success;
  final String message;

  CommonMaster({this.success = false, this.message = ''});

  factory CommonMaster.fromJson(Map<String, dynamic> json) {
    return CommonMaster(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
    );
  }
}