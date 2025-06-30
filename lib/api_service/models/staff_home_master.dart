class StaffHomeMaster {
  String? message;
  bool? success;
  List<StaffHomeData>? data;

  StaffHomeMaster({this.message, this.success, this.data});

  StaffHomeMaster.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <StaffHomeData>[];
      json['data'].forEach((v) {
        data!.add(new StaffHomeData.fromJson(v));
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

class StaffHomeData {
  String? id;
  List<String>? image;
  String? name;
  String? description;
  int? price;
  int? cartCount;
  bool? isAvailable;
  Category? category;
  List<Discount>? discount;
  List<Varient>? varient;
  List<Modifier>? modifier;
  List<Topup>? topup;

  StaffHomeData(
      {this.id,
        this.image,
        this.name,
        this.description,
        this.price,
        this.cartCount,
        this.isAvailable,
        this.category,
        this.discount,
        this.varient,
        this.modifier,
        this.topup});

  StaffHomeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'].cast<String>();
    name = json['name'];
    description = json['description'];
    price = json['price'];
    cartCount = json['cartCount'];
    isAvailable = json['isAvailable'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['discount'] != null) {
      discount = <Discount>[];
      json['discount'].forEach((v) {
        discount!.add(new Discount.fromJson(v));
      });
    }
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
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['cartCount'] = this.cartCount;
    data['isAvailable'] = this.isAvailable;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.discount != null) {
      data['discount'] = this.discount!.map((v) => v.toJson()).toList();
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

class Varient {
  int? price;
  String? sId;
  String? varientName;

  Varient({this.price, this.sId, this.varientName});

  Varient.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    sId = json['_id'];
    varientName = json['varientName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['_id'] = this.sId;
    data['varientName'] = this.varientName;
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