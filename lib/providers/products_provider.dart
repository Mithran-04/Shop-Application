import 'package:flutter/material.dart';
import 'package:shop_application/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop_application/models/http_exception.dart';


class Products with ChangeNotifier {
  List<Product>_items=[
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt- its awesome',
    //   price: 30.00,
    //   imageUrl: 'https://i0.wp.com/www.smartprix.com/bytes/wp-content/uploads/2022/01/image-31.png?ssl=1',
    //
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'BLue shirt',
    //   description: 'A Blue shirt- its awesome',
    //   price: 30.00,
    //   imageUrl: 'https://gaadiwaadi.com/wp-content/uploads/2021/09/Ultraviolette-F77-launch-in-march-2022-997x720.jpg',
    //
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Green Shirt',
    //   description: 'A Green shirt- its awesome',
    //   price: 30.00,
    //   imageUrl: 'https://4.imimg.com/data4/GC/MR/ANDROID-62332019/product-500x500.jpeg',
    //
    // ),

  ];

  // var _showFavoritesOnly=false;
  final String authToken,userId;
  Products(this.authToken,this.userId,this._items);
  List<Product> get items{
       // if(_showFavoritesOnly){
       //   return _items.where((prodItem)=> prodItem.isFavorite).toList();
       // }
       return [..._items];
  }

  List<Product> get favoriteItems{
    return _items.where((prodItem)=> prodItem.isFavorite).toList();
  }
  
  Product findById(String id){
    return _items.firstWhere((prod) => prod.id==id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly=true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly=false;
  //   notifyListeners();
  // }
  Future <void> fetchAndSetProducts([bool filterByUser=false]) async {
    var _params;
    if(filterByUser) {
      _params = <String, String>{
        'auth': authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }
      if(filterByUser==false){
        _params = <String, String>{
          'auth': authToken,
        };
    }
    var url = Uri.https(
        "shop-application-340f4-default-rtdb.firebaseio.com", "/products.json",_params);
    try {
      final response = await http.get(url);
      final extractedData= json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null) {
        return;
      }
      url=Uri.https("shop-application-340f4-default-rtdb.firebaseio.com", "userFavorites/$userId.json",{"auth":'$authToken'});
      final favoriteResponse=await http.get(url);
      final favoriteData=json.decode(favoriteResponse.body);
      final List <Product> loadedProducts=[];
      extractedData.forEach((prodId,prodData){
        loadedProducts.add(Product(
          id:prodId,
          title: prodData['title'],
          description: prodData['description'],
          price :prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favoriteData==null ? false: favoriteData[prodId] ?? false,
        ));
      });
      _items=loadedProducts;
      notifyListeners();
    }
    catch(error) {
      throw(error);
    }
    }


  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'shop-application-340f4-default-rtdb.firebaseio.com', '/products.json',{'auth':'$authToken'});
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId,
      }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl
      );
      _items.add(newProduct);
      notifyListeners();
    }
    catch (error) {
      print(error);
      throw error;
    }
    }



  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex=_items.indexWhere((prod) => prod.id==id);
    if(prodIndex>=0) {
      final url = Uri.https(
          'shop-application-340f4-default-rtdb.firebaseio.com', '/products/$id.json',{'auth':'$authToken'});
      await http.patch(url,
          body: json.encode({
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'title': newProduct.title,
      }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else{
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = Uri.https(
        'shop-application-340f4-default-rtdb.firebaseio.com', '/products/$id.json',{'auth':'$authToken'});
    final existingProductIndex=_items.indexWhere((prod) => prod.id==id);
    Product? existingProduct= _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response=await http.delete(url);
    print(json.decode(response.body));
      if(response.statusCode>=400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw Exception('Could not delete product.');
      }
      existingProduct=null;


  }

}