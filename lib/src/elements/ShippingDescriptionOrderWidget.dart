import 'package:flutter/material.dart';
import '../models/shipping.dart';


class ShippingDescriptionOrderWidget extends StatelessWidget {
  final Shipping shipping;

  const ShippingDescriptionOrderWidget({Key key, this.shipping}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        // Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: this.productOrder.product.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(shipping.shippingMethod.name),
                        SizedBox(height: 8.0),
                        Text('Desde: ${shipping.location_from.address}'),
                        SizedBox(height: 8.0),
                        Text('Hasta: ${shipping.location_to.address}'),
                        SizedBox(height: 8.0,),
                        shipping.location_to.vehicle_needed_by_user.isNotEmpty
                        ? Text(shipping.location_to.vehicle_needed_by_user)
                        : SizedBox(),
                      ],
                    )
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Helper.getPrice(Helper.getOrderPrice(productOrder), context, style: Theme.of(context).textTheme.subtitle1),
                      // Text(
                      //   '${shipping.payment.price} \$',
                      //   style: Theme.of(context).textTheme.subtitle1,
                      // ),
                      // Text(
                      //   'x 1.0',
                      //   style: Theme.of(context).textTheme.caption,
                      // ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
