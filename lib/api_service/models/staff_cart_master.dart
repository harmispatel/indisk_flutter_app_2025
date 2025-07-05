import 'food_list_master.dart';

class StaffCartMaster {
  bool? success;
  String? message;
  List<StaffCartData>? cart;
  int? totalQuantity;
  int? subtotal;
  dynamic? gst5Percent;
  double? totalWithGst;

  StaffCartMaster(
      {this.success,
        this.message,
        this.cart,
        this.totalQuantity,
        this.subtotal,
        this.gst5Percent,
        this.totalWithGst});

  StaffCartMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['cart'] != null) {
      cart = <StaffCartData>[];
      json['cart'].forEach((v) {
        cart!.add(new StaffCartData.fromJson(v));
      });
    }
    totalQuantity = json['total_quantity'];
    subtotal = json['subtotal'];
    gst5Percent = json['gst_5_percent'];
    totalWithGst = json['total_with_gst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
    data['total_quantity'] = this.totalQuantity;
    data['subtotal'] = this.subtotal;
    data['gst_5_percent'] = this.gst5Percent;
    data['total_with_gst'] = this.totalWithGst;
    return data;
  }
}

class StaffCartData {
  String? foodItemId;
  List<String>? image;
  String? productName;
  int? pricePerUnit;
  int? quantity;
  int? totalPrice;
  AdditionalPrice? additionalPrice;
  String? specialInstruction;
  bool? isOrdered;

  StaffCartData(
      {this.foodItemId,
        this.image,
        this.productName,
        this.pricePerUnit,
        this.quantity,
        this.totalPrice,
        this.additionalPrice,
        this.specialInstruction,
        this.isOrdered});

  StaffCartData.fromJson(Map<String, dynamic> json) {
    foodItemId = json['food_item_id'];
    image = json['image'].cast<String>();
    productName = json['product_name'];
    pricePerUnit = json['price_per_unit'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    additionalPrice = json['additional_price'] != null
        ? new AdditionalPrice.fromJson(json['additional_price'])
        : null;
    specialInstruction = json['special_instruction'];
    isOrdered = json['is_ordered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item_id'] = this.foodItemId;
    data['image'] = this.image;
    data['product_name'] = this.productName;
    data['price_per_unit'] = this.pricePerUnit;
    data['quantity'] = this.quantity;
    data['total_price'] = this.totalPrice;
    if (this.additionalPrice != null) {
      data['additional_price'] = this.additionalPrice!.toJson();
    }
    data['special_instruction'] = this.specialInstruction;
    data['is_ordered'] = this.isOrdered;
    return data;
  }
}

class AdditionalPrice {
  List<Topup>? topup;
  List<Modifier>? modifier;
  List<Varient>? varient;
  Discount? discount;

  AdditionalPrice({this.topup, this.modifier, this.varient, this.discount});

  AdditionalPrice.fromJson(Map<String, dynamic> json) {
    if (json['topup'] != null) {
      topup = <Topup>[];
      json['topup'].forEach((v) {
        topup!.add(new Topup.fromJson(v));
      });
    }
    if (json['modifier'] != null) {
      modifier = <Modifier>[];
      json['modifier'].forEach((v) {
        modifier!.add(new Modifier.fromJson(v));
      });
    }
    if (json['varient'] != null) {
      varient = <Varient>[];
      json['varient'].forEach((v) {
        varient!.add(new Varient.fromJson(v));
      });
    }
    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topup != null) {
      data['topup'] = this.topup!.map((v) => v.toJson()).toList();
    }
    if (this.modifier != null) {
      data['modifier'] = this.modifier!.map((v) => v.toJson()).toList();
    }
    if (this.varient != null) {
      data['varient'] = this.varient!.map((v) => v.toJson()).toList();
    }
    if (this.discount != null) {
      data['discount'] = this.discount!.toJson();
    }
    return data;
  }
}

