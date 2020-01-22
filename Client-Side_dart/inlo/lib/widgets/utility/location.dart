// import 'package:flutter/material.dart';
// import 'package:map_view/map_view.dart';
// import '../helpers/ensure_visible.dart';

// class GeoLocationInput extends StatefulWidget {
//   @override
//   _GeoLocationInputState createState() => _GeoLocationInputState();
// }

// class _GeoLocationInputState extends State<GeoLocationInput> {
//   Uri _staticUri;
//   final FocusNode _addressNode = FocusNode();

//   @override
//   void initState() {
//     _addressNode.addListener(_updateLocation);
//     getStaticMap();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _addressNode.removeListener(_updateLocation);
//     super.dispose();
//   }

//   void getStaticMap() async {
//     final StaticMapProvider staticMapProvider =
//         StaticMapProvider('AIzaSyDamsSPuYnjDxpG4wbEoUsrxvaIekxM9Yo');
//     final Uri staticUri = staticMapProvider.getStaticUriWithMarkers(
//       [Marker('position', 'Position', 24.9053295, 91.8380536)],
//       center: Location(24.9053295, 91.8380536),
//       width: 500,
//       height: 300,
//       maptype: StaticMapViewType.roadmap,
//     );
//     setState(() {
//       _staticUri = staticUri;
//     });
//   }

//   void _updateLocation() {}

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         EnsureVisibleWhenFocused(
//           child: TextFormField(
//             focusNode: _addressNode,
//           ),
//           focusNode: _addressNode,
//         ),
//         SizedBox(
//           height: 5.0,
//         ),
//         Image.network(_staticUri.toString()),
//       ],
//     );
//   }
// }
