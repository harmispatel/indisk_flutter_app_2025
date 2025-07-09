class CommonMaster {
  final bool success;
  final String message;
  final String? orderId;
  CommonMaster({this.success = false, this.message = '',this.orderId,});

  factory CommonMaster.fromJson(Map<String, dynamic> json) {
    return CommonMaster(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      orderId: json['order']?['_id']?.toString(),
    );
  }
}