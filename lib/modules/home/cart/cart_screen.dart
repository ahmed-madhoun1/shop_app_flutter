
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/models/product/cart_products_response.dart';
import 'package:shop_app/shared/components/components.dart';

class CartScreen extends StatelessWidget {

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      checkCartStatus(state: state);
    }, builder: (context, state) {
      List<CartItem>? cartItems = homeCubit
          .cartProductsResponse!
          .cartProductsData
          .cartItems;
      return state is! GetCartProductsLoadingHomeState
          ? SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, state) => Container(
                  color: HexColor('CDCDCD'),
                  height: 0.5,
                  width: double.infinity,
                ),
                itemBuilder: (context, index) => buildCartProductItem(state, cartItems![index], context, homeCubit),
                itemCount: cartItems!.length,
              ),
              const SizedBox(height: 20.0,),
              Row(
                children: [
                  const Text('Items'),
                  const Spacer(),
                  Text(cartItems.length.toString()),
                ],
              ),
              const SizedBox(height: 10.0,),
              Row(
                children: [
                  const Text('Total items'),
                  const Spacer(),
                  Text(homeCubit.totalItems.toString()),
                ],
              ),
              const SizedBox(height: 10.0,),
              Row(
                children: [
                  const Text('Total Price'),
                  const Spacer(),
                  Text('£ ${homeCubit.totalItemsPrice}'),
                ],
              ),
              const SizedBox(height: 20.0,),
              defaultButton(
                label: 'Order Now',
                isButtonLoading: false,
                onPressed: (){

                },
              ),
            ],
          ),
        ),
      ) : const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget buildCartProductItem(HomeStates state, CartItem cartItem, BuildContext context, HomeCubit homeCubit) {
    return SizedBox(
      height: 120.0,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(cartItem.cartProduct.image),
                fit: BoxFit.contain,
                height: 120.0,
                width: 120.0,
              ),
              if (cartItem.cartProduct.discount != 0)
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
                Text(cartItem.cartProduct.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.0, height: 1.3)),
                const Spacer(),
                Row(
                  children: [
                    Text('${cartItem.cartProduct.price.round()}',
                        style: const TextStyle(fontSize: 12.0)),
                    const SizedBox(
                      width: 10.0,
                    ),
                    if (cartItem.cartProduct.discount != 0)
                      Text('${cartItem.cartProduct.oldPrice.round()}',
                          style: const TextStyle(
                              fontSize: 10.0,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.red)),
                    const Spacer(),
                    Text(
                      homeCubit.userCartItemsQuantity[cartItem.id].toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    IconButton(
                      highlightColor: Colors.blueGrey,
                      icon: HomeCubit.get(context)
                          .userCartProducts[cartItem.cartProduct.id!]!
                          ? const Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.red,
                      )
                          : const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        HomeCubit.get(context).changeCartProduct(cartItem.cartProduct);
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
}
