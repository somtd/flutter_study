import 'package:flutter/material.dart';

import 'package:map_view/location.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/location_data.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  // EditPageから呼ばれる
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  Uri _staticMapUri;
  LocationData _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      getStaticMap(widget.product.location.address);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }
    // productがなかった場合、新規で地図を取りに行く（新規作成時）
    if (widget.product == null) {
      final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
          {'address': address, 'key': DotEnv().env['GOOGLE_MAP_API_KEY']});
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final coords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
        address: formattedAddress,
        latitude: coords['lat'],
        longitude: coords['lng'],
      );
      // productがあった場合（つまり既存productの編集）
    } else {
      _locationData = widget.product.location;
    }
    // Geocoding APIとMaps Static APIを有効にする必要あり
    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider(DotEnv().env['GOOGLE_MAP_API_KEY']);
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers([
      Marker(
        'position',
        'Position',
        _locationData.latitude,
        _locationData.longitude,
      )
    ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    widget.setLocation(_locationData);
    setState(() {
      _addressInputController.text = _locationData.address;
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    var textFormField = TextFormField(
      focusNode: _addressInputFocusNode,
      controller: _addressInputController,
      validator: (String value) {
        if (_locationData == null || value.isEmpty) {
          return 'No valid location found';
        }
      },
      decoration: InputDecoration(labelText: 'Address'),
    );
    return Column(children: <Widget>[
      textFormField,
      SizedBox(
        height: 10.0,
      ),
      //TODO:アドレス入っていないときの対応もう少しマシにする。
      _staticMapUri != null
          ? Image.network(_staticMapUri.toString())
          : SizedBox(
              height: 10.0,
            ),
    ]);
  }
}
