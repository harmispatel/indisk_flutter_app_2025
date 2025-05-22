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
  String? ownerId;
  String? email;
  String? password;
  String? phone;
  String? name;
  String? address;
  String? image;
  String? status;
  String? description;
  String? location;
  String? cuisineType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RestaurantData(
      {this.sId,
      this.ownerId,
      this.email,
      this.password,
      this.phone,
      this.name,
      this.address,
      this.image,
      this.status,
      this.description,
      this.location,
      this.cuisineType,
      this.createdAt,
      this.updatedAt,
      this.iV});

  RestaurantData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ownerId = json['owner_id'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    status = json['status'];
    description = json['description'];
    location = json['location'];
    cuisineType = json['cuisine_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['owner_id'] = this.ownerId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['address'] = this.address;
    data['image'] = this.image;
    data['status'] = this.status;
    data['description'] = this.description;
    data['location'] = this.location;
    data['cuisine_type'] = this.cuisineType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
