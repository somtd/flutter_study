import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'accept_terms': false,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BoxDecoration _buildBackGroundDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5),
          BlendMode.dstATop,
        ),
        image: AssetImage('assets/background.jpg'),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-Mail',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'E-Mail is required and should be a correct E-Mail address.';
        }
      },
      onSaved: (String value) {
        setState(() {
          _formData['email'] = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Password is required and should be 10+ characters long.';
        }
      },
      onSaved: (String value) {
        setState(() {
          _formData['password'] = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['accept_terms'],
      onChanged: (bool value) {
        setState(() {
          _formData['accept_terms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate() || !_formData['accept_terms']) {
      return;
    }
    _formKey.currentState.save();
    print(_formData['email']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Container(
          decoration: _buildBackGroundDecoration(),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                width: targetWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildAcceptSwitch(),
                      RaisedButton(
                        child: Text('Login'),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        onPressed: _submitForm,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
