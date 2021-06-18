import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/shipping_detail_controller.dart';
import '../models/shipping.dart';

class ShippingDetailWidget extends StatefulWidget {
  final Shipping shipping;

  ShippingDetailWidget({Key key, this.shipping}) : super(key: key);

  @override
  _ShippingDetailWidgetState createState() => _ShippingDetailWidgetState();
}

class _ShippingDetailWidgetState extends StateMVC<ShippingDetailWidget> {
  ShippingDetailController _con;

  _ShippingDetailWidgetState() : super(ShippingDetailController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.setDrawRoute(
        widget.shipping.location_from,
        widget.shipping.location_to
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),),
        centerTitle: true,
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        markers: _con.markers != null ? _con.markers : null,
        polylines: widget.shipping.location_to.address == null ? Set() : _con.polyline,
        onMapCreated: (GoogleMapController controller) {
          _con.mapController.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.shipping.location_from.latitude, widget.shipping.location_from.longitude),
          zoom: 14.0
        ),
      ),
      bottomNavigationBar: Container(
        height: 250,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Distancia:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(widget.shipping.distance.toStringAsFixed(2) + " KM",
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Punto inicial:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Flexible(
                    child: Text(widget.shipping.location_from.address,
                      // style: Theme.of(context).textTheme.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Punto final:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Flexible(
                    child: Text(widget.shipping.location_to.address,
                      // style: Theme.of(context).textTheme.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Divider(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Total:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(widget.shipping.payment.price.toStringAsFixed(2) + " \$",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
              SizedBox(height: 15.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 0, bottom: 25),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                                    boxShadow: [
                                      BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Traslado" + ": #${widget.shipping.id}",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: Theme.of(context).textTheme.headline4,
                                                  ),
                                                  Text(
                                                    widget.shipping.shippingStatus.status,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: Theme.of(context).textTheme.caption,
                                                  ),
                                                  Text(
                                                    DateFormat('yyyy-MM-dd HH:mm').format(widget.shipping.dateTime),
                                                    style: Theme.of(context).textTheme.caption,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                // Helper.getPrice(Helper.getTotalOrdersPrice(widget.shipping.payment.price), context, style: Theme.of(context).textTheme.headline4),
                                                Text(widget.shipping.payment.price.toStringAsFixed(2) + " \$", style: Theme.of(context).textTheme.headline4,),
                                                Text(
                                                  widget.shipping.payment.method,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context).textTheme.caption,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Nombre cliente:',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                            Text(
                                              widget.shipping.user.name,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: MaterialButton(
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                          onPressed: () {
/*                                   Navigator.of(context).pushNamed('/Profile',
                                      arguments: new RouteArgument(param: _con.order.deliveryAddress));*/
                                          },
                                          child: Icon(
                                            Icons.person,
                                            color: Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                          color: Theme.of(context).accentColor.withOpacity(0.9),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Direcciones:',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                            Text(
                                              "Desde: " + widget.shipping.location_from.address,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                            Text(
                                              "Hasta: " + widget.shipping.location_to.address,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: MaterialButton(
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _con.moveCameraToPolyline(widget.shipping.location_from, widget.shipping.location_to);
                                          },
                                          child: Icon(
                                            Icons.directions,
                                            color: Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                          color: Theme.of(context).accentColor.withOpacity(0.9),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Número de teléfono:",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                            Text(
                                              widget.shipping.user.phone,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: MaterialButton(
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            launch("tel:${widget.shipping.user.phone}");
                                          },
                                          child: Icon(
                                            Icons.call,
                                            color: Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                          color: Theme.of(context).accentColor.withOpacity(0.9),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.shipping.location_from.vehicle_needed_by_user != ''
                                ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Vehículo  solicitado:",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                            Text(
                                              widget.shipping.location_from.vehicle_needed_by_user,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: MaterialButton(
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.directions_car_rounded,
                                            color: Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                          color: Theme.of(context).accentColor.withOpacity(0.9),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) : SizedBox(),
                                MaterialButton(
                                    elevation: 0,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/ShippingEdit', arguments: widget.shipping);
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    color: Theme.of(context).accentColor,
                                    shape: StadiumBorder(),
                                    child: Text(
                                      'Editar',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                              ],
                            ),
                          );
                        });
                  },
                  padding: EdgeInsets.symmetric(vertical: 14),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                  child: Text(
                    'Ver detalles completos',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
