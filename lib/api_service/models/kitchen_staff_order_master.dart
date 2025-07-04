class KitchenStaffOrderMaster {
  bool? success;
  String? message;
  List<KitchenStaffOrders>? orders;

  KitchenStaffOrderMaster({this.success, this.message, this.orders});

  KitchenStaffOrderMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <KitchenStaffOrders>[];
      json['orders'].forEach((v) {
        orders!.add(new KitchenStaffOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KitchenStaffOrders {
  String? sId;
  User? user;
  num? tableNo;
  List<Items>? items;
  String? paymentType;
  String? paymentStatus;
  String? status;
  String? orderDate;
  dynamic? totalAmount;
  dynamic? iV;

  KitchenStaffOrders(
      {this.sId,
        this.user,
        this.tableNo,
        this.items,
        this.paymentType,
        this.paymentStatus,
        this.status,
        this.orderDate,
        this.totalAmount,
        this.iV});

  KitchenStaffOrders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    tableNo = json['table_no'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    orderDate = json['order_date'];
    totalAmount = json['total_amount'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['table_no'] = this.tableNo;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    data['order_date'] = this.orderDate;
    data['total_amount'] = this.totalAmount;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String? sId;
  String? email;
  String? role;

  User({this.sId, this.email, this.role});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}

class Items {
  FoodItem? foodItem;
  dynamic? quantity;
  String? sId;

  Items({this.foodItem, this.quantity, this.sId});

  Items.fromJson(Map<String, dynamic> json) {
    foodItem = json['food_item'] != null
        ? new FoodItem.fromJson(json['food_item'])
        : null;
    quantity = json['quantity'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foodItem != null) {
      data['food_item'] = this.foodItem!.toJson();
    }
    data['quantity'] = this.quantity;
    data['_id'] = this.sId;
    return data;
  }
}

class FoodItem {
  String? sId;
  String? name;
  String? description;
  dynamic? basePrice;
  List<PricesByQuantity>? pricesByQuantity;
  String? category;
  bool? isAvailable;
  String? createdBy;
  String? unit;
  dynamic? totalQty;
  dynamic? availableQty;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  dynamic? iV;

  FoodItem(
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

  FoodItem.fromJson(Map<String, dynamic> json) {
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
    category = json['category'];
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
    data['category'] = this.category;
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
  dynamic? price;
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
