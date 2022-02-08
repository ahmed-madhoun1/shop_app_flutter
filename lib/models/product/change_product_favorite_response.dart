class ChangeProductFavoriteResponse {
  late bool? status;
  late String? message;
  late ChangeProductFavoriteData? data;

  ChangeProductFavoriteResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ChangeProductFavoriteData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class ChangeProductFavoriteData {
  late int? id;
  late ProductFavorite? productFavorite;

  ChangeProductFavoriteData.fromJson(dynamic json) {
    id = json['id'];
    productFavorite = json['product'] != null
        ? ProductFavorite.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (productFavorite != null) {
      map['product'] = productFavorite?.toJson();
    }
    return map;
  }
}

class ProductFavorite {
  late int? id;
  late int? price;
  late int? oldPrice;
  late int? discount;
  late String? image;

  ProductFavorite.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['price'] = price;
    map['old_price'] = oldPrice;
    map['discount'] = discount;
    map['image'] = image;
    return map;
  }
}
