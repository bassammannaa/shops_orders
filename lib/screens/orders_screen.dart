import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//..
import '../widgets/app_drawer_widget.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawerWidget(),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.error != null) {
              return Center(child: Text('An error occurred'));
            } else {
              return Consumer<OrdersProvider>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) {
                    return OrderItemWidget(orderData.orders[i]);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
