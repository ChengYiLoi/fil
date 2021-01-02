import 'package:cached_network_image/cached_network_image.dart';
import 'package:fil/components/imageViewer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RefillStationInfo extends StatelessWidget {
  const RefillStationInfo({
    @required this.location,
    @required this.viewDescription,
    @required this.imageUrl,
    Key key,
  }) : super(key: key);
  final LatLng location;
  final VoidCallback viewDescription;
  final String imageUrl;

  // void _buildMapPicker(context, LatLng location) async {
  //   final coords = Coords(location.latitude, location.longitude);
  //   final availableMaps = await MapLauncher.installedMaps;
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //             child: SingleChildScrollView(
  //           child: Container(
  //             child: Wrap(
  //               children: [
  //                 for (var map in availableMaps)
  //                   ListTile(
  //                     onTap: () {
  //                       map.showMarker(coords: coords, title: null);
  //                       Navigator.of(context).pop();
  //                     },
  //                     title: Text(map.mapName),
  //                     leading: SvgPicture.asset(
  //                       map.icon,
  //                       height: 30.0,
  //                       width: 30.0,
  //                     ),
  //                   )
  //               ],
  //             ),
  //           ),
  //         ));
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ]),
        width: 200,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ImageViewer(
                      imgUrl: imageUrl,
                    );
                  }));
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Hero(
                    tag: 'stationImg',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: imageUrl == null
                          ? SizedBox()
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.fitWidth,
                              width: 50,
                              height: 50,
                              placeholder: (context, _) => new Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      new AlwaysStoppedAnimation(Colors.blue),
                                ),
                              ),
                              errorWidget: (context, _, __) =>
                                  new Icon(Icons.error),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "Refill Station",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // _buildMapPicker(context, location);
                      viewDescription();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff5BB7DE),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "View Description",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
