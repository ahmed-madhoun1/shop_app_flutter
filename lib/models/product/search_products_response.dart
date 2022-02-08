class SearchProductsResponse {
  late bool? status;
  late dynamic message;
  late SearchProductsData? searchProductsData;

  SearchProductsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    searchProductsData =
        json['data'] != null ? SearchProductsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (searchProductsData != null) {
      map['data'] = searchProductsData?.toJson();
    }
    return map;
  }
}

class SearchProductsData {
  late int? currentPage;
  late List<SearchProduct>? searchProducts;
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

  SearchProductsData.fromJson(dynamic json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      searchProducts = [];
      json['data'].forEach((v) {
        searchProducts?.add(SearchProduct.fromJson(v));
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
    if (searchProducts != null) {
      map['data'] = searchProducts?.map((v) => v.toJson()).toList();
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

class SearchProduct {
  SearchProduct.fromJson(dynamic json) {
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

 late int id;
 late dynamic price;
 late dynamic oldPrice;
 late dynamic discount;
 late String image;
 late String name;
 late String? description;
 late List<String>? images;
 late bool? inFavorites;
 late bool? inCart;

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
