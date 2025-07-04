class SalesGraphMaster {
  bool? success;
  String? message;
  List<SalesGraphData>? data;

  SalesGraphMaster({this.success, this.message, this.data});

  SalesGraphMaster.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SalesGraphData>[];
      json['data'].forEach((v) {
        data!.add(new SalesGraphData.fromJson(v));
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

class SalesGraphData {
  String? sId;
  double? total;
  int? count;  // Changed from dynamic to int

  SalesGraphData({this.sId, this.total, this.count});

  factory SalesGraphData.fromJson(Map<String, dynamic> json) {
    return SalesGraphData(
      sId: json['_id'],
      total: json['total']?.toDouble() ?? 0.0,  // Ensure conversion to double
      count: json['count'] as int?,  // Explicitly cast to int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'total': total,
      'count': count,
    };
  }
}
