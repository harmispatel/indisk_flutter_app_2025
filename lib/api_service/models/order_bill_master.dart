class OrderBillMaster {
  bool? success;
  String? message;
  List<OrderBillItems>? items;
  Summary? summary;

  OrderBillMaster({this.success, this.message, this.items, this.summary});

  OrderBillMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['items'] != null) {
      items = <OrderBillItems>[];
      json['items'].forEach((v) {
        items!.add(new OrderBillItems.fromJson(v));
      });
    }
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    return data;
  }
}

class OrderBillItems {
  String? foodItem;
  dynamic quantity;
  dynamic basePrice;
  dynamic variantPrice;
  dynamic modifierPrice;
  dynamic topupPrice;
  dynamic discountPercent;
  dynamic unitPriceAfterDiscount;
  dynamic totalPrice;

  OrderBillItems(
      {this.foodItem,
        this.quantity,
        this.basePrice,
        this.variantPrice,
        this.modifierPrice,
        this.topupPrice,
        this.discountPercent,
        this.unitPriceAfterDiscount,
        this.totalPrice});

  OrderBillItems.fromJson(Map<String, dynamic> json) {
    foodItem = json['food_item'];
    quantity = json['quantity'];
    basePrice = json['base_price'];
    variantPrice = json['variant_price'];
    modifierPrice = json['modifier_price'];
    topupPrice = json['topup_price'];
    discountPercent = json['discount_percent'];
    unitPriceAfterDiscount = json['unit_price_after_discount'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item'] = this.foodItem;
    data['quantity'] = this.quantity;
    data['base_price'] = this.basePrice;
    data['variant_price'] = this.variantPrice;
    data['modifier_price'] = this.modifierPrice;
    data['topup_price'] = this.topupPrice;
    data['discount_percent'] = this.discountPercent;
    data['unit_price_after_discount'] = this.unitPriceAfterDiscount;
    data['total_price'] = this.totalPrice;
    return data;
  }
}

class Summary {
  int? totalItems;
  dynamic subTotal;
  dynamic vat;
  dynamic totalAmount;
  dynamic vatPercentage;

  Summary(
      {this.totalItems,
        this.subTotal,
        this.vat,
        this.totalAmount,
        this.vatPercentage});

  Summary.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    subTotal = json['sub_total'];
    vat = json['vat'];
    totalAmount = json['total_amount'];
    vatPercentage = json['vatPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_items'] = this.totalItems;
    data['sub_total'] = this.subTotal;
    data['vat'] = this.vat;
    data['total_amount'] = this.totalAmount;
    data['vatPercentage'] = this.vatPercentage;
    return data;
  }
}
