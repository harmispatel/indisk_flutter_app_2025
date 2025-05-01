class FoodCategoryMaster {
  String? message;
  bool? success;
  List<FoodCategoryDetails>? data;

  FoodCategoryMaster({this.message, this.success, this.data});

  FoodCategoryMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <FoodCategoryDetails>[];
      json['data'].forEach((v) {
        data!.add(new FoodCategoryDetails.fromJson(v));
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

class FoodCategoryDetails {
  String? sId;
  String? name;
  String? description;
  String? restaurantId;
  String? imageUrl;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FoodCategoryDetails(
      {this.sId,
        this.name,
        this.description,
        this.restaurantId,
        this.imageUrl,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

  FoodCategoryDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
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
    data['restaurant_id'] = this.restaurantId;
    data['image_url'] = this.imageUrl;
    data['is_active'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}


