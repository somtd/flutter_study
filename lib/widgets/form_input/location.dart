import 'package:flutter/material.dart';
import 'package:map_view/location.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  @override
  void initState() {
    getStaticMap();
    super.initState();
  }

  void getStaticMap() {
    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider(DotEnv().env['GOOGLE_MAP_API_KEY']);
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', 41.40338, 2.17403)],
        center: Location(41.40338, 2.17403),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    setState(() {
      _staticMapUri = staticMapUri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextFormField(),
      SizedBox(
        height: 10.0,
      ),
      Image.network(_staticMapUri.toString()),
    ]);
  }
}
