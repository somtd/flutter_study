import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../products/product_card.dart';
import '../../models/product.dart';
import '../../scoped_models/main.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCard;
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
      // } else {
      //   productCard = Center(
      //     child: Text('No Products found. Please add some!'),
      //   );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}
