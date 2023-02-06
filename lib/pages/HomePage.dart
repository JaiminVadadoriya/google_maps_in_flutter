import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/widgets/higher_auth.dart';
import 'package:google_maps_in_flutter/widgets/map_mun.dart';
import 'package:google_maps_in_flutter/widgets/problm_mun.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Completer<GoogleMapController> _controller = Completer();
// on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

// on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[];

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

  LatLng cameraTarget = LatLng(20.42796133580664, 80.885749655962);

  void dekhBinod() async {
    await getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());

      // marker added for current users location
      _markers.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'My Current Location',
          ),
          visible: false,
        ),
      );
      cameraTarget = LatLng(value.latitude, value.longitude);

      // specified current users location
      CameraPosition cameraPosition = CameraPosition(
        target: cameraTarget,
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ignore: prefer_final_fields

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MapMun(
          cameraTarget: cameraTarget,
          dekhBinod: () => {
                dekhBinod(),
              }),
      ProblmMun(),
      HigherAuth(),
    ];
    return Scaffold(
      appBar: AppBar(
        // on below line we have given title of app
        title: Text("GFG"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                dekhBinod();
              },
              child: Icon(Icons.location_searching),
            )
          : null,
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 10.0,
      //   // selectedIconTheme: IconThemeData(
      //   //   color: Colors.black87,
      //   // ),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       // backgroundColor: Colors.transparent,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list),
      //       label: 'Problems',
      //       // backgroundColor: Colors.transparent,
      //       // backgroundColor: Colors.green,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.front_hand_rounded),
      //       label: 'Higher Autherity',
      //       // backgroundColor: Colors.purple,
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.settings),
      //     //   label: 'Settings',
      //     //   backgroundColor: Colors.pink,
      //     // ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   // selectedItemColor: Color.fromARGB(255, 0, 90, 53),
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        child: GNav(
          gap: 10,
          activeColor: Theme.of(context).primaryColor,
          tabBackgroundColor: Theme.of(context).secondaryHeaderColor,
          onTabChange: _onItemTapped,
          padding: EdgeInsets.all(10),
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.list,
              text: 'Problems',
            ),
            GButton(
              icon: Icons.front_hand_rounded,
              text: 'Higher Autherity',
            ),
          ],
        ),
      ),
    );
  }
}
