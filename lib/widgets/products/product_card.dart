import 'package:flutter/material.dart';

import '../products/price_tag.dart';
import '../products/address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(product.title),
        SizedBox(
          width: 8.0,
        ),
        PriceTag(product.price.toString())
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      // Main Axis Alignment
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
        ),
        IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.red,
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + productIndex.toString())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.green,
      child: Column(
        children: <Widget>[
          Container(
            child: Image.asset(product.image),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: _buildTitlePriceRow(),
          ),
          AddressTag('Kamakura JAPAN'),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
