
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/providers/auth_provider.dart';
import 'package:shops_orders/screens/orders_screen.dart';
import 'package:shops_orders/screens/user_products_screen.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello friends'),
            automaticallyImplyLeading: false,

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProdcutsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}

