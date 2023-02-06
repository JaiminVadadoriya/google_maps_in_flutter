// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMun extends StatefulWidget {
  final Function dekhBinod;
  final LatLng cameraTarget;
  const MapMun({
    super.key,
    required this.cameraTarget,
    required this.dekhBinod,
  });

  @override
  State<MapMun> createState() => _MapMunState(dekhBinod, cameraTarget);
}

class _MapMunState extends State<MapMun> {
  final Function dekhBinod;
  final LatLng cameraTarget;
  _MapMunState(this.dekhBinod, this.cameraTarget);
  Completer<GoogleMapController> _controller = Completer();
// on below line we have specified camera position

// documents ids
  List<String> docIds = [];

// on below line we have created the list of markers
  final _markers = <Marker>[];

  Future samashyaHe() async {
//get the collection
    // List<Marker> _samashyas = <Marker>[];
    print("add ho ne vala  ");

    await FirebaseFirestore.instance.collection('problems').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) async {
              docIds.add(document.reference.id);
              _markers.add(await samashyaKiJagah(document.reference.id));
            },
          ),
        );
    // yield _samashyas;
  }

  // Future samashyaKiJagah(String documentId) async {
  Future<Marker> samashyaKiJagah(String documentId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    //get the collection
    print("call to hovA");
    CollectionReference collection =
        FirebaseFirestore.instance.collection("problems");

    var problem = await collection.doc(documentId).get();
    // var problem = await collection.doc(documentId).get();

    Map<String, dynamic> data = problem.data() as Map<String, dynamic>;

    // GeoPoint geopoint = data['problemLocation']!;
    GeoPoint geopoint = const GeoPoint(0, 0);
    if (await data['problemLocation'] != null) {
      geopoint = data['problemLocation'] as GeoPoint;
    }
    print("add ho gaya ${data['problem']} ");
    print("add ho gaya ${geopoint.latitude}  -  ${geopoint.longitude} ");

    return Marker(
      markerId: MarkerId("${documentId}"),
      position: LatLng(geopoint.latitude, geopoint.longitude),
      infoWindow: InfoWindow(
        title: data['problem'],
      ),
    );
  }

// created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  bool problemSelected = false;

  @override
  Widget build(BuildContext context) {
    CameraPosition _kGoogle = CameraPosition(
      target: LatLng(cameraTarget.latitude, cameraTarget.longitude),
      zoom: 14.4746,
    );
    return SafeArea(
      // on below line creating google maps
      child: GoogleMap(
        onTap: (argument) {
          if (problemSelected) {
            _markers.removeWhere(
              (element) => element.markerId.value == 'user Location',
            );
          }

          setState(
            () {
              problemSelected = true;
              print(problemSelected);
              _markers.add(
                Marker(
                  markerId: const MarkerId('user Location'),
                  position: argument,
                  infoWindow: const InfoWindow(
                    title: 'Problem',
                  ),
                ),
              );
              // _markers.add(samashyaKiJagah(docIds[0]));
              // FutureBuilder(
              //   future: samashyaHe(),
              //   builder: (context, snapshot) {
              //     // _markers.add(samashyaKiJagah(docIds[0]));
              //   },
              // );
            },
          );
        },
        // on below line setting camera position
        initialCameraPosition: _kGoogle,
        // on below line we are setting markers on the map
        markers: Set.of(_markers),
        // on below line specifying map type.
        mapType: MapType.normal,
        // on below line setting user location enabled.
        myLocationEnabled: true,
        // on below line setting compass enabled.
        compassEnabled: true,
        // on below line specifying controller on map complete.
        onMapCreated: (GoogleMapController controller) async {
          // samashyaHe().listen((event) {
          //   _markers.addAll(event);
          // });
          // samashyaHe();

          await samashyaHe();
          _controller.complete(controller);
          dekhBinod();
        },
      ),
    );
  }
}
