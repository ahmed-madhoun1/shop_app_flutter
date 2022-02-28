
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/product/cart_products_response.dart';
import 'package:shop_app/models/product/change_product_cart_response.dart';
import 'package:shop_app/models/product/change_product_favorite_response.dart';
import 'package:shop_app/models/product/favorite_products_response.dart';
import 'package:shop_app/models/product/products_response.dart';
import 'package:shop_app/models/product/search_products_response.dart';
import 'package:shop_app/models/product/update_cart_item_quantity_response.dart';
import 'package:shop_app/models/user/user_logout_response.dart';
import 'package:shop_app/models/user/user_response.dart';
import 'package:shop_app/modules/home/cart/cart_screen.dart';
import 'package:shop_app/modules/home/favorites/favorites_screen.dart';
import 'package:shop_app/modules/home/products/products_screen.dart';
import 'package:shop_app/modules/home/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/categories/categories_response.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  bool isDark = true;
  int currentIndex = 0;
  ProductsResponse? productsResponse;
  CategoriesResponse? categoriesResponse;
  Map<int, bool> userFavoriteProducts = {};
  Map<int, bool> userCartProducts = {};
  Map<int, int> userCartItemsQuantity = {};
  ChangeProductFavoriteResponse? changeProductFavoriteResponse;
  ChangeProductCartResponse? changeProductCartResponse;
  FavoriteProductsResponse? favoriteProductsResponse;
 late CartProductsResponse? cartProductsResponse;
  UserResponse? userResponse;
  UserLogoutResponse? userLogoutResponse;
  SearchProductsResponse? searchProductsResponse;
  UpdateCartItemQuantityResponse? updateCartItemQuantityResponse;
  int quantity = 1;
  double totalItemsPrice = 0;
  dynamic totalItems = 0;

  /// Change Application Mode (Light, Dark)
  void changeAppMode({isDarkShared}) {
    if(isDarkShared != null){
      isDark = isDarkShared;
      emit(ChangeModeAppState());
      debugPrint("changeAppMode isDarkShared => " + isDarkShared.toString());
    }else{
      isDark = !isDark;
      CacheHelper.setData(key: 'isDark', value: isDark).then((value) => {
        emit(ChangeModeAppState()),
        debugPrint("changeAppMode isDark => " + isDarkShared.toString()),
      });
    }
  }

  List<Widget> homeBottomNavScreens = [
    const ProductsScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    SettingsScreen()
  ];

  List<BottomNavigationBarItem> homeBottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite_rounded), label: 'Favorite'),
    BottomNavigationBarItem(
        icon: Icon(Icons.card_giftcard_rounded), label: 'Cart'),
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
              userFavoriteProducts.addAll({product.id: product.inFavorites}),
              userCartProducts.addAll({product.id: product.inCart}),
            },
          emit(GetProductsSuccessHomeState(productsResponse)),
          debugPrint('HomeCubit (getProducts) => ${productsResponse?.data?.products[0].name.toString()}')
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

  void getUserCartProducts() {
    emit(GetCartProductsLoadingHomeState());
    DioHelper.getData(
      url: CART, token: userToken,
    ).then((value) => {
      cartProductsResponse = CartProductsResponse.fromJson(value.data),
      for (var cartItem in cartProductsResponse!.cartProductsData.cartItems!){
        userCartItemsQuantity.addAll({cartItem.id: cartItem.quantity}),
      },
      calculateCartItems(cartProductsResponse!.cartProductsData.cartItems),
      emit(GetCartProductsSuccessHomeState(cartProductsResponse)),
      debugPrint('HomeCubit (getUserCartProducts) => ${cartProductsResponse?.cartProductsData.cartItems![0].cartProduct.name.toString()}')
    }).catchError((error) {
      emit(GetCartProductsErrorHomeState(error.toString()));
      debugPrint('HomeCubit (getUserCartProducts) => ${error.toString()}');
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

  void changeCartProduct(product) {
    int savedQuantity = quantity;
    userCartProducts[product.id] = !userCartProducts[product.id]!;
    emit(ChangeProductCartHomeState());
    DioHelper.postData(
      url: CART,
      data: {'product_id': product.id},
      token: userToken,
    ).then((value) => {
      changeProductCartResponse = ChangeProductCartResponse.fromJson(value.data),
      if (!changeProductCartResponse!.status!){
        userCartProducts[product.id] = !userCartProducts[product.id]!,
        debugPrint('HomeCubit (changeCartProduct) => ${changeProductCartResponse!.message.toString()}'),
      } else {
        if(userCartProducts[product.id]!){
          userCartItemsQuantity.addAll({changeProductCartResponse!.cartItem.id : savedQuantity}),
          updateCartItemQuantity(cartItemId: changeProductCartResponse!.cartItem.id, quantity: savedQuantity),
          getUserCartProducts(),
        }else{
          getUserCartProducts(),
        },
      },
      debugPrint('HomeCubit (changeCartProduct) => ${changeProductCartResponse!.message.toString()}'),
      emit(ChangeProductCartSuccessHomeState(changeProductCartResponse)),
    }).catchError((error) {
      userCartProducts[product.id] = !userCartProducts[product.id]!;
      emit(ChangeProductCartErrorHomeState(error.toString()));
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

  Future<void> updateCartItemQuantity({required int cartItemId, required int quantity}) async {
    emit(UpdateCartItemQuantityLoadingHomeState());
    int oldQuantity = userCartItemsQuantity[cartItemId]!;
    userCartItemsQuantity.update(cartItemId, (value) => quantity);
    DioHelper.putData(
        url: UPDATE_CART_ITEM_QUANTITY + cartItemId.toString(),
        data: {"quantity": quantity},
        token: userToken,
    ).then((value) => {
      updateCartItemQuantityResponse = UpdateCartItemQuantityResponse.fromJson(value.data),
      if(!updateCartItemQuantityResponse!.status!){
        userCartItemsQuantity.update(cartItemId, (value) => oldQuantity),
        showToast(message: updateCartItemQuantityResponse!.message.toString(), toastStates: ToastStates.ERROR, longTime: true),
      },
      emit(UpdateCartItemQuantitySuccessHomeState(updateCartItemQuantityResponse)),
      debugPrint('HomeCubit (updateCartItemQuantity DioHelper.putData then) => ${updateCartItemQuantityResponse!.data.cart.quantity.toString()}'),
    }).catchError((error){
      userCartItemsQuantity.update(cartItemId, (value) => oldQuantity);
      showToast(message: 'Something went wrong!', toastStates: ToastStates.ERROR, longTime: true);
      emit(UpdateCartItemQuantityErrorHomeState(error.toString()));
      debugPrint('HomeCubit (updateCartItemQuantity DioHelper.putData catchError) => ${error.toString()}');
    });
  }

  void increaseCartItemQuantity(){
    quantity++;
    emit(ChangeCartItemQuantityHomeState());
  }

  void decreaseCartItemQuantity(){
    quantity--;
    emit(ChangeCartItemQuantityHomeState());
  }

  void resetQuantity(){
    quantity= 1;
  }

  void calculateCartItems(List<dynamic>? cartItems){
    totalItemsPrice = 0;
    totalItems = 0;
    if(cartItems != null && cartItems.isNotEmpty){
      for (var cartItem in cartItems) {
        totalItemsPrice += cartItem.cartProduct.price * cartItem.quantity;
        totalItems += cartItem.quantity;
      }
    }
    emit(CalculateCartItemsHomeState());
  }
}
