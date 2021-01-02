import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/components/components.dart';
import 'package:fil/constants.dart';
import 'package:fil/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  DatabaseService _db = DatabaseService();
  double infoWindowPosition;
  double createMarkerinfoWindowPosition;
  double descriptionWindowPosition;

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionStatus;

  GoogleMapController mapController;
  LatLng _center = LatLng(20.5937, 78.9629);
  BitmapDescriptor mapMarker;
  Set<Marker> _markers = {};

  LatLng selectedMarker;
  String selectedMarkerDescription;
  String selectedMarkerImageUrl;

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 8.5), "images/mapIcon.png");
  }

  enableService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  getPermission() async {
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
    getLocation();
  }

  getLocation() async {
    LocationData locData = await location.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(locData.latitude, locData.longitude), zoom: 17),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    location.onLocationChanged.listen((LocationData currentLocation) {
      // controller.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(
      //         target:
      //             LatLng(currentLocation.latitude, currentLocation.longitude),
      //         zoom: 17),
      //   ),
      // );
    });
  }

  void setMarker(LatLng location) {
    if (_markers.length != 0) {
      Marker m = _markers.elementAt(_markers.length - 1);
      if (m.markerId.value != "temp") {
        _markers.add(
          Marker(
            markerId: MarkerId("temp"),
            position: location,
          ),
        );
        // } else if (m.markerId.value == "temp") {
        //   _markers.removeWhere((Marker marker) => marker.markerId.value == "temp");
        //   _markers.add(
        //     Marker(
        //       markerId: MarkerId("temp"),
        //       position: location,
        //     ),
        //   );
        // }
      }
    } else {
      _markers.add(
        Marker(
          markerId: MarkerId("temp"),
          position: location,
        ),
      );
    }
  }

  void renderMarkers(snapshots) {
    _markers.removeWhere((marker) => marker.markerId.value != "temp");
    snapshots.forEach((snapshot) {
      _markers.add(
        Marker(
          markerId: MarkerId(snapshot.id),
          position: LatLng(snapshot.data()['lat'], snapshot.data()['lng']),
          icon: mapMarker,
          onTap: () async {
            Reference ref =
                FirebaseStorage.instance.ref().child("images/${snapshot.id}");
            await ref.getDownloadURL().then((String url) {
              print('image url obtained');
              print(url);
              Future.delayed(Duration(milliseconds: 500), () {
                setState(() {
                  selectedMarker =
                      LatLng(snapshot.data()['lat'], snapshot.data()['lng']);
                  selectedMarkerDescription = snapshot.data()['description'];
                  selectedMarkerImageUrl = url;
                  infoWindowPosition = 70;
                });
              });
            });
          },
        ),
      );
    });
  }

  void _removeTempMarker() {
    setState(() {
      _markers.removeWhere((Marker marker) => marker.markerId.value == "temp");
    });
  }

  @override
  void initState() {
    super.initState();
    infoWindowPosition = -100;
    createMarkerinfoWindowPosition = -100;
    descriptionWindowPosition = -100;
    selectedMarkerDescription = "";
    print("Map init state called");
    enableService();
    getPermission();
    setCustomMarker();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _db.getMarkers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> snapshots = snapshot.data.documents;
          renderMarkers(snapshots);
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: _center, zoom: 17.0),
                    onTap: (LatLng location) {
                      selectedMarker = location;
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: location, zoom: 17),
                        ),
                      );

                      Future.delayed(Duration(milliseconds: 1500), () {
                        setState(() {
                          infoWindowPosition = -100;
                          createMarkerinfoWindowPosition = 20;
                          setMarker(location);
                        });
                      });
                    },
                    onCameraMove: (CameraPosition position) {
                      setState(() {
                        infoWindowPosition = -100;
                        createMarkerinfoWindowPosition = -100;
                        descriptionWindowPosition = -100;
                        _markers.removeWhere(
                            (Marker marker) => marker.markerId.value == "temp");
                      });
                    },
                  ),
                  MarkerDescriptionWindow(
                      descriptionWindowPosition: descriptionWindowPosition,
                      child: MarkerDescription(
                        markerDescription: selectedMarkerDescription,
                      )),
                  MarkerInfoWindow(
                    infoWindowPosition: infoWindowPosition,
                    child: RefillStationInfo(
                      location: selectedMarker,
                      viewDescription: () {
                        setState(() {
                          descriptionWindowPosition = 50;
                        });
                      },
                      imageUrl: selectedMarkerImageUrl,
                    ),
                  ),
                  MarkerInfoWindow(
                      infoWindowPosition: createMarkerinfoWindowPosition,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddMarkerForm(
                                  location: selectedMarker,
                                  onSubmit: _removeTempMarker,
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Color(0xff5bb7de),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    offset: Offset.zero,
                                    color: Colors.grey.withOpacity(0.5))
                              ]),
                          child: Text(
                            "Create Marker",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          );
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class MarkerDescription extends StatelessWidget {
  const MarkerDescription({
    Key key,
    this.markerDescription,
  }) : super(key: key);
  final String markerDescription;
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
                color: Colors.grey.withOpacity(0.5)),
          ]),
      width: 200,
      height: 80,
      child: Center(child: Text(markerDescription)),
    );
  }
}

class AddMarkerForm extends StatefulWidget {
  const AddMarkerForm({
    @required this.location,
    @required this.onSubmit,
    Key key,
  }) : super(key: key);

  final LatLng location;
  final VoidCallback onSubmit;

  @override
  _AddMarkerFormState createState() => _AddMarkerFormState();
}

class _AddMarkerFormState extends State<AddMarkerForm> {
  File _image;
  final picker = ImagePicker();
  TextEditingController controller = TextEditingController();
  DatabaseService _db = DatabaseService();

  Future _imgFromCamera() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("no image selected");
      }
    });
  }

  Future _imgFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("no image selected");
      }
    });
  }

  void _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text("Camera"),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Photo Library"),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showImagePicker(context);
                },
                child: Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[200],
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : Container(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color(0xff000000).withOpacity(0.2))),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "  Enter a short description...",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: buttonOrange,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 34),
                        child: Text(
                          "Cancel",
                          style: popupButtonTextStyle,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSubmit();
                        _db.createMarker(
                            controller.text, widget.location, _image);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: buttonBlue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 34),
                          child: Text(
                            "Submit",
                            style: popupButtonTextStyle,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
