class StaffHomeMaster {
  String? message;
  bool? success;
  List<StaffHomeData>? data;

  StaffHomeMaster({this.message, this.success, this.data});

  StaffHomeMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <StaffHomeData>[];
      json['data'].forEach((v) {
        data!.add(new StaffHomeData.fromJson(v));
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

class StaffHomeData {
  String? id;
  List<String>? image;
  String? name;
  String? description;
  int? price;
  int? cartCount;
  String? isAvailable;
  Category? category;

  StaffHomeData(
      {this.id,
        this.image,
        this.name,
        this.description,
        this.price,
        this.cartCount,
        this.isAvailable,
        this.category});

  StaffHomeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'].cast<String>();
    name = json['name'];
    description = json['description'];
    price = json['price'];
    cartCount = json['cartCount'];
    isAvailable = json['isAvailable'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['cartCount'] = this.cartCount;
    data['isAvailable'] = this.isAvailable;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
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