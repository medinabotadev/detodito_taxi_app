import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/app_config.dart' as config;

class EmptyMessagesWidget extends StatefulWidget {
  EmptyMessagesWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyMessagesWidgetState createState() => _EmptyMessagesWidgetState();
}

class _EmptyMessagesWidgetState extends State<EmptyMessagesWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          loading
              ? SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(246, 202, 23, 1.0)),
            ),
          )
              : SizedBox(),
          Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: config.App(context).appHeight(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20.0,),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    'No tienes ninguna conversación en esta orden',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                            Theme.of(context).focusColor.withOpacity(0.7),
                            Theme.of(context).focusColor.withOpacity(0.05),
                          ])),
                      child: Icon(
                        Icons.message_outlined,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 70,
                      ),
                    ),
                    Positioned(
                      right: -30,
                      bottom: -50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      top: -50,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    'En breve será contactado por un DetodiOperador',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    'o',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    'Escriba para iniciar una conversación',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                // SizedBox(height: 20),
                !loading
                    ? SizedBox()
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
