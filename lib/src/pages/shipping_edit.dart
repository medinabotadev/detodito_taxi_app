import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../controllers/shipping_detail_controller.dart';
import '../models/shipping.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class ShippingEditWidget extends StatefulWidget {
  final Shipping shipping;

  ShippingEditWidget({Key key, this.shipping}) : super(key: key);

  @override
  _ShippingEditWidgetState createState() {
    return _ShippingEditWidgetState();
  }
}

class _ShippingEditWidgetState extends StateMVC<ShippingEditWidget> {
  ShippingDetailController _con;

  _ShippingEditWidgetState() : super(ShippingDetailController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrderStatus();
    //    _con.listenForDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: MaterialButton(
          elevation: 0,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Confirmar"),
                    content: Text("Confirme si desea guardar los cambios"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      MaterialButton(
                        elevation: 0,
                        textColor: Theme.of(context).focusColor,
                        child: new Text(S.of(context).confirm),
                        onPressed: () {
                          _con.doUpdateShipping(widget.shipping);
                        },
                      ),
                      MaterialButton(
                        elevation: 0,
                        child: new Text(S.of(context).dismiss),
                        textColor: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          padding: EdgeInsets.symmetric(vertical: 14),
          color: Theme.of(context).accentColor,
          shape: StadiumBorder(),
          child: Text(
            'Guardar cambios',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Editar',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: ListView(
        primary: true,
        shrinkWrap: false,
        children: [
          Container(
//                  margin: EdgeInsets.only(top: 95, bottom: 65),
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
                              S.of(context).order_id + ": #${widget.shipping.id}",
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
                          Text(widget.shipping.payment.price.toStringAsFixed(2) + ' \$', style: Theme.of(context).textTheme.headline4,),
                          // Helper.getPrice(Helper.getTotalOrdersPrice(_con.order), context, style: Theme.of(context).textTheme.headline4),
                          Text(
                            widget.shipping.payment?.method ?? 'Efectivo',
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
          _con.shippingStatuses.isEmpty ?
              CircularLoadingWidget(height: 200.0,)
          :   ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 20),
              title: Text('Estatus'),
              initiallyExpanded: true,
              children: List.generate(_con.shippingStatuses.length, (index) {
                var _status = _con.shippingStatuses.elementAt(index);
                return RadioListTile(
                  dense: true,
                  groupValue: true,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: widget.shipping.shippingStatus.id == _status.id,
                  onChanged: (value) {
                    setState(() {
                      widget.shipping.shippingStatus = _status;
                    });
                  },
                  title: Text(
                    " " + _status.status,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                );
              })),
        ],
      ),
    );
  }
}
