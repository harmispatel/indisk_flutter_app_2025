class OwnerHomeMaster {
  bool? success;
  OwnerHomeData? data;

  OwnerHomeMaster({this.success, this.data});

  OwnerHomeMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
        json['data'] != null ? new OwnerHomeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OwnerHomeData {
  int? staffCount;
  int? restaurantCount;
  int? managerCount;
  List<BestSellers>? bestSellers;

  OwnerHomeData(
      {this.staffCount,
      this.restaurantCount,
      this.managerCount,
      this.bestSellers});

  OwnerHomeData.fromJson(Map<String, dynamic> json) {
    staffCount = json['staffCount'];
    restaurantCount = json['restaurantCount'];
    managerCount = json['managerCount'];
    if (json['best_sellers'] != null) {
      bestSellers = <BestSellers>[];
      json['best_sellers'].forEach((v) {
        bestSellers!.add(new BestSellers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staffCount'] = this.staffCount;
    data['restaurantCount'] = this.restaurantCount;
    data['managerCount'] = this.managerCount;
    if (this.bestSellers != null) {
      data['best_sellers'] = this.bestSellers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BestSellers {
  String? restaurantId;
  String? image;
  String? name;
  String? location;
  String? cuisineType;
  int? orderCount;
  int? totalSales;

  BestSellers(
      {this.restaurantId,
      this.image,
      this.name,
      this.location,
      this.cuisineType,
      this.orderCount,
      this.totalSales});

  BestSellers.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    image = json['image'];
    name = json['name'];
    location = json['location'];
    cuisineType = json['cuisine_type'];
    orderCount = json['orderCount'];
    totalSales = json['totalSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['image'] = this.image;
    data['name'] = this.name;
    data['location'] = this.location;
    data['cuisine_type'] = this.cuisineType;
    data['orderCount'] = this.orderCount;
    data['totalSales'] = this.totalSales;
    return data;
  }
}
