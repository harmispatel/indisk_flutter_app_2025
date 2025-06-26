class OrderHistoryMaster {
  bool? success;
  String? message;
  List<Orders>? orders;

  OrderHistoryMaster({this.success, this.message, this.orders});

  OrderHistoryMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
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

class Orders {
  String? sId;
  String? user;
  int? tableNo;
  List<OrdersItems>? items;
  String? paymentStatus;
  String? status;
  String? orderDate;
  int? totalAmount;
  int? iV;
  String? orderDateFromNow;

  Orders(
      {this.sId,
        this.user,
        this.tableNo,
        this.items,
        this.paymentStatus,
        this.status,
        this.orderDate,
        this.totalAmount,
        this.iV,
        this.orderDateFromNow,
      });

  Orders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    tableNo = json['table_no'];
    if (json['items'] != null) {
      items = <OrdersItems>[];
      json['items'].forEach((v) {
        items!.add(new OrdersItems.fromJson(v));
      });
    }
    paymentStatus = json['payment_status'];
    status = json['status'];
    orderDate = json['order_date'];
    totalAmount = json['total_amount'];
    iV = json['__v'];
    orderDateFromNow = json['order_date_from_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['table_no'] = this.tableNo;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    data['order_date'] = this.orderDate;
    data['total_amount'] = this.totalAmount;
    data['__v'] = this.iV;
    data['order_date_from_now'] = this.orderDateFromNow;
    return data;
  }
}

class OrdersItems {
  OrdersFoodItem? foodItem;
  int? quantity;
  String? sId;

  OrdersItems({this.foodItem, this.quantity, this.sId});

  OrdersItems.fromJson(Map<String, dynamic> json) {
    foodItem = json['food_item'] != null
        ? new OrdersFoodItem.fromJson(json['food_item'])
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

class OrdersFoodItem {
  String? sId;
  String? name;
  String? description;
  int? basePrice;
  bool? isAvailable;
  String? createdBy;
  String? unit;
  int? totalQty;
  int? availableQty;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  OrdersFoodItem(
      {this.sId,
        this.name,
        this.description,
        this.basePrice,
        this.isAvailable,
        this.createdBy,
        this.unit,
        this.totalQty,
        this.availableQty,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.iV});

  OrdersFoodItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    basePrice = json['base_price'];
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
