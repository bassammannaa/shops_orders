import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/providers/cart_provider.dart';
import 'package:shops_orders/providers/orders_provider.dart';
import 'package:shops_orders/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                // SizedBox(
                //   width: 10,
                // ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                // ignore: deprecated_member_use
                OrderButton(cart),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, index) {
                return CartItemWidget(
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].id,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final CartProvider cart;
  OrderButton(this.cart);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading )
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrdersProvider>(context, listen: false)
            .addOrder(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
      child: _isLoading? CircularProgressIndicator(): Text('Order Now'),
    );
  }
}

