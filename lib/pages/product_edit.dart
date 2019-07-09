import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped_models/main.dart';
import '../widgets/form_input/location.dart';
import '../models/location_data.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'https://www.mary.co.jp/mary/images/topics/img_180402_main.jpg',
    'location': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField([Product product]) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: product == null ? '' : product.title,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
      },
      onSaved: (String value) {
        setState(() {
          _formData['title'] = value;
        });
      },
    );
  }

  Widget _buildDescriptionTextField([Product product]) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      initialValue: product == null ? '' : product.description,
      maxLines: 15,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long.';
        }
      },
      onSaved: (String value) {
        setState(() {
          _formData['description'] = value;
        });
      },
    );
  }

  Widget _buildPriceTextField([Product product]) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      initialValue: product == null ? '' : product.price.toString(),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number.';
        }
      },
      onSaved: (String value) {
        setState(() {
          _formData['price'] = double.parse(value);
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  void _setLocation(LocationData locationData) {
    _formData['location'] = locationData;
  }

  // selectedProductIndexは、nullである可能性がある。※optionalの引数は[]で囲む。
  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
        _formData['location'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try again'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
    }
  }

  Widget _buildPageContent(BuildContext context, [Product product]) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            //要素がスタティックな場合はbuilder使わなくてもよい。
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              LocationInput(_setLocation),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
      return model.selectedProductIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Product'),
              ),
              body: pageContent,
            );
    });
  }
}
