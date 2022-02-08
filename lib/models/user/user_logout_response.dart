class UserLogoutResponse {
  bool? status;
  String? message;
  UserLogoutData? userLogoutData;

  UserLogoutResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    userLogoutData =
        json['data'] != null ? UserLogoutData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (userLogoutData != null) {
      map['data'] = userLogoutData?.toJson();
    }
    return map;
  }
}

class UserLogoutData {
  int? id;
  String? token;

  UserLogoutData.fromJson(dynamic json) {
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['token'] = token;
    return map;
  }
}
