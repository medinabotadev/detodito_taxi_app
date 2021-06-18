import 'package:flutter/material.dart';
import '../models/shipping.dart';
import '../repository/shipping_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class ProfileController extends ControllerMVC {
  User user = new User();
  List<Shipping> recentShippings = [];
  GlobalKey<ScaffoldState> scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForUser();
  }

  void listenForUser() {
    getCurrentUser().then((_user) {
      setState(() {
        user = _user;
      });
    });
  }

  void listenForRecentShippings({String message}) async {
    final Stream<Shipping> stream = await getRecentShippings();
    stream.listen((Shipping _shipping) {
      setState(() {
        recentShippings.add(_shipping);
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

  Future<void> refreshProfile() async {
    recentShippings.clear();
    user = new User();
    listenForRecentShippings(message: S.of(state.context).orders_refreshed_successfuly);
    listenForUser();
  }
}
