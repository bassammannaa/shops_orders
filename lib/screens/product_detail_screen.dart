import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final producId = ModalRoute.of(context).settings.arguments as String;
    final _loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(producId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_loadedProduct.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${_loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
                child: Text(
              _loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            )),
          ],
        ),
      ),
    );
  }
}
