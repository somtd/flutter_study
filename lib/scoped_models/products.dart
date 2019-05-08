import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;

  List<Product> get products {
    // 参照ではなく、コピーを返す（Newのようなもの）
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    return _selectedProductIndex == null
        ? null
        : _products[_selectedProductIndex];
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isProductFavorite = _products[_selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isProductFavorite;
    final Product updatedProduct = Product(
        title: _products[_selectedProductIndex].title,
        description: _products[_selectedProductIndex].description,
        price: _products[_selectedProductIndex].price,
        image: _products[_selectedProductIndex].image,
        isFavorite: newFavoriteStatus);
    _products[_selectedProductIndex] = updatedProduct;
    _selectedProductIndex = null;
    // 全てのScopedModelに変更を通知して、再描画させる。
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }
}
