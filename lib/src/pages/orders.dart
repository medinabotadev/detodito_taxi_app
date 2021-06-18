import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../elements/ShippingItemWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/order_controller.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForShippings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Taxis',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        color: Color.fromRGBO(246, 202, 23, 1.0),
        onRefresh: _con.refreshOrders,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            _con.shippings.isEmpty
                ? EmptyOrdersWidget()
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.shippings.length,
                    itemBuilder: (context, index) {
                      var _shipping = _con.shippings.elementAt(index);
                      return ShippingItemWidget(
                        expanded: index == 0 ? true : false, 
                        shipping: _shipping,
                        onCanceled: (e){
                          
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
