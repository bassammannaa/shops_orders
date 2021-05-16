import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/screens/edit_product_screen.dart';
import 'package:shops_orders/widgets/app_drawer_widget.dart';
import 'package:shops_orders/widgets/user_product_item_widget.dart';
//..
import '../providers/products_provider.dart';

class UserProdcutsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx,productsData,_) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (ctx, indx) {
                            return Column(
                              children: [
                                UserProductItemWidget(
                                    productsData.items[indx].id,
                                    productsData.items[indx].title,
                                    productsData.items[indx].imageUrl),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
