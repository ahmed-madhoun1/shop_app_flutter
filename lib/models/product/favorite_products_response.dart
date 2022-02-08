class FavoriteProductsResponse {
  late bool? status;
  late dynamic message;
  late Data? data;

  FavoriteProductsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  late int? currentPage;
  late List<FavoriteProductData>? favoriteProductsData;
  late String? firstPageUrl;
  late int? from;
  late int? lastPage;
  late String? lastPageUrl;
  late dynamic nextPageUrl;
  late String? path;
  late int? perPage;
  late dynamic prevPageUrl;
  late int? to;
  late int? total;

  Data.fromJson(dynamic json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      favoriteProductsData = [];
      json['data'].forEach((v) {
        favoriteProductsData?.add(FavoriteProductData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    if (favoriteProductsData != null) {
      map['data'] = favoriteProductsData?.map((v) => v.toJson()).toList();
    }
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['prev_page_url'] = prevPageUrl;
    map['to'] = to;
    map['total'] = total;
    return map;
  }
}

class FavoriteProductData {
  late int? id;
  late FavoriteProduct? favoriteProduct;

  FavoriteProductData.fromJson(dynamic json) {
    id = json['id'];
    favoriteProduct = json['product'] != null
        ? FavoriteProduct.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (favoriteProduct != null) {
      map['product'] = favoriteProduct?.toJson();
    }
    return map;
  }
}

class FavoriteProduct {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late int? discount;
  late String image;
  late String name;
  late String description;

  FavoriteProduct.fromJson(dynamic json) {
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
