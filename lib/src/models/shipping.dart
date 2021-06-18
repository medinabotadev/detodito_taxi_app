import 'dart:convert';
import 'user.dart';
import 'payment.dart';
import 'shipping_location.dart';
import 'shipping_method.dart';
import 'shipping_status.dart';


class Shipping {
  String id;
  ShippingStatus shippingStatus;
  ShippingMethod shippingMethod;
  String driverId;
  ShippingLocation location_from;
  ShippingLocation location_to;
  double distance;
  DateTime dateTime;
  Payment payment;
  User user;

  Shipping();

  Shipping.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      shippingStatus = jsonMap['shipping_status'] != null ? ShippingStatus.fromJSON(jsonMap['shipping_status']) : ShippingStatus.fromJSON({});
      shippingMethod = jsonMap['shipping_method'] != null ? ShippingMethod.fromJSON(jsonMap['shipping_method']) : ShippingMethod.fromJSON({});
      driverId = jsonMap['driver_id'] != null ? jsonMap['driver_id'].toString() : '';
      location_from = jsonMap['location_from'] != null ? ShippingLocation.fromJSON(json.decode(jsonMap['location_from'])) : ShippingLocation.fromJSON({});
      location_to = jsonMap['location_to'] != null ? ShippingLocation.fromJSON(json.decode(jsonMap['location_to'])) : ShippingLocation.fromJSON({});
      distance = jsonMap['distancia'] != null ? double.parse(jsonMap['distancia']) : 0.0;
      dateTime = DateTime.parse(jsonMap['created_at']);
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : Payment.fromJSON({});
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    } catch (e) {
      id = '';
      shippingStatus = ShippingStatus.fromJSON({});
      driverId = '';
      location_from = ShippingLocation.fromJSON({});
      location_to = ShippingLocation.fromJSON({});
      distance = 0.0;
      dateTime = DateTime(0);
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map['shipping_status'] = shippingStatus;
    map['shipping_method'] = shippingMethod;
    map['driver_id'] = driverId;
    map['location_from'] = location_from?.toMap();
    map['location_to'] = location_to?.toMap();
    map['distancia'] = distance;
    map['created_at'] = dateTime;
    map['payment'] = payment;
    map['user'] = user?.toMap();
    return map;
  }

  Map editableMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    if (shippingStatus?.id != 'null') map["shippingStatus_id"] = shippingStatus?.id;
    return map;
  }

  // Map deliveredMap() {
  //   var map = new Map<String, dynamic>();
  //   map["id"] = id;
  //   map["order_status_id"] = 5;
  //   if (deliveryAddress?.id != null && deliveryAddress?.id != 'null') map["delivery_address_id"] = deliveryAddress.id;
  //   return map;
  // }

  // Map cancelMap() {
  //   var map = new Map<String, dynamic>();
  //   map["id"] = id;
  //   if (orderStatus?.id != null && orderStatus?.id == '1') map["active"] = false;
  //   return map;
  // }

  // bool canCancelOrder() {
  //   return this.active == true && this.orderStatus.id == '1'; // 1 for order received status
  // }
}
