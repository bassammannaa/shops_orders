import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item_widget.dart';

class ProductGridWidget extends StatelessWidget {
  final bool showFavs;

  ProductGridWidget(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productProviderData = Provider.of<ProductsProvider>(context);
    final products = showFavs? productProviderData.favoriteItems:  productProviderData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItemWidget(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
