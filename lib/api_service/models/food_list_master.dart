class FoodListMaster {
  String? message;
  bool? success;
  List<FoodListData>? data;

  FoodListMaster({this.message, this.success, this.data});

  FoodListMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <FoodListData>[];
      json['data'].forEach((v) {
        data!.add(new FoodListData.fromJson(v));
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

class FoodListData {
  String? sId;
  String? name;
  String? unit;
  int? availableQty;
  String? contentPerSingleItem;
  String? cookingTime;
  List<String>? preparations;
  int? minStockRequired;
  int? priority;
  String? preparationsTime;
  List<String>? imageUrl;
  double? shiftingConstant;
  FoodCategory? foodCategory;
  RestaurantId? restaurantId;
  CreatedBy? createdBy;
  int? basePrice;
  List<PricesByQuantity>? pricesByQuantity;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FoodListData(
      {this.sId,
      this.name,
      this.unit,
      this.availableQty,
      this.contentPerSingleItem,
      this.cookingTime,
      this.preparations,
      this.minStockRequired,
      this.priority,
      this.preparationsTime,
      this.imageUrl,
      this.shiftingConstant,
      this.foodCategory,
      this.restaurantId,
      this.createdBy,
      this.basePrice,
      this.pricesByQuantity,
      this.createdAt,
      this.updatedAt,
      this.iV});

  FoodListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    unit = json['unit'];
    availableQty = json['available_qty'];
    contentPerSingleItem = json['content_per_single_item'];
    cookingTime = json['cooking_time'];
    preparations = json['preparations'].cast<String>();
    minStockRequired = json['min_stock_required'];
    priority = json['priority'];
    preparationsTime = json['preparations_time'];
    imageUrl = json['image_url'].cast<String>();
    shiftingConstant = json['shifting_constant'];
    foodCategory = json['food_category'] != null
        ? new FoodCategory.fromJson(json['food_category'])
        : null;
    restaurantId = json['restaurant_id'] != null
        ? new RestaurantId.fromJson(json['restaurant_id'])
        : null;
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    basePrice = json['base_price'];
    if (json['prices_by_quantity'] != null) {
      pricesByQuantity = <PricesByQuantity>[];
      json['prices_by_quantity'].forEach((v) {
        pricesByQuantity!.add(new PricesByQuantity.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['available_qty'] = this.availableQty;
    data['content_per_single_item'] = this.contentPerSingleItem;
    data['cooking_time'] = this.cookingTime;
    data['preparations'] = this.preparations;
    data['min_stock_required'] = this.minStockRequired;
    data['priority'] = this.priority;
    data['preparations_time'] = this.preparationsTime;
    data['image_url'] = this.imageUrl;
    data['shifting_constant'] = this.shiftingConstant;
    if (this.foodCategory != null) {
      data['food_category'] = this.foodCategory!.toJson();
    }
    if (this.restaurantId != null) {
      data['restaurant_id'] = this.restaurantId!.toJson();
    }
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    data['base_price'] = this.basePrice;
    if (this.pricesByQuantity != null) {
      data['prices_by_quantity'] =
          this.pricesByQuantity!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class FoodCategory {
  String? sId;
  String? name;

  FoodCategory({this.sId, this.name});

  FoodCategory.fromJson(Map<String, dynamic> json) {
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

class RestaurantId {
  String? sId;

  RestaurantId({this.sId});

  RestaurantId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class CreatedBy {
  String? sId;
  String? email;

  CreatedBy({this.sId, this.email});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    return data;
  }
}

class PricesByQuantity {
  String? quantity;
  String? price;
  String? discountPrice;
  String? sId;

  PricesByQuantity({this.quantity, this.price, this.discountPrice, this.sId});

  PricesByQuantity.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    discountPrice = json['discount_price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['_id'] = this.sId;
    return data;
  }
}
