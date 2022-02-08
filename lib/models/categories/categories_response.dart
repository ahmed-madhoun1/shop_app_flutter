class CategoriesResponse {
  late bool? status;
  late dynamic message;
  late CategoriesData? data;

  CategoriesResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CategoriesData.fromJson(json['data']) : null;
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

class CategoriesData {
  late int? currentPage;
  late List<Category>? categories;
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

  CategoriesData.fromJson(dynamic json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      categories = [];
      json['data'].forEach((v) {
        categories?.add(Category.fromJson(v));
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

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['current_page'] = currentPage;
//   if (data != null) {
//     map['data'] = data?.map((v) => v.toJson()).toList();
//   }
//   map['first_page_url'] = firstPageUrl;
//   map['from'] = from;
//   map['last_page'] = lastPage;
//   map['last_page_url'] = lastPageUrl;
//   map['next_page_url'] = nextPageUrl;
//   map['path'] = path;
//   map['per_page'] = perPage;
//   map['prev_page_url'] = prevPageUrl;
//   map['to'] = to;
//   map['total'] = total;
//   return map;
// }

}

class Category {
  late int? id;
  late String name;
  late String image;

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  /// Map<String, dynamic> toJson() {
  ///   final map = <String, dynamic>{};
  ///   map['id'] = id;
  ///   map['name'] = name;
  ///   map['image'] = image;
  ///   return map;
  /// }

}
