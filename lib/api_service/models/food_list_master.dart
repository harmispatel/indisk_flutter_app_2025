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
  String? description;
  int? basePrice;
  List<PricesByQuantity>? pricesByQuantity;
  Category? category;
  bool? isAvailable;
  CreatedBy? createdBy;
  String? unit;
  int? totalQty;
  int? availableQty;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Discount>? discount;
  List<Modifier>? modifier;
  List<Topup>? topup;
  List<Varient>? varient;

  FoodListData(
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
        this.iV,
        this.discount,
        this.modifier,
        this.topup,
        this.varient});

  FoodListData.fromJson(Map<String, dynamic> json) {
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
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    unit = json['unit'];
    totalQty = json['total_qty'];
    availableQty = json['available_qty'];
    image = json['image'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['discount'] != null) {
      discount = <Discount>[];
      json['discount'].forEach((v) {
        discount!.add(new Discount.fromJson(v));
      });
    }
    if (json['modifier'] != null) {
      modifier = <Modifier>[];
      json['modifier'].forEach((v) {
        modifier!.add(new Modifier.fromJson(v));
      });
    }
    if (json['topup'] != null) {
      topup = <Topup>[];
      json['topup'].forEach((v) {
        topup!.add(new Topup.fromJson(v));
      });
    }
    if (json['varient'] != null) {
      varient = <Varient>[];
      json['varient'].forEach((v) {
        varient!.add(new Varient.fromJson(v));
      });
    }
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
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    data['unit'] = this.unit;
    data['total_qty'] = this.totalQty;
    data['available_qty'] = this.availableQty;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.discount != null) {
      data['discount'] = this.discount!.map((v) => v.toJson()).toList();
    }
    if (this.modifier != null) {
      data['modifier'] = this.modifier!.map((v) => v.toJson()).toList();
    }
    if (this.topup != null) {
      data['topup'] = this.topup!.map((v) => v.toJson()).toList();
    }
    if (this.varient != null) {
      data['varient'] = this.varient!.map((v) => v.toJson()).toList();
    }
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

class CreatedBy {
  String? sId;

  CreatedBy({this.sId});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class Discount {
  bool? isEnable;
  int? percentage;
  String? description;
  String? sId;

  Discount({this.isEnable, this.percentage, this.description, this.sId});

  Discount.fromJson(Map<String, dynamic> json) {
    isEnable = json['isEnable'];
    percentage = json['percentage'];
    description = json['description'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEnable'] = this.isEnable;
    data['percentage'] = this.percentage;
    data['description'] = this.description;
    data['_id'] = this.sId;
    return data;
  }
}

class Modifier {
  String? modifierName;
  int? price;
  String? sId;

  Modifier({this.modifierName, this.price, this.sId});

  Modifier.fromJson(Map<String, dynamic> json) {
    modifierName = json['modifierName'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modifierName'] = this.modifierName;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
  }
}

class Topup {
  String? topupName;
  int? price;
  String? sId;

  Topup({this.topupName, this.price, this.sId});

  Topup.fromJson(Map<String, dynamic> json) {
    topupName = json['topupName'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topupName'] = this.topupName;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
  }
}

class Varient {
  String? varientName;
  int? price;
  String? sId;

  Varient({this.varientName, this.price, this.sId});

  Varient.fromJson(Map<String, dynamic> json) {
    varientName = json['varientName'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['varientName'] = this.varientName;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
  }
}
