import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/delivery_addresses_controller.dart';

class DeliveryAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DeliveryAddressBottomSheetWidget({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _DeliveryAddressBottomSheetWidgetState createState() => _DeliveryAddressBottomSheetWidgetState();
}

class _DeliveryAddressBottomSheetWidgetState extends StateMVC<DeliveryAddressBottomSheetWidget> {

  _DeliveryAddressBottomSheetWidgetState() : super(DeliveryAddressesController()) {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
    );
  }
}
