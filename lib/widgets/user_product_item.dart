import 'package:flutter/material.dart';
import 'package:shop_application/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final  String imageUrl;
  final String id;


  UserProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
    leading: CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
    ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed:(){
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            } ,
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),

            IconButton(
      onPressed:() async{
        try {
          await Provider.of<Products>(context, listen: false).deleteProduct(id);
        } catch(error){
          scaffold.showSnackBar(
              SnackBar(
                  content: Text("Error occurred while deleting! ", textAlign: TextAlign.center,)
              )
          );

        }
           },
      icon: Icon(Icons.delete),
      color: Theme.of(context).errorColor,),
          ],
        ),
      ),

    );
  }
}
