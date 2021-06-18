import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/shipping.dart';
import '../models/shipping_status.dart';
import '../repository/shipping_repository.dart';
import '../repository/settings_repository.dart';
import '../models/shipping_location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class ShippingDetailController extends ControllerMVC {
  Set<Marker> markers = {};
  Set<Polyline> polyline = {};
  List<LatLng> polylineCoordinates = [];
  List<ShippingStatus> shippingStatuses = [];
  Completer<GoogleMapController> mapController = Completer();
  ShippingDetailController() {

  }

  void setDrawRoute(ShippingLocation pointA, ShippingLocation pointB) async{

    // GET MARKERS
    Set<Marker> _markers = {};

    Marker pointAMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: MarkerId(pointA.address),
      position: LatLng(
        pointA.latitude,
        pointA.longitude,
      ),
      infoWindow: InfoWindow(
        title: 'Inicial',
        snippet: pointA.address
      )
    );

    Marker pointBMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      markerId: MarkerId(pointB.address),
      position: LatLng(
        pointB.latitude,
        pointB.longitude,
      ),
      infoWindow: InfoWindow(
        title: 'Final',
        snippet: pointB.address
      )
    );

    _markers.add(pointAMarker);
    _markers.add(pointBMarker);

    markers = _markers;


    // GET POLYLINES
    PolylinePoints _polylinePoints;
    _polylinePoints = PolylinePoints();
    List<LatLng> _polylineCoordinates = [];

    PolylineResult _result = await _polylinePoints.getRouteBetweenCoordinates(
              setting.value.googleMapsKey, // Google Maps API Key
              PointLatLng(pointA.latitude, pointA.longitude),
              PointLatLng(pointB.latitude, pointB.longitude),
              travelMode: TravelMode.driving,
              optimizeWaypoints: true
          );

          if (_result.points.isNotEmpty) {
            _result.points.forEach((PointLatLng point) {
              _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
          }

          Polyline _polyline = Polyline(
            polylineId: PolylineId(pointA.address.toString()),
            color: Color.fromRGBO(246, 202, 23, 1.0),
            points: _polylineCoordinates,
            width: 7,
          );

          if (polyline.isNotEmpty) {
            polyline.add(_polyline);
            polylineCoordinates = _polylineCoordinates;
          } else {
            polyline = {};
            polyline.add(_polyline);
            polylineCoordinates = _polylineCoordinates;
          }

          // TODO
          // moveCameraToPolyline(pointA, pointB);
      setState(() { });
  }

  Future<void> moveCameraToPolyline(ShippingLocation pointA, ShippingLocation pointB) async {
    final GoogleMapController controller = await mapController.future;
    // Define two position variables
    var _northeastCoordinates;
    var _southwestCoordinates;

    // Calculating to check that
    // southwest coordinate <= northeast coordinate
    if (pointA.latitude <= pointB.latitude) {
      _southwestCoordinates = pointA;
      _northeastCoordinates = pointB;
    } else {
      _southwestCoordinates = pointB;
      _northeastCoordinates = pointA;
    }

    // Accommodate the two locations within the
    // camera view of the map
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            _northeastCoordinates.latitude,
            _northeastCoordinates.longitude,
          ),
          southwest: LatLng(
            _southwestCoordinates.latitude,
            _southwestCoordinates.longitude,
          ),
        ),
        100.0, // padding
      ),
    );
    controller.dispose();
  }

  void listenForOrderStatus({String message, bool insertAll}) async {
    final Stream<ShippingStatus> stream = await getShippingStatuses();
    stream.listen((ShippingStatus _shippingStatus) {
      setState(() {
        shippingStatuses.add(_shippingStatus);
      });
    }, onError: (a) {
      print(a);
      // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //   content: Text(S.of(state.context).verify_your_internet_connection),
      // ));
    }, onDone: () {
      if (insertAll != null && insertAll) {
        shippingStatuses.insert(0, new ShippingStatus.fromJSON(
            {'id': '0', 'status': state.context != null ? 'Todos' : ''}));
      }
      // if (message != null) {
      //   ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //     content: Text(message),
      //   ));
      // }
    });
  }

  void doUpdateShipping(Shipping _shipping) async {
    updateShipping(_shipping).then((value) {
      // Navigator.of(state.context).pushNamed('/OrderDetails', arguments: RouteArgument(id: order.id));
     Navigator.of(state.context).pop();
     // setState(() {
     //   this.order.orderStatus.id = '5';
     // });
      ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
        content: Text("Se actualizó correctamente"),
      ));
    });
  }
}
