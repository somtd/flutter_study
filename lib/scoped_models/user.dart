import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';

class UserModel extends Model {
  User _autenticatedUser;

  void login(String email, String password) {
    _autenticatedUser =
        User(id: 'retsgyetee', email: email, password: password);
  }
}
