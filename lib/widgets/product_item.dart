import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/product.dart';
import 'package:flutter/material.dart';
import'package:shop_application/screens/product_detail_screen.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/auth.dart';

class ProductItem extends StatelessWidget {

  // ProductItem();
  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Product>(context,listen: false);
    final cart =Provider.of<Cart>(context,listen: false);
    final authData=Provider.of<Auth>(context,listen:false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(

          child: GestureDetector(

            onTap:(){
              Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,arguments:product.id );
            },

            child: Image.network(product.imageUrl,
              fit: BoxFit.cover),
          ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading:Consumer<Product>(
                builder: (ctx,product,_)=> IconButton(
                  icon:Icon
                    (product.isFavorite? Icons.favorite : Icons.favorite_border,),
                  onPressed: (){
                    product.toggleFavoriteStatus(authData.token!,authData.userId!);
                  },
                  color:Theme.of(context).colorScheme.secondary,),
              ),
              title: Text(
              product.title,
                textAlign: TextAlign.center,
               ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
              onPressed: (){
                  cart.addItem(product.id!,product.price,product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added item  to cart!'),
                  duration: Duration(seconds:2),
                      action: SnackBarAction(label: 'UNDO', onPressed: (){
                        cart.removeSingleItem(product.id!);
                      },)));
                  },
              color: Theme.of(context).colorScheme.secondary,),
            ),
      ),
    );
  }
}
