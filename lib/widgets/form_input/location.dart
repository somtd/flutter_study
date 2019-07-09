import 'package:flutter/material.dart';

import 'package:map_view/location.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  Uri _staticMapUri;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    //getStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      return;
    }
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': DotEnv().env['GOOGLE_MAP_API_KEY']});
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];

    // Geocoding APIとMaps Static APIを有効にする必要あり
    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider(DotEnv().env['GOOGLE_MAP_API_KEY']);
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', coords['lat'], coords['lng'])],
        center: Location(coords['lat'], coords['lng']),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    setState(() {
      _addressInputController.text = formattedAddress;
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
      decoration: InputDecoration(labelText: 'Address'),
    );
    return Column(children: <Widget>[
      textFormField,
      SizedBox(
        height: 10.0,
      ),
      Image.network(_staticMapUri.toString()),
    ]);
  }
}
