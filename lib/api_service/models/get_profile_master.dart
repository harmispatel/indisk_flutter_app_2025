class GetProfileMaster {
  String? message;
  bool? success;
  ProfileData? data;

  GetProfileMaster({this.message, this.success, this.data});

  GetProfileMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileData {
  String? sId;
  String? email;
  String? password;
  String? role;
  String? createdAt;
  int? iV;
  String? gender;
  String? image;
  String? username;

  ProfileData(
      {this.sId,
        this.email,
        this.password,
        this.role,
        this.createdAt,
        this.iV,
        this.gender,
        this.image,
        this.username});

  ProfileData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    gender = json['gender'];
    image = json['image'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['username'] = this.username;
    return data;
  }
}
