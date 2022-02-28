class UpdateCartItemQuantityResponse {
  UpdateCartItemQuantityResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _updateCartItemQuantityData =
        UpdateCartItemQuantityData.fromJson(json['data']);
  }

  late bool _status;
  late String? _message;
  late UpdateCartItemQuantityData _updateCartItemQuantityData;

  bool? get status => _status;

  String? get message => _message;

  UpdateCartItemQuantityData get data => _updateCartItemQuantityData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['data'] = _updateCartItemQuantityData.toJson();
    return map;
  }
}

class UpdateCartItemQuantityData {
  UpdateCartItemQuantityData.fromJson(dynamic json) {
    _cartItem = CartItem.fromJson(json['cart']);
    _subTotal = json['sub_total'];
    _total = json['total'];
  }

  late CartItem _cartItem;
  late dynamic _subTotal;
  late dynamic _total;

  CartItem get cart => _cartItem;

  dynamic get subTotal => _subTotal;

  dynamic get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cart'] = _cartItem.toJson();
    map['sub_total'] = _subTotal;
    map['total'] = _total;
    return map;
  }
}

class CartItem {
  CartItem.fromJson(dynamic json) {
    _id = json['id'];
    _quantity = json['quantity'];
    _product = Product.fromJson(json['product']);
  }

  late int _id;
  late int _quantity;
  late Product _product;

  int get id => _id;

  int get quantity => _quantity;

  Product get product => _product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['quantity'] = _quantity;
    map['product'] = _product.toJson();
    return map;
  }
}

class Product {
  Product.fromJson(dynamic json) {
    _id = json['id'];
    _price = json['price'];
    _oldPrice = json['old_price'];
    _discount = json['discount'];
    _image = json['image'];
  }

  late int? _id;
  late dynamic _price;
  late dynamic _oldPrice;
  late dynamic _discount;
  late String? _image;

  int? get id => _id;

  dynamic get price => _price;

  dynamic get oldPrice => _oldPrice;

  dynamic get discount => _discount;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price'] = _price;
    map['old_price'] = _oldPrice;
    map['discount'] = _discount;
    map['image'] = _image;
    return map;
  }
}
