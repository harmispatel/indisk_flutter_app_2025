class VatMaster {
  bool? success;
  String? message;
  VatData? data;

  VatMaster({this.success, this.message, this.data});

  VatMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new VatData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VatData {
  String? sId;
  String? userId;
  String? restaurantId;
  String? assignedBy;
  String? assignedAt;
  int? vat;
  int? iV;

  VatData(
      {this.sId,
        this.userId,
        this.restaurantId,
        this.assignedBy,
        this.assignedAt,
        this.vat,
        this.iV});

  VatData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    restaurantId = json['restaurant_id'];
    assignedBy = json['assigned_by'];
    assignedAt = json['assigned_at'];
    vat = json['vat'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['restaurant_id'] = this.restaurantId;
    data['assigned_by'] = this.assignedBy;
    data['assigned_at'] = this.assignedAt;
    data['vat'] = this.vat;
    data['__v'] = this.iV;
    return data;
  }
}
