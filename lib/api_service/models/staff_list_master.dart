class StaffListMaster {
  bool? success;
  String? message;
  List<StaffListDetails>? data;

  StaffListMaster({this.success, this.message, this.data});

  StaffListMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StaffListDetails>[];
      json['data'].forEach((v) {
        data!.add(new StaffListDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffListDetails {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? gender;
  String? profilePicture;
  String? address;
  String? managerId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  StaffListDetails(
      {this.sId,
        this.name,
        this.email,
        this.password,
        this.phone,
        this.gender,
        this.profilePicture,
        this.address,
        this.managerId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  StaffListDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    gender = json['gender'];
    profilePicture = json['profile_picture'];
    address = json['address'];
    managerId = json['manager_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['profile_picture'] = this.profilePicture;
    data['address'] = this.address;
    data['manager_id'] = this.managerId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
