import 'package:flutter/material.dart';

class ProductControll extends StatelessWidget {
  final Function addProduct;

  ProductControll(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      onPressed: () {
        addProduct({'title': 'Chocolate', 'image': 'assets/food.jpg'});
      },
      child: Text("Add Product"),
    );
  }
}
