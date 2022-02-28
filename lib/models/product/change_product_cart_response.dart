class ChangeProductCartResponse {
  late bool? status;
  late String? message;
  late CartItem cartItem;

  ChangeProductCartResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    cartItem = CartItem.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = cartItem.toJson();
    return map;
  }
}

class CartItem {
  late int id;
  late int quantity;
  late Product product;

  CartItem.fromJson(dynamic json) {
    id = json['id'];
    quantity = json['quantity'];
    product = Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['quantity'] = quantity;
    map['product'] = product.toJson();
    return map;
  }
}

class Product {
  late int? id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String? image;
  late String? name;
  late String? description;

  Product.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['price'] = price;
    map['old_price'] = oldPrice;
    map['discount'] = discount;
    map['image'] = image;
    map['name'] = name;
    map['description'] = description;
    return map;
  }
}
