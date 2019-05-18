import '../models/user.dart';
import '../scoped_models/connected_products.dart';

mixin UserModel on ConnectedProducts {
  void login(String email, String password) {
    authenticatedUser =
        User(id: 'retsgyetee', email: email, password: password);
  }
}
