class FoodCategoryMaster {
  bool? success;
  String? message;
  List<FoodCategoryDetails>? data;

  FoodCategoryMaster({this.success, this.message, this.data});

  FoodCategoryMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FoodCategoryDetails>[];
      json['data'].forEach((v) {
        data!.add(new FoodCategoryDetails.fromJson(v));
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

class FoodCategoryDetails {
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

  FoodCategoryDetails(
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

  FoodCategoryDetails.fromJson(Map<String, dynamic> json) {
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
