import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/screens/cart_screen.dart';
import 'package:shop_application/widgets/product_item.dart';
import'package:shop_application/screens/products_overview_screen.dart';
import 'package:shop_application/screens/product_detail_screen.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/orders.dart';
import 'package:shop_application/screens/orders_screen.dart';
import 'package:shop_application/screens/user_products_screen.dart';
import 'package:shop_application/screens/edit_product_screen.dart';
import 'package:shop_application/screens/auth_screen.dart';
import 'package:shop_application/providers/auth.dart';
import 'package:shop_application/screens/splash_screen.dart';


void main()=>runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(
        create: (ctx)=>Auth(),
      ),
        ChangeNotifierProxyProvider<Auth,Products>(
        update: (ctx,auth,previousProducts)=>Products(
          auth.token ?? '',
          auth.userId ?? '',
          previousProducts!.items==null ? []: previousProducts.items,
        ),
          create: (context) => Products('','', []),
        ),
      ChangeNotifierProvider(
          create :(ctx)=> Cart(),
      ),
      ChangeNotifierProxyProvider<Auth,Orders>(
          update: (ctx,auth,previousOrders)=>Orders(
            auth.token!,
            auth.userId!,
            previousOrders!.orders==null ? []: previousOrders.orders,
          ),
          create: (ctx)=> Orders('','',[])
      ),
    ],
      child: Consumer<Auth>(builder:(ctx,auth,_)=>MaterialApp(
        title: 'MyShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth
            ?ProductsOverviewScreen()
            :FutureBuilder(
            future: auth.tryAutoLogIn(),
            builder: (ctx,authResultSnapshot)=>
            authResultSnapshot.connectionState==
                ConnectionState.waiting
                ?SplashScreen():
             AuthScreen(),
        ),
        routes: {
          ProductDetailScreen.routeName:(ctx)=>ProductDetailScreen(),
          CartScreen.routeName:(ctx)=> CartScreen(),
          OrdersScreen.routeName:(ctx)=> OrdersScreen(),
          UserProductsScreen.routeName:(ctx)=> UserProductsScreen(),
          EditProductScreen.routeName:(ctx)=>EditProductScreen(),
        },
      ),
      )
    );
  }
}





