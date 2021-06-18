import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../models/route_argument.dart';
import 'ShippingDescriptionOrderWidget.dart';
import '../models/shipping.dart';

import '../../generated/l10n.dart';

class ShippingItemWidget extends StatefulWidget {
  final bool expanded;
  final Shipping shipping;
  final ValueChanged<void> onCanceled;

  ShippingItemWidget({Key key, this.expanded, this.shipping, this.onCanceled}) : super(key: key);

  @override
  _ShippingItemWidgetState createState() => _ShippingItemWidgetState();
}

class _ShippingItemWidgetState extends State<ShippingItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1,
          // TODO
          // widget.order.active ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      children: <Widget>[
                        Text('Orden ID: #${widget.shipping.id}'),
                        Text(
                          DateFormat('dd-MM-yyyy | HH:mm').format(widget.shipping.dateTime),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${widget.shipping.payment.price.toStringAsFixed(2)} \$', style: Theme.of(context).textTheme.headline4),
                        
                        Text(
                          '${widget.shipping.payment.method}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ShippingDescriptionOrderWidget(shipping: widget.shipping)
                        ]
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Distancia',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                //TODO
                                Text('${widget.shipping.distance} KM', style: Theme.of(context).textTheme.headline4)
                                // Helper.getPrice(widget.order.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)
                              ],
                            ),
                            // TODO (ROW)
                            // Row(
                            //   children: <Widget>[
                            //     Expanded(
                            //       child: Text(
                            //         '${S.of(context).tax} (${widget.order.tax}%)',
                            //         style: Theme.of(context).textTheme.bodyText1,
                            //       ),
                            //     ),
                            //     Helper.getPrice(Helper.getTaxOrder(widget.order), context, style: Theme.of(context).textTheme.subtitle1)
                            //   ],
                            // ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Text('${widget.shipping.payment.price.toStringAsFixed(2)} \$', style: Theme.of(context).textTheme.headline4)
                                // Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context, style: Theme.of(context).textTheme.headline4)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      color: Theme.of(context).accentColor,
                      elevation: 0,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/ShippingChat', arguments: RouteArgument(param: widget.shipping));
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text('Chat', style: TextStyle(color: Colors.white),)],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/ShippingDetail', arguments: widget.shipping);
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text('Ver detalles')],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    // if (widget.order.canCancelOrder())
                      // MaterialButton(
                      //   elevation: 0,
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         // return object of type Dialog
                      //         return AlertDialog(
                      //           title: Wrap(
                      //             spacing: 10,
                      //             children: <Widget>[
                      //               Icon(Icons.report_outlined, color: Colors.orange),
                      //               Text(
                      //                 S.of(context).confirmation,
                      //                 style: TextStyle(color: Colors.orange),
                      //               ),
                      //             ],
                      //           ),
                      //           content: Text(S.of(context).areYouSureYouWantToCancelThisOrder),
                      //           contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                      //           actions: <Widget>[
                      //             MaterialButton(
                      //               elevation: 0,
                      //               child: new Text(
                      //                 S.of(context).yes,
                      //                 style: TextStyle(color: Theme.of(context).hintColor),
                      //               ),
                      //               onPressed: () {
                      //                 widget.onCanceled(widget.order);
                      //                 Navigator.of(context).pop();
                      //               },
                      //             ),
                      //             MaterialButton(
                      //               elevation: 0,
                      //               child: new Text(
                      //                 S.of(context).close,
                      //                 style: TextStyle(color: Colors.orange),
                      //               ),
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   textColor: Theme.of(context).hintColor,
                      //   child: Wrap(
                      //     children: <Widget>[Text(S.of(context).cancel + " ")],
                      //   ),
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          // TODO
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), /* color: widget.order.active ? */color: Theme.of(context).accentColor /* : Colors.redAccent) */),
          alignment: AlignmentDirectional.center,
          // TODO
          child: Text(
            '${widget.shipping.shippingStatus.status}',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
