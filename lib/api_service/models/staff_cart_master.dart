class StaffCartMaster {
  bool? success;
  String? message;
  List<StaffCartData>? cart;
  int? totalQuantity;
  int? subtotal;
  dynamic? gst5Percent;
  dynamic? totalWithGst;

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
  int? price;
  int? quantity;
  int? totalPrice;

  StaffCartData(
      {this.foodItemId,
        this.image,
        this.productName,
        this.price,
        this.quantity,
        this.totalPrice});

  StaffCartData.fromJson(Map<String, dynamic> json) {
    foodItemId = json['food_item_id'];
    image = json['image'].cast<String>();
    productName = json['product_name'];
    price = json['price'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item_id'] = this.foodItemId;
    data['image'] = this.image;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['total_price'] = this.totalPrice;
    return data;
  }
}
