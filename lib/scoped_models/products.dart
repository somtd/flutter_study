import '../models/product.dart';
import '../scoped_models/connected_products.dart';

mixin ProductsModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    // 参照ではなく、コピーを返す（Newのようなもの）
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(products);
  }

  int get selectedProductIndex {
    return selectedProductIndex;
  }

  Product get selectedProduct {
    return selectedProductIndex == null ? null : products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(Product product) {
    products[selectedProductIndex] = product;
    selProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isProductFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isProductFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    products[selectedProductIndex] = updatedProduct;
    // 全てのScopedModelに変更を通知して、再描画させる。
    notifyListeners();
    selProductIndex = null;
  }

  void selectProduct(int index) {
    selProductIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
