class StripePaymentMaster {
  bool? success;
  String? message;
  String? checkoutUrl;
  int? orderCode;

  StripePaymentMaster(
      {this.success, this.message, this.checkoutUrl, this.orderCode});

  StripePaymentMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    checkoutUrl = json['checkoutUrl'];
    orderCode = json['orderCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['checkoutUrl'] = this.checkoutUrl;
    data['orderCode'] = this.orderCode;
    return data;
  }
}
