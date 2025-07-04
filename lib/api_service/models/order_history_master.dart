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
  List<Items>? items;
  String? paymentStatus;
  String? status;
  String? orderDate;
  dynamic totalAmount;
  dynamic vat;
  dynamic subTotal;
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
        this.vat,
        this.subTotal,
        this.iV,
        this.orderDateFromNow});

  Orders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    tableNo = json['table_no'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    paymentStatus = json['payment_status'];
    status = json['status'];
    orderDate = json['order_date'];
    totalAmount = json['total_amount'];
    vat = json['vat'];
    subTotal = json['sub_total'];
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
    data['vat'] = this.vat;
    data['sub_total'] = this.subTotal;
    data['__v'] = this.iV;
    data['order_date_from_now'] = this.orderDateFromNow;
    return data;
  }
}

class Items {
  FoodItem? foodItem;
  int? quantity;
  String? specialInstruction;
  Discount? discount;
  List<Varient>? varient;
  List<Modifier>? modifier;
  List<Topup>? topup;

  Items(
      {this.foodItem,
        this.quantity,
        this.specialInstruction,
        this.discount,
        this.varient,
        this.modifier,
        this.topup});

  Items.fromJson(Map<String, dynamic> json) {
    foodItem = json['food_item'] != null
        ? new FoodItem.fromJson(json['food_item'])
        : null;
    quantity = json['quantity'];
    specialInstruction = json['special_instruction'];
    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
        : null;
    if (json['varient'] != null) {
      varient = <Varient>[];
      json['varient'].forEach((v) {
        varient!.add(new Varient.fromJson(v));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foodItem != null) {
      data['food_item'] = this.foodItem!.toJson();
    }
    data['quantity'] = this.quantity;
    data['special_instruction'] = this.specialInstruction;
    if (this.discount != null) {
      data['discount'] = this.discount!.toJson();
    }
    if (this.varient != null) {
      data['varient'] = this.varient!.map((v) => v.toJson()).toList();
    }
    if (this.modifier != null) {
      data['modifier'] = this.modifier!.map((v) => v.toJson()).toList();
    }
    if (this.topup != null) {
      data['topup'] = this.topup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodItem {
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

  FoodItem(
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

  FoodItem.fromJson(Map<String, dynamic> json) {
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

class Discount {
  int? percentage;
  String? description;

  Discount({this.percentage, this.description});

  Discount.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percentage'] = this.percentage;
    data['description'] = this.description;
    return data;
  }
}

class Varient {
  String? varientName;
  int? price;

  Varient({this.varientName, this.price});

  Varient.fromJson(Map<String, dynamic> json) {
    varientName = json['varientName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['varientName'] = this.varientName;
    data['price'] = this.price;
    return data;
  }
}

class Modifier {
  String? modifierName;
  int? price;

  Modifier({this.modifierName, this.price});

  Modifier.fromJson(Map<String, dynamic> json) {
    modifierName = json['modifierName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modifierName'] = this.modifierName;
    data['price'] = this.price;
    return data;
  }
}

class Topup {
  String? topupName;
  int? price;

  Topup({this.topupName, this.price});

  Topup.fromJson(Map<String, dynamic> json) {
    topupName = json['topupName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topupName'] = this.topupName;
    data['price'] = this.price;
    return data;
  }
}
