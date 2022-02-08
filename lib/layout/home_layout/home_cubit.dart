import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/product/change_product_favorite_response.dart';
import 'package:shop_app/models/product/favorite_products_response.dart';
import 'package:shop_app/models/product/products_response.dart';
import 'package:shop_app/models/product/search_products_response.dart';
import 'package:shop_app/models/user/user_logout_response.dart';
import 'package:shop_app/models/user/user_response.dart';
import 'package:shop_app/modules/home/categories/categories_screen.dart';
import 'package:shop_app/modules/home/favorites/favorites_screen.dart';
import 'package:shop_app/modules/home/products/products_screen.dart';
import 'package:shop_app/modules/home/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/categories/categories_response.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;
  ProductsResponse? productsResponse;
  CategoriesResponse? categoriesResponse;
  Map<int, bool> userFavoriteProducts = {};
  ChangeProductFavoriteResponse? changeProductFavoriteResponse;
  FavoriteProductsResponse? favoriteProductsResponse;
  UserResponse? userResponse;
  UserLogoutResponse? userLogoutResponse;
  SearchProductsResponse? searchProductsResponse;

  List<Widget> homeBottomNavScreens = [
    const ProductsScreen(),
    const FavoritesScreen(),
    const CategoriesScreen(),
    SettingsScreen()
  ];

  List<BottomNavigationBarItem> homeBottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite_rounded), label: 'Favorite'),
    BottomNavigationBarItem(
        icon: Icon(Icons.apps_rounded), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavHomeState());
  }

  void getProducts() {
    emit(LoadingHomeState());
    DioHelper.getData(url: HOME, token: userToken)
        .then((value) => {
              productsResponse = ProductsResponse.fromJson(value.data),
              for (var product in productsResponse!.data!.products)
                {
                  userFavoriteProducts
                      .addAll({product.id: product.inFavorites}),
                },
              emit(GetProductsSuccessHomeState(productsResponse)),
              debugPrint(
                  'HomeCubit (getProducts) => ${productsResponse?.data?.products[0].name.toString()}')
            })
        .catchError((error) {
      emit(GetProductsErrorHomeState(error.toString()));
      debugPrint('HomeCubit (getProducts) => ${error.toString()}');
    });
  }

  void getCategories() {
    emit(LoadingHomeState());
    DioHelper.getData(url: CATEGORIES, token: userToken)
        .then((value) => {
              categoriesResponse = CategoriesResponse.fromJson(value.data),
              emit(GetCategoriesSuccessHomeState(categoriesResponse)),
              debugPrint(
                  'HomeCubit (getCategories) => ${categoriesResponse?.data?.categories![0].name.toString()}')
            })
        .catchError((error) {
      emit(GetCategoriesErrorHomeState(error.toString()));
      debugPrint('HomeCubit (getCategories) => ${error.toString()}');
    });
  }

  void getUserFavoriteProducts() {
    emit(GetFavoriteProductsLoadingHomeState());
    DioHelper.getData(url: FAVORITES, token: userToken)
        .then((value) => {
              favoriteProductsResponse =
                  FavoriteProductsResponse.fromJson(value.data),
              emit(GetFavoriteProductsSuccessHomeState(
                  favoriteProductsResponse)),
              debugPrint(
                  'HomeCubit (getUserFavoriteProducts) => ${favoriteProductsResponse?.data?.favoriteProductsData![0].favoriteProduct!.name.toString()}')
            })
        .catchError((error) {
      emit(GetFavoriteProductsErrorHomeState(error.toString()));
      debugPrint('HomeCubit (getUserFavoriteProducts) => ${error.toString()}');
    });
  }

  void changeFavoriteProduct(int productId) {
    userFavoriteProducts[productId] = !userFavoriteProducts[productId]!;
    emit(ChangeProductFavoriteHomeState());
    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: userToken,
    )
        .then((value) => {
              changeProductFavoriteResponse =
                  ChangeProductFavoriteResponse.fromJson(value.data),
              if (!changeProductFavoriteResponse!.status!)
                {
                  userFavoriteProducts[productId] =
                      !userFavoriteProducts[productId]!,
                  debugPrint(
                      'HomeCubit (changeFavoriteProduct) => ${changeProductFavoriteResponse!.message.toString()}'),
                }
              else
                {
                  getUserFavoriteProducts(),
                },
              debugPrint(
                  'HomeCubit (changeFavoriteProduct) => ${changeProductFavoriteResponse!.message.toString()}'),
              emit(ChangeProductFavoriteSuccessHomeState(
                  changeProductFavoriteResponse)),
            })
        .catchError((error) {
      userFavoriteProducts[productId] = !userFavoriteProducts[productId]!;
      emit(ChangeProductFavoriteErrorHomeState(error.toString()));
    });
  }

  void getUserProfile() {
    emit(GetUserProfileLoadingHomeState());
    DioHelper.getData(url: PROFILE, token: userToken)
        .then((value) => {
              userResponse = UserResponse.fromJson(value.data),
              emit(GetUserProfileSuccessHomeState(userResponse)),
              debugPrint(
                  'HomeCubit (getUserProfile) => ${userResponse!.user!.name}'),
            })
        .catchError((error) {
      emit(GetUserProfileErrorHomeState(error.toString()));
      debugPrint('HomeCubit (getUserProfile) => ${error.toString()}');
    });
  }

  void updateUserProfile({
    required String email,
    // required String password,
    required String name,
    required String phone,
  }) {
    emit(UpdateUserProfileLoadingHomeState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      data: {
        "email": email,
        // "password": password,
        "name": name,
        "phone": phone,
      },
      token: userToken,
    )
        .then((value) => {
              userResponse = UserResponse.fromJson(value.data),
              emit(UpdateUserProfileSuccessHomeState(userResponse)),
              debugPrint(
                  'HomeCubit (updateUserProfile then) => ${userResponse!.user!.name}'),
            })
        .catchError((error) {
      emit(UpdateUserProfileErrorHomeState(error.toString()));
      debugPrint(
          'HomeCubit (updateUserProfile catchError) => ${error.toString()}');
    });
  }

  void userLogout(BuildContext context) {
    emit(UserLogoutLoadingHomeState());
    CacheHelper.removeData(key: 'token')
        .then((isTokenRemoved) => {
              if (isTokenRemoved)
                {
                  debugPrint(
                      'HomeCubit (isTokenRemoved) => ${isTokenRemoved.toString()}'),
                  postLogoutRequest(isTokenRemoved: isTokenRemoved),
                }
              else
                {
                  debugPrint(
                      'HomeCubit (isTokenRemoved) => ${isTokenRemoved.toString()}'),
                  emit(UserLogoutSuccessHomeState(
                      userLogoutResponse, isTokenRemoved)),
                }
            })
        .catchError((error) {
      debugPrint(
          'HomeCubit (userLogout CacheHelper.removeData catchError) => ${error.toString()}');
      emit(UserLogoutErrorHomeState(error.toString()));
    });
  }

  void postLogoutRequest({required bool isTokenRemoved}) {
    DioHelper.postData(url: LOGOUT, data: {}, token: userToken)
        .then((value) => {
              userLogoutResponse = UserLogoutResponse.fromJson(value.data),
              if (userLogoutResponse!.status!)
                {
                  debugPrint(
                      'HomeCubit (DioHelper.postData status ) => ${userLogoutResponse!.status.toString()}'),
                  emit(UserLogoutSuccessHomeState(
                      userLogoutResponse, isTokenRemoved)),
                }
              else
                {
                  debugPrint(
                      'HomeCubit (DioHelper.postData status ) => ${userLogoutResponse!.status.toString()}'),
                  setTokenBackToCache(isTokenRemoved: isTokenRemoved),
                }
            })
        .catchError((error) {
      setTokenBackToCache(isTokenRemoved: isTokenRemoved);
      emit(UserLogoutErrorHomeState(error.toString()));
      debugPrint(
          'HomeCubit (userLogout DioHelper.postData catchError) => ${error.toString()}');
    });
  }

  void setTokenBackToCache({required bool isTokenRemoved}) {
    CacheHelper.setData(key: 'token', value: userToken)
        .then((value) => {
              if (value)
                {
                  debugPrint(
                      'HomeCubit (setTokenBackToCache) then => TOKEN SET BACK CACHE'),
                  emit(UserLogoutSuccessHomeState(
                      userLogoutResponse, isTokenRemoved)),
                }
            })
        .catchError((error) {
      debugPrint(
          'HomeCubit (setTokenBackToCache) catchError => ${error.toString()}');
      emit(UserLogoutErrorHomeState(error.toString()));
    });
  }

  void getSearchProducts({required String searchValue}) {
    emit(GetSearchProductsLoadingHomeState());
    DioHelper.postData(url: SEARCH, data: {'text': searchValue}, token: userToken
    ).then((value) => {
      searchProductsResponse = SearchProductsResponse.fromJson(value.data),
      emit(GetSearchProductsSuccessHomeState(searchProductsResponse)),
      debugPrint('HomeCubit (getSearchProducts then) => ${searchProductsResponse!.status.toString()}')
    }).catchError((error) {
      emit(GetSearchProductsErrorHomeState(error.toString()));
      debugPrint('HomeCubit (getSearchProducts catchError) => ${error.toString()}');
    });
  }
}
