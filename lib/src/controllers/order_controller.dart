import 'package:flutter/material.dart';
import '../models/shipping.dart';
import '../repository/shipping_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  List<Shipping> shippings = <Shipping>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForShippings({String message}) async {
    final Stream<Shipping> stream = await getShippings();
    stream.listen((Shipping _shipping) {
      setState(() {
        if (_shipping.shippingStatus.id != '6' && _shipping.shippingStatus.id != '7') {
          shippings.add(_shipping);
        }
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForShippingsHistory({String message}) async {
    final Stream<Shipping> stream = await getShippingsHistory();
    stream.listen((Shipping _shipping) {
      setState(() {
        if(_shipping.shippingStatus.id == '6' || _shipping.shippingStatus.id == '7') {
        shippings.add(_shipping);
        }
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrdersHistory() async {
    shippings.clear();
    listenForShippingsHistory(message: S.of(state.context).order_refreshed_successfuly);
  }

  Future<void> refreshOrders() async {
    shippings.clear();
    listenForOrders(message: S.of(state.context).order_refreshed_successfuly);
  }
}
