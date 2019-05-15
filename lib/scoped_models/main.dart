import 'package:scoped_model/scoped_model.dart';

import 'package:first_app/scoped_models/products.dart';
import 'package:first_app/scoped_models/user.dart';

class MainModel extends Model with UserModel, ProductsModel {}
