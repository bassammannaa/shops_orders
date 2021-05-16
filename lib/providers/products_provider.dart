import 'package:flutter/material.dart';
import 'package:shops_orders/models/http_exception.dart';
import 'product_provider.dart';
import '../models/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [];
  String _token;
  String _userId;
  getData(String authToken, String userId, List<ProductProvider> products) {
    _items = products;
    _token = authToken;
    _userId = userId;
    notifyListeners();
  }

  List<ProductProvider> get items {
    return [..._items];
  }

  ProductProvider findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<ProductProvider> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> editProduct(String id, ProductProvider newProduct) async {
    Map<String, String> queryParamters = {
      'auth': _token,
    };
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final Uri url = Uri.https(
          Constant.fireBaseHost, '/products/$id.json', queryParamters);
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deletProduct(String id) async {
    Map<String, String> queryParamters = {
      'auth': _token,
    };
    final Uri url =
        Uri.https(Constant.fireBaseHost, '/products/$id.json', queryParamters);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    // Remove the product locally
    _items.removeAt(existingProductIndex);
    notifyListeners();

    // Remove the product at server
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // when error add the product again
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      // throw exception for end user
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Map<String, dynamic> buildQueryParamters([bool filterByUser = false]){
    Map<String, dynamic> queryParamters = {};
    if (filterByUser){
      return queryParamters = {
        'auth': _token,
        'orderBy': '"creatorId"',
        'equalTo': '"$_userId"',
      };
    }else {
      return queryParamters = {
        'auth': _token,
      };
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    Map<String, dynamic> queryParamters = buildQueryParamters(filterByUser);

    Uri url =
        Uri.https(Constant.fireBaseHost, '/products.json', queryParamters);
    try {
      http.Response response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.https(Constant.fireBaseHost, '/userFavorites/$_userId.json',
          queryParamters);
      http.Response favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<ProductProvider> _loadedProducts = [];
      extractedData.forEach((productId, productData) {
        _loadedProducts.add(ProductProvider(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _items = _loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(ProductProvider product) async {
    Map<String, String> queryParamters = {
      'auth': _token,
    };
    final Uri url =
        Uri.https(Constant.fireBaseHost, '/products.json', queryParamters);
    try {
      final http.Response response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': _userId,
          }));
      final _newProduct = ProductProvider(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
