class QRRequest {
  String? productId;
  String? productName;
  bool? status;
  String? createdAt;

  QRRequest({this.productId, this.productName, this.status, this.createdAt});

  QRRequest.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    status = json["status"];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = productId;
    data['locationCode'] = productName;
    data['status'] = status;
    data['created_at'] = createdAt;

    return data;
  }
}
