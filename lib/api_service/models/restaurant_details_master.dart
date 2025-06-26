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
  RestaurantDetails? restaurantDetails;
  List<RestaurantCategories>? categories;
  List<RestaurantFoods>? foods;
  List<RestaurantStaff>? staff;
  List<RestaurantManager>? manager;

  RestaurantDetailsData(
      {this.restaurantDetails,
        this.categories,
        this.foods,
        this.staff,
        this.manager});

  RestaurantDetailsData.fromJson(Map<String, dynamic> json) {
    restaurantDetails = json['restaurantDetails'] != null
        ? new RestaurantDetails.fromJson(json['restaurantDetails'])
        : null;
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
    if (json['manager'] != null) {
      manager = <RestaurantManager>[];
      json['manager'].forEach((v) {
        manager!.add(new RestaurantManager.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurantDetails != null) {
      data['restaurantDetails'] = this.restaurantDetails!.toJson();
    }
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
      data['manager'] = this.manager!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantDetails {
  String? sId;
  String? ownerId;
  String? name;
  String? address;
  String? image;
  String? status;
  String? description;
  String? location;
  String? cuisineType;

  RestaurantDetails(
      {this.sId,
        this.ownerId,
        this.name,
        this.address,
        this.image,
        this.status,
        this.description,
        this.location,
        this.cuisineType});

  RestaurantDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ownerId = json['owner_id'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    status = json['status'];
    description = json['description'];
    location = json['location'];
    cuisineType = json['cuisine_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['owner_id'] = this.ownerId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['image'] = this.image;
    data['status'] = this.status;
    data['description'] = this.description;
    data['location'] = this.location;
    data['cuisine_type'] = this.cuisineType;
    return data;
  }
}

class RestaurantCategories {
  String? sId;
  String? name;
  String? description;
  String? managerId;
  String? restaurantId;
  String? imageUrl;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RestaurantCategories(
      {this.sId,
        this.name,
        this.description,
        this.managerId,
        this.restaurantId,
        this.imageUrl,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

  RestaurantCategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    managerId = json['manager_id'];
    restaurantId = json['restaurant_id'];
    imageUrl = json['image_url'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['manager_id'] = this.managerId;
    data['restaurant_id'] = this.restaurantId;
    data['image_url'] = this.imageUrl;
    data['is_active'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class RestaurantFoods {
  String? sId;
  String? name;
  String? description;
  int? basePrice;
  List<PricesByQuantity>? pricesByQuantity;
  Category? category;
  bool? isAvailable;
  String? createdBy;
  String? unit;
  int? totalQty;
  int? availableQty;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RestaurantFoods(
      {this.sId,
        this.name,
        this.description,
        this.basePrice,
        this.pricesByQuantity,
        this.category,
        this.isAvailable,
        this.createdBy,
        this.unit,
        this.totalQty,
        this.availableQty,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.iV});

  RestaurantFoods.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    basePrice = json['base_price'];
    if (json['prices_by_quantity'] != null) {
      pricesByQuantity = <PricesByQuantity>[];
      json['prices_by_quantity'].forEach((v) {
        pricesByQuantity!.add(new PricesByQuantity.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    isAvailable = json['is_available'];
    createdBy = json['created_by'];
    unit = json['unit'];
    totalQty = json['total_qty'];
    availableQty = json['available_qty'];
    image = json['image'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['base_price'] = this.basePrice;
    if (this.pricesByQuantity != null) {
      data['prices_by_quantity'] =
          this.pricesByQuantity!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['is_available'] = this.isAvailable;
    data['created_by'] = this.createdBy;
    data['unit'] = this.unit;
    data['total_qty'] = this.totalQty;
    data['available_qty'] = this.availableQty;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class PricesByQuantity {
  String? quantity;
  int? price;
  String? sId;

  PricesByQuantity({this.quantity, this.price, this.sId});

  PricesByQuantity.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
  }
}

class Category {
  String? sId;
  String? name;

  Category({this.sId, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class RestaurantStaff {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? gender;
  String? profilePicture;
  String? address;
  String? role;
  String? managerId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RestaurantStaff(
      {this.sId,
        this.name,
        this.email,
        this.password,
        this.phone,
        this.gender,
        this.profilePicture,
        this.address,
        this.role,
        this.managerId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  RestaurantStaff.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    gender = json['gender'];
    profilePicture = json['profile_picture'];
    address = json['address'];
    role = json['role'];
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
    data['role'] = this.role;
    data['manager_id'] = this.managerId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class RestaurantManager {
  String? sId;
  String? email;
  String? role;
  String? phone;

  RestaurantManager({this.sId, this.email, this.role, this.phone});

  RestaurantManager.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['phone'] = this.phone;
    return data;
  }
}
