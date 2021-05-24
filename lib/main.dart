import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/providers/product_provider.dart';
import 'package:shops_orders/screens/splash_screen.dart';
//..Providers
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/products_provider.dart';
import './providers/auth_provider.dart';
//..Screens
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (ctx, auth, previouseProductsProvider) => ProductsProvider()
            ..getData(
              auth.token,
              auth.userId,
              previouseProductsProvider == null
                  ? null
                  : previouseProductsProvider.items,
            ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(),
          update: (ctx, auth, previouseOrdersProvider) => OrdersProvider()
            ..getData(
              auth.token,
              auth.userId,
              previouseOrdersProvider == null
                  ? null
                  : previouseOrdersProvider.orders,
            ),
        ),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
              textTheme: TextTheme(
                headline6: TextStyle(color: Colors.white),
              ),
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductOverviewScreens()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProdcutsScreen.routeName: (ctx) => UserProdcutsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductOverviewScreens.routeName: (ctx) => ProductOverviewScreens(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: Center(
        child: Text('My Shop'),
      ),
    );
  }
}
