class TableMaster {
  bool? success;
  String? message;
  List<TableData>? data;

  TableMaster({this.success, this.message, this.data});

  TableMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TableData>[];
      json['data'].forEach((v) {
        data!.add(new TableData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableData {
  String? sId;
  int? tableNo;
  String? managerId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? orderTime;
  bool? available;
  int? orderedItemsCount;

  TableData(
      {this.sId,
        this.tableNo,
        this.managerId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.orderTime,
        this.available,
        this.orderedItemsCount});

  TableData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tableNo = json['table_no'];
    managerId = json['manager_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    orderTime = json['order_time'];
    available = json['available'];
    orderedItemsCount = json['ordered_items_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['table_no'] = this.tableNo;
    data['manager_id'] = this.managerId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['order_time'] = this.orderTime;
    data['available'] = this.available;
    data['ordered_items_count'] = this.orderedItemsCount;
    return data;
  }
}
