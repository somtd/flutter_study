import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProducts on Model {
  List<Product> products = [];
  int selProductIndex;
  User authenticatedUser;

  void addProduct(
      String title, String description, String image, double price) {
    final newProduct = Product(
      title: title,
      description: description,
      image: image,
      price: price,
      userEmail: authenticatedUser.email,
      userId: authenticatedUser.id,
    );
    products.add(newProduct);
    selProductIndex = null;
    notifyListeners();
  }
}
