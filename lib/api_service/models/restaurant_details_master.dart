class RestaurantDetailsMaster {
  String? message;
  bool? success;
  RestaurantDetailsData? data;

  RestaurantDetailsMaster({this.message, this.success, this.data});

  RestaurantDetailsMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? new RestaurantDetailsData.fromJson(json['data']) : null;
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

class RestaurantDetailsData {
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
  List<RestaurantCategories>? categories;
  List<RestaurantFoods>? foods;
  List<RestaurantStaff>? staff;
  RestaurantManager? manager;

  RestaurantDetailsData(
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
        this.iV,
        this.categories,
        this.foods,
        this.staff,
        this.manager});

  RestaurantDetailsData.fromJson(Map<String, dynamic> json) {
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
    if (json['categories'] != null) {
      categories = <RestaurantCategories>[];
      json['categories'].forEach((v) {
        categories!.add(new RestaurantCategories.fromJson(v));
      });
    }
    if (json['foods'] != null) {
      foods = <RestaurantFoods>[];
      json['foods'].forEach((v) {
        foods!.add(new RestaurantFoods.fromJson(v));
      });
    }
    if (json['staff'] != null) {
      staff = <RestaurantStaff>[];
      json['staff'].forEach((v) {
        staff!.add(new RestaurantStaff.fromJson(v));
      });
    }
    manager =
    json['manager'] != null ? new RestaurantManager.fromJson(json['manager']) : null;
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
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.foods != null) {
      data['foods'] = this.foods!.map((v) => v.toJson()).toList();
    }
    if (this.staff != null) {
      data['staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    if (this.manager != null) {
      data['manager'] = this.manager!.toJson();
    }
    return data;
  }
}

class RestaurantCategories {
  String? sId;
  String? name;
  String? restaurantId;

  RestaurantCategories({this.sId, this.name, this.restaurantId});

  RestaurantCategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}

class RestaurantFoods {
  String? sId;
  String? name;
  double? price;
  String? categoryId;
  String? restaurantId;
  String? image;

  RestaurantFoods({this.sId, this.name, this.price, this.categoryId, this.restaurantId,this.image});

  RestaurantFoods.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    categoryId = json['category_id'];
    restaurantId = json['restaurant_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['category_id'] = this.categoryId;
    data['restaurant_id'] = this.restaurantId;
    data['image'] = this.image;
    return data;
  }
}

class RestaurantStaff {
  String? sId;
  String? name;
  String? role;
  String? restaurantId;

  RestaurantStaff({this.sId, this.name, this.role, this.restaurantId});

  RestaurantStaff.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    role = json['role'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['role'] = this.role;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}

class RestaurantManager {
  String? sId;
  String? name;
  String? email;
  String? role;

  RestaurantManager({this.sId, this.name, this.email, this.role});

  RestaurantManager.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}
