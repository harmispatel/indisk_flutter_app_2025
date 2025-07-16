class SalesGraphMangerMaster {
  bool? success;
  String? message;
  List<String>? foodies;
  List<FoodiesCount>? foodiesCount;
  SalesGraphManagerData? data;

  SalesGraphMangerMaster(
      {this.success, this.message, this.foodies, this.foodiesCount, this.data});

  SalesGraphMangerMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    foodies = json['foodies'].cast<String>();
    if (json['foodiesCount'] != null) {
      foodiesCount = <FoodiesCount>[];
      json['foodiesCount'].forEach((v) {
        foodiesCount!.add(new FoodiesCount.fromJson(v));
      });
    }
    data = json['data'] != null ? new SalesGraphManagerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['foodies'] = this.foodies;
    if (this.foodiesCount != null) {
      data['foodiesCount'] = this.foodiesCount!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class FoodiesCount {
  int? totalQuantity;
  String? foodId;
  String? name;

  FoodiesCount({this.totalQuantity, this.foodId, this.name});

  FoodiesCount.fromJson(Map<String, dynamic> json) {
    totalQuantity = json['total_quantity'];
    foodId = json['food_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_quantity'] = this.totalQuantity;
    data['food_id'] = this.foodId;
    data['name'] = this.name;
    return data;
  }
}

class SalesGraphManagerData {
  String? grossSales;
  String? totalDiscount;
  String? netSales;
  String? grossProfit;

  SalesGraphManagerData({this.grossSales, this.totalDiscount, this.netSales, this.grossProfit});

  SalesGraphManagerData.fromJson(Map<String, dynamic> json) {
    grossSales = json['grossSales'];
    totalDiscount = json['totalDiscount'];
    netSales = json['netSales'];
    grossProfit = json['grossProfit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grossSales'] = this.grossSales;
    data['totalDiscount'] = this.totalDiscount;
    data['netSales'] = this.netSales;
    data['grossProfit'] = this.grossProfit;
    return data;
  }
}
