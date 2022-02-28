class CartProductsResponse {

 late bool? status;
 late dynamic message;
 late CartProductsData cartProductsData;

  CartProductsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    cartProductsData = CartProductsData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = cartProductsData.toJson();
    return map;
  }

}

class CartProductsData {

 late List<CartItem>? cartItems;
 late dynamic subTotal;
 late dynamic total;

  CartProductsData.fromJson(dynamic json) {
    if (json['cart_items'] != null) {
      cartItems = [];
      json['cart_items'].forEach((v) {
        cartItems?.add(CartItem.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cartItems != null) {
      map['cart_items'] = cartItems?.map((v) => v.toJson()).toList();
    }
    map['sub_total'] = subTotal;
    map['total'] = total;
    return map;
  }

}

class CartItem {

late  int id;
late  int quantity;
late  CartProduct cartProduct;

  CartItem.fromJson(dynamic json) {
    id = json['id'];
    quantity = json['quantity'];
    cartProduct = CartProduct.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['quantity'] = quantity;
    map['product'] = cartProduct.toJson();
    return map;
  }

}

class CartProduct {

 late int? id;
 late dynamic price;
 late dynamic oldPrice;
 late dynamic discount;
 late String image;
 late String name;
 late String? description;
 late List<String>? images;
 late bool? inFavorites;
 late bool? inCart;

  CartProduct.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
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
    map['images'] = images;
    map['in_favorites'] = inFavorites;
    map['in_cart'] = inCart;
    return map;
  }

}