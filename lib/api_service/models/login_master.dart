class LoginMaster {
  String? message;
  bool? success;
  LoginDetails? data;

  RestaurantDetails? restaurantDetails;


  LoginMaster({this.message, this.success, this.data});

  LoginMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? new LoginDetails.fromJson(json['data']) : null;
    restaurantDetails = json['restaurant_details'] != null
        ? new RestaurantDetails.fromJson(json['restaurant_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.restaurantDetails != null) {
      data['restaurant_details'] = this.restaurantDetails!.toJson();
    }
    return data;
  }
}

class LoginDetails {
  String? sId;
  String? username;
  String? email;
  String? password;
  String? role;
  int? phone;
  String? createdAt;
  int? iV;

  LoginDetails(
      {this.sId,
        this.username,
        this.email,
        this.password,
        this.role,
        this.phone,
        this.createdAt,
        this.iV});

  LoginDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    phone = json['phone'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class RestaurantDetails {
  String? sId;
  String? userId;
  String? restaurantName;
  String? email;
  int? contact;
  String? logo;
  String? description;
  String? tagLine;
  String? isActive;
  String? websiteLink;
  int? iV;

  RestaurantDetails(
      {this.sId,
        this.userId,
        this.restaurantName,
        this.email,
        this.contact,
        this.logo,
        this.description,
        this.tagLine,
        this.isActive,
        this.websiteLink,
        this.iV});

  RestaurantDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    restaurantName = json['restaurant_name'];
    email = json['email'];
    contact = json['contact'];
    logo = json['logo'];
    description = json['description'];
    tagLine = json['tagLine'];
    isActive = json['isActive'];
    websiteLink = json['website_link'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['restaurant_name'] = this.restaurantName;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['logo'] = this.logo;
    data['description'] = this.description;
    data['tagLine'] = this.tagLine;
    data['isActive'] = this.isActive;
    data['website_link'] = this.websiteLink;
    data['__v'] = this.iV;
    return data;
  }
}




