class ProductsResponse {
  late bool status;
  late dynamic message;
  late ProductsData? data;

  ProductsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProductsData.fromJson(json['data']) : null;
  }

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['status'] = status;
//   map['message'] = message;
//   if (data != null) {
//     map['data'] = data?.toJson();
//   }
//   return map;
// }
}

class ProductsData {
  late List<Banner> banners;
  late List<Product> products;
  late String ad;

  ProductsData.fromJson(dynamic json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners.add(Banner.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products.add(Product.fromJson(v));
      });
    }
    ad = json['ad'];
  }

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   if (banners != null) {
//     map['banners'] = banners.map((v) => v.toJson()).toList();
//   }
//   if (products != null) {
//     map['products'] = products.map((v) => v.toJson()).toList();
//   }
//   map['ad'] = ad;
//   return map;
// }
}

class Product {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late String description;
  late List<String> images;
  late bool inFavorites;
  late bool inCart;

  Product.fromJson(dynamic json) {
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

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['id'] = id;
//   map['price'] = price;
//   map['old_price'] = oldPrice;
//   map['discount'] = discount;
//   map['image'] = image;
//   map['name'] = name;
//   map['description'] = description;
//   map['images'] = images;
//   map['in_favorites'] = inFavorites;
//   map['in_cart'] = inCart;
//   return map;
// }
}

class Banner {
  late int id;
  late String image;
  late dynamic category;
  late dynamic product;

  Banner.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['id'] = id;
//   map['image'] = image;
//   map['category'] = category;
//   map['product'] = product;
//   return map;
// }

}
