import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/models/product/search_products_response.dart';
import 'package:shop_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {

  TextEditingController searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<SearchProduct>? searchProducts = HomeCubit.get(context).searchProductsResponse?.searchProductsData?.searchProducts;
        return WillPopScope(
          onWillPop: (){
            if(searchProducts != null && searchProducts.isNotEmpty){
              searchProducts.clear();
            }
            Navigator.pop(context, true);
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'search should not be empty!';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search_rounded,
                        autoFocus: true,
                        onSubmit: (value){
                          if(formKey.currentState!.validate()){
                            HomeCubit.get(context).getSearchProducts(searchValue: value);
                          }
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (state is GetSearchProductsSuccessHomeState && searchProducts!.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, state) => Container(color: HexColor('CDCDCD'),height: 0.5, width: double.infinity,),
                          itemBuilder: (context, index) => buildSearchProductItem(searchProducts[index], context),
                          itemCount: searchProducts.length,
                        ),
                      ),
                    if(state is GetSearchProductsSuccessHomeState && searchProducts!.isEmpty)
                      const Expanded(child: Center(child: Text('No search value'),)),
                    if (state is GetSearchProductsLoadingHomeState)
                      const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(),
                          ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget buildSearchProductItem(SearchProduct searchProduct, BuildContext context) =>
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
                  NetworkImage(searchProduct.image),
                  fit: BoxFit.contain,
                  height: 120.0,
                  width: 120.0,
                ),
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(searchProduct.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0, height: 1.3)),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                          '${searchProduct.price.round()}',
                          style: const TextStyle(fontSize: 12.0)),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Spacer(),
                      IconButton(
                        highlightColor: Colors.blueGrey,
                        icon: HomeCubit.get(context).userFavoriteProducts[
                        searchProduct.id]!
                            ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                            : const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          HomeCubit.get(context).changeFavoriteProduct(
                              searchProduct.id);
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
