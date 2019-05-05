import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_manage.dart';
import './pages/products.dart';
import './pages/product_detail.dart';

import './models/product.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // bool _isAuth = false;
  List<Product> _products = [];

  // void _isLogin(bool auth) {
  //   setState(() {
  //     _isAuth = auth;
  //   });
  // }

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
  }

  void _updateProduct(Product product, int index) {
    setState(() {
      _products[index] = product;
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple,
      ),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) => ProductsManagePage(
            _addProduct, _updateProduct, _deleteProduct, _products),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductDetailPage(
                  _products[index].title,
                  _products[index].description,
                  _products[index].price,
                  _products[index].image,
                ),
          );
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => ProductsPage(_products),
        );
      },
    );
  }
}
