import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/models/http_exception.dart';
import 'dart:convert';
import 'product.dart';

import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavouritesOnly = false;

  List<Product> get items {
    if (_showFavouritesOnly) {
      return _items.where((prodItem) => prodItem.isFavourite).toList();
    }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   notifyListeners();
  //   _showFavouritesOnly = false;
  // }
//filter by user is false by default, we do this, to pass whether to filter products or not
  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    var filterString =
        filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shopmate-88-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final userfavourites = Uri.parse(
          'https://shopmate-88-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourites/$userId.json?auth=$authToken');
      final favouriteResponse = await http.get(userfavourites);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts.reversed.toList();
      // _items = _items.reversed;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopmate-88-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'createrId': userId,
        }),
      );
      final newProduct = Product(
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        title: product.title,
        id: json.decode(response.body)['name'], //unique id
      );
      _items.insert(0, newProduct); //add in the beginning
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    // _items.add(value);
    //  _items.add(newProduct); // add product (end)
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopmate-88-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
      try {
        await http
            .patch(url,
                body: json.encode({
                  'title': newProduct.title,
                  'description': newProduct.description,
                  'imageUrl': newProduct.imageUrl,
                  'price': newProduct.price,
                  // we do not update isFavourite
                }))
            .then(
          (_) {
            _items[prodIndex] = newProduct;
            notifyListeners();
          },
        );
      } catch (error) {
        throw (error);
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopmate-88-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException('Could not delete product');
      // print('error happened here');
    }
    existingProduct = null;

    // _items.removeWhere((prod) => prod.id == id);
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}
