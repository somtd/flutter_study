import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;

  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        "\$$price",
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
