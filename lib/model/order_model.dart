class Order {
  String? id;
  String? userId;
  String? address;
  String? orderId;
  String? productName;
  String? orderTime;
  // Add other properties as needed

  Order({this.id, this.userId, this.address,this.orderId,this.orderTime,this.productName});
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      orderId: json['orderId'],
      productName: json['productName'],
      address: json['address'],
      orderTime: json['orderTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'orderId': orderId,
      'orderTime': orderTime,
      'productName': productName,
      // Add other properties as needed
    };
  }
}


