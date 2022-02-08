import 'package:shop_app/models/categories/categories_response.dart';
import 'package:shop_app/models/product/change_product_favorite_response.dart';
import 'package:shop_app/models/product/favorite_products_response.dart';
import 'package:shop_app/models/product/products_response.dart';
import 'package:shop_app/models/product/search_products_response.dart';
import 'package:shop_app/models/user/user_logout_response.dart';
import 'package:shop_app/models/user/user_response.dart';

abstract class HomeStates {}

class InitialHomeState extends HomeStates {}

class ChangeBottomNavHomeState extends HomeStates {}

class LoadingHomeState extends HomeStates {}

class GetProductsSuccessHomeState extends HomeStates {
  late ProductsResponse? productsResponse;

  GetProductsSuccessHomeState(this.productsResponse);
}

class GetProductsErrorHomeState extends HomeStates {
  late String message;

  GetProductsErrorHomeState(this.message);
}

class GetCategoriesSuccessHomeState extends HomeStates {
  late CategoriesResponse? categoriesResponse;

  GetCategoriesSuccessHomeState(this.categoriesResponse);
}

class GetCategoriesErrorHomeState extends HomeStates {
  late String message;

  GetCategoriesErrorHomeState(this.message);
}

class ChangeProductFavoriteHomeState extends HomeStates {}

class ChangeProductFavoriteSuccessHomeState extends HomeStates {
  late ChangeProductFavoriteResponse? changeProductFavoriteResponse;

  ChangeProductFavoriteSuccessHomeState(this.changeProductFavoriteResponse);
}

class ChangeProductFavoriteErrorHomeState extends HomeStates {
  late String message;

  ChangeProductFavoriteErrorHomeState(this.message);
}

class GetFavoriteProductsLoadingHomeState extends HomeStates {}

class GetFavoriteProductsSuccessHomeState extends HomeStates {
  late FavoriteProductsResponse? favoriteProductsResponse;

  GetFavoriteProductsSuccessHomeState(this.favoriteProductsResponse);
}

class GetFavoriteProductsErrorHomeState extends HomeStates {
  late String message;

  GetFavoriteProductsErrorHomeState(this.message);
}

class GetUserProfileLoadingHomeState extends HomeStates {}

class GetUserProfileSuccessHomeState extends HomeStates {
  late UserResponse? userResponse;

  GetUserProfileSuccessHomeState(this.userResponse);
}

class GetUserProfileErrorHomeState extends HomeStates {
  late String message;

  GetUserProfileErrorHomeState(this.message);
}

class UserLogoutLoadingHomeState extends HomeStates {}

class UserLogoutSuccessHomeState extends HomeStates {
  late UserLogoutResponse? userLogoutResponse;
  late bool? isTokenRemoved;

  UserLogoutSuccessHomeState(this.userLogoutResponse, this.isTokenRemoved);
}

class UserLogoutErrorHomeState extends HomeStates {
  late String message;

  UserLogoutErrorHomeState(this.message);
}

class ImagePickedSuccess extends HomeStates {}

class UpdateUserProfileLoadingHomeState extends HomeStates {}

class UpdateUserProfileSuccessHomeState extends HomeStates {
  late UserResponse? userResponse;

  UpdateUserProfileSuccessHomeState(this.userResponse);
}

class UpdateUserProfileErrorHomeState extends HomeStates {
  late String message;

  UpdateUserProfileErrorHomeState(this.message);
}

class GetSearchProductsLoadingHomeState extends HomeStates {}

class GetSearchProductsSuccessHomeState extends HomeStates {
  late SearchProductsResponse? searchProductsResponse;

  GetSearchProductsSuccessHomeState(this.searchProductsResponse);
}

class GetSearchProductsErrorHomeState extends HomeStates {
  late String message;

  GetSearchProductsErrorHomeState(this.message);
}
