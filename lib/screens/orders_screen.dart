import 'package:flutter/material.dart';
import 'package:shop_application/providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import 'package:shop_application/widgets/order_item.dart';
import 'package:shop_application/widgets/app_drawer.dart';



class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName='/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture(){
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture=_obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else {
              if (dataSnapshot.error != null) {
                return Center(child: Text('Something went wrong!'),);
              }
              else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) =>
                      ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (_, i) =>
                              OrderItem(order: orderData.orders[i],)),
                );
              }
            }
          }
      ),
    );
  }
}

