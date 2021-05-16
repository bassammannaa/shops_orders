import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shops_orders/models/constant.dart';
import 'package:http/http.dart' as http;
class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;


  ProductProvider({@required this.id,
          @required this.title,
          @required this.description,
          @required this.price,
          @required this.imageUrl,
          this.isFavorite = false});

  void _setFavorite(bool oldStatus){
    isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    Map<String, String> queryParamters = {
      'auth': token,
    };

    final Uri url = Uri.https(Constant.fireBaseHost, '/userFavorites/$userId/$id.json', queryParamters);
    try {
     final response= await http.put(url, body: json.encode(isFavorite));
     if (response.statusCode >= 400){
       _setFavorite(oldStatus);
     }
    } catch (error){
      _setFavorite(oldStatus);
    }


  }

}
