class SalesCountMaster {
  bool? success;
  String? message;
  SalesCountData? data;

  SalesCountMaster({this.success, this.message, this.data});

  SalesCountMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new SalesCountData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SalesCountData {
  String? grossSales;
  String? refunds;
  String? totalDiscount;
  String? netSales;
  String? grossProfit;

  SalesCountData(
      {this.grossSales,
        this.refunds,
        this.totalDiscount,
        this.netSales,
        this.grossProfit});

  SalesCountData.fromJson(Map<String, dynamic> json) {
    grossSales = json['grossSales'];
    refunds = json['refunds'];
    totalDiscount = json['totalDiscount'];
    netSales = json['netSales'];
    grossProfit = json['grossProfit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grossSales'] = this.grossSales;
    data['refunds'] = this.refunds;
    data['totalDiscount'] = this.totalDiscount;
    data['netSales'] = this.netSales;
    data['grossProfit'] = this.grossProfit;
    return data;
  }
}
