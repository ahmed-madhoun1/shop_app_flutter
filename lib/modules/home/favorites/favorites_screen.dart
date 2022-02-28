import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/models/product/favorite_products_response.dart';
import 'package:shop_app/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          checkFavoriteStatus(state: state);
          checkCartStatus(state: state);
        },
        builder: (context, state) {
          List<FavoriteProductData> favoriteProductsData =
              HomeCubit.get(context).favoriteProductsResponse!.data!.favoriteProductsData!;
          return state is! GetFavoriteProductsLoadingHomeState
              ? ListView.separated(
                  separatorBuilder: (context, state) => Container(color: HexColor('CDCDCD'),height: 0.5, width: double.infinity,),
                  itemBuilder: (context, index) => buildFavoriteProductItem(favoriteProductsData[index], context),
                  itemCount: favoriteProductsData.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget buildFavoriteProductItem(FavoriteProductData favoriteProductData, BuildContext context) =>
      Container(
        padding: const EdgeInsets.all(20.0),
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image:
                      NetworkImage(favoriteProductData.favoriteProduct!.image),
                  fit: BoxFit.contain,
                  height: 120.0,
                  width: 120.0,
                ),
                if (favoriteProductData.favoriteProduct!.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text('DISCOUNT',
                        style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  )
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(favoriteProductData.favoriteProduct!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0, height: 1.3)),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                          '${favoriteProductData.favoriteProduct!.price.round()}',
                          style: const TextStyle(fontSize: 12.0)),
                      const SizedBox(
                        width: 10.0,
                      ),
                      if (favoriteProductData.favoriteProduct!.discount != 0)
                        Text(
                            '${favoriteProductData.favoriteProduct!.oldPrice.round()}',
                            style: const TextStyle(
                                fontSize: 10.0,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.red)),
                      const Spacer(),
                      IconButton(
                        highlightColor: Colors.blueGrey,
                        icon: HomeCubit.get(context).userFavoriteProducts[
                                favoriteProductData.favoriteProduct!.id]!
                            ? const Icon(
                                Icons.favorite_rounded,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.red,
                              ),
                        onPressed: () {
                          HomeCubit.get(context).changeFavoriteProduct(favoriteProductData.favoriteProduct!.id);
                        },
                      ),
                      IconButton(
                        highlightColor: Colors.blueGrey,
                        icon: HomeCubit.get(context).userCartProducts[favoriteProductData.favoriteProduct!.id]! ? const Icon(Icons.shopping_cart_rounded, color: Colors.red,) : const Icon(Icons.add_shopping_cart_rounded, color: Colors.red,),
                        onPressed: () {
                          HomeCubit.get(context).changeCartProduct(favoriteProductData.favoriteProduct!.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
