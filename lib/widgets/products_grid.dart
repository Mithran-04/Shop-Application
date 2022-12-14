import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/widgets/product_item.dart';

import '../providers/products_provider.dart';
class ProductsGird extends StatelessWidget {
  final bool showFavs;
  ProductsGird(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    final products=showFavs?productsData.favoriteItems: productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
         value: products[i],
          child: ProductItem(),
      ),
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,


    );
  }
}


