class RestaurantMaster {
  String? message;
  bool? success;
  List<RestaurantData>? data;

  RestaurantMaster({this.message, this.success, this.data});

  RestaurantMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <RestaurantData>[];
      json['data'].forEach((v) {
        data!.add(new RestaurantData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantData {
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

  RestaurantData(
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

  RestaurantData.fromJson(Map<String, dynamic> json) {
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
