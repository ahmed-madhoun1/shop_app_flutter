import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/models/categories/categories_response.dart';
import 'package:shop_app/models/product/products_response.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        checkFavoriteStatus(state: state);
        checkCartStatus(state: state);
      },
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return homeCubit.productsResponse != null &&
                homeCubit.categoriesResponse != null
            ? productsBuilder(homeCubit.productsResponse!,
                homeCubit.categoriesResponse!, context, homeCubit)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget productsBuilder(
          ProductsResponse productsResponse,
          CategoriesResponse categoriesResponse,
          BuildContext context,
          HomeCubit homeCubit) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: productsResponse.data?.banners
                  .map((e) => Image(
                        image: NetworkImage(e.image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => buildCategoryItem(
                      categoriesResponse.data!.categories![index]),
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                  itemCount: categoriesResponse.data!.categories!.length),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'New',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              color: HexColor('F1F1F1'),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.31,
                children: List.generate(
                    productsResponse.data!.products.length,
                    (index) => buildProductItem(
                        productsResponse.data!.products[index],
                        context,
                        homeCubit)),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(Category category) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(category.image),
            height: 100.0,
            width: 150.0,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(
              .8,
            ),
            width: 150.0,
            height: 20.0,
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      );

  Widget buildProductItem(
          Product product, BuildContext context, HomeCubit homeCubit) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(product.image),
                  width: double.infinity,
                  fit: BoxFit.contain,
                  height: 200,
                ),
                if (product.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text('DISCOUNT',
                        style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  )
              ],
            ),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.0, height: 1.3)),
            Row(
              children: [
                Text('${product.price.round()}',
                    style: const TextStyle(fontSize: 12.0)),
                const SizedBox(
                  width: 10.0,
                ),
                if (product.discount != 0)
                  Text('${product.oldPrice.round()}',
                      style: const TextStyle(
                          fontSize: 10.0,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red)),
                const Spacer(),
                IconButton(
                  highlightColor: Colors.blueGrey,
                  icon: homeCubit.userFavoriteProducts[product.id]!
                      ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.red,
                        ),
                  onPressed: () {
                    homeCubit.changeFavoriteProduct(product.id);
                  },
                ),
                IconButton(
                  highlightColor: Colors.blueGrey,
                  icon: homeCubit.userCartProducts[product.id]!
                      ? const Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.red,
                        ),
                  onPressed: () {
                    if (!homeCubit.userCartProducts[product.id]!) {
                      showAddToCartBottomSheet(context, product, homeCubit);
                    } else {
                      homeCubit.changeCartProduct(product);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      );

  void showAddToCartBottomSheet(
      BuildContext context, Product product, HomeCubit homeCubit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.5),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (homeCubit.quantity > 1) {
                              homeCubit.decreaseCartItemQuantity();
                            }
                          },
                          child: Container(
                            child: const Icon(
                              Icons.remove_rounded,
                              size: 30.0,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(10.0),
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                        Container(
                          child: Text(
                            homeCubit.quantity.toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: primaryColor, width: 2.0),
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(20.0),
                          width: 150.0,
                          height: 60.0,
                        ),
                        InkWell(
                          onTap: () {
                            homeCubit.increaseCartItemQuantity();
                          },
                          child: Container(
                            child: const Icon(
                              Icons.add_rounded,
                              size: 30.0,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(10.0),
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                        color: primaryColor,
                        child: const Text(
                          'ADD TO CART',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          homeCubit.changeCartProduct(product);
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    ).whenComplete(() => {
          homeCubit.resetQuantity(),
        });
  }
}
