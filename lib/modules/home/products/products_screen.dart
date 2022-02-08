import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/models/categories/categories_response.dart';
import 'package:shop_app/models/product/products_response.dart';
import 'package:shop_app/shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if(state is ChangeProductFavoriteSuccessHomeState){
          if(!state.changeProductFavoriteResponse!.status!){
            showToast(message: state.changeProductFavoriteResponse!.message.toString(), toastStates: ToastStates.ERROR, longTime: false);
          }
        }
      },
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return homeCubit.productsResponse != null &&
                homeCubit.categoriesResponse != null
            ? productsBuilder(homeCubit.productsResponse!, homeCubit.categoriesResponse!, context)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget productsBuilder(
      ProductsResponse productsResponse,
      CategoriesResponse categoriesResponse,
      BuildContext context
      ) => SingleChildScrollView(
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
                      )).toList(),
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
            Container(
              height: 150,
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => buildCategoryItem(categoriesResponse.data!.categories![index]),
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
                    (index) => buildProductItem(productsResponse.data!.products[index], context)),
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

  Widget buildProductItem(Product product, BuildContext context) => Container(
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
                  icon: HomeCubit.get(context).userFavoriteProducts[product.id]! ? const Icon(Icons.favorite_rounded, color: Colors.red,) : const Icon(Icons.favorite_border_rounded, color: Colors.red,),
                  onPressed: () {
                    HomeCubit.get(context).changeFavoriteProduct(product.id);
                  },
                ),
              ],
            )
          ],
        ),
      );
}
