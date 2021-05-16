import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/providers/products_provider.dart';
import 'package:shops_orders/widgets/app_drawer_widget.dart';



import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge_widget.dart';

import '../widgets/product_gridview_widget.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreens extends StatefulWidget {
  static const routeName = '/product-overview';
  @override
  _ProductOverviewScreensState createState() => _ProductOverviewScreensState();
}

class _ProductOverviewScreensState extends State<ProductOverviewScreens> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Overview'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (ctx, cart, consumerChild) => BadgeWidget(
              child: consumerChild,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: _isLoading? Center(child: CircularProgressIndicator()): ProductGridWidget(_showOnlyFavorites),
    );
  }
}
