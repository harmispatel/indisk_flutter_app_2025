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
  String? username;
  String? phone;
  String? email;
  String? password;
  String? image;
  String? isBlocked;
  int? role;
  String? createdAt;
  int? iV;
  String? roleName;

  StaffListDetails(
      {this.sId,
        this.name,
        this.username,
        this.phone,
        this.email,
        this.password,
        this.image,
        this.isBlocked,
        this.role,
        this.createdAt,
        this.iV,
        this.roleName});

  StaffListDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    isBlocked = json['is_blocked'];
    role = json['role'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['is_blocked'] = this.isBlocked;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['role_name'] = this.roleName;
    return data;
  }
}