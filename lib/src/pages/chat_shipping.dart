import 'dart:async';

import '../controllers/chat_shipping_controller.dart';
import '../models/shipping.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../elements/ChatMessageListItemWidget.dart';
import '../elements/EmptyMessagesWidget.dart';
import '../models/route_argument.dart';

class ChatShippingWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ChatShippingWidget({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);

  @override
  _ChatShippingWidgetState createState() => _ChatShippingWidgetState();
}

class _ChatShippingWidgetState extends StateMVC<ChatShippingWidget> {
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();

  ChatShippingController _con;

  _ChatShippingWidgetState() : super(ChatShippingController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.shipping = widget.routeArgument.param as Shipping;
    _con.checkExistingChat(_con.shipping);
    // _con.listenForChatByOrderId(_con.order.id);
    // if (_con.conversation.id != null) {
    //   _con.listenForChats(_con.conversation);
    // }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    _con.scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        automaticallyImplyLeading: false,
        title: Text(
          'Pedido #${_con.shipping.id}',
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: chatList(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
            ),
            child: TextField(
              onChanged: (String string){
                setState(() { });
              },
              controller: myController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                hintText: 'Escribe para iniciar la conversación',
                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
                suffixIcon: Container(
                  width: 140.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(right: 30),
                        onPressed: myController.text.isEmpty ? null : () {
                          _con.addMessage(myController.text);
                          Timer(Duration(milliseconds: 100), () {
                            myController.clear();
                          });
                        },
                        icon: Icon(
                          Icons.send_outlined,
                          color: myController.text.isEmpty ? Colors.grey : Theme.of(context).accentColor,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.only(right: 30),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _con.showModal();
                        },
                        icon: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Theme.of(context).accentColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget chatList() {
    return _con.messages.isEmpty
        ? EmptyMessagesWidget()
        : ListView.builder(
      reverse: false,
      key: _myListKey,
      itemCount: _con.messages.length,
      controller: _con.scrollController,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      shrinkWrap: false,
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index){
        return ChatMessageListItem(
            message: _con.messages[index]
        );
      },
    );

    // return StreamBuilder(
    // stream: _con.chat,
    // builder: (context, snapshot) {
    // return
    // snapshot.hasData
    //     ? ListView.builder(
    //         key: _myListKey,
    //         reverse: true,
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    //         itemCount: snapshot.data.documents.length,
    //         shrinkWrap: false,
    //         primary: true,
    //         itemBuilder: (context, index) {
    //           print(snapshot.data.documents[index].data());
    //           Chat _chat = Chat.fromJSON(snapshot.data.documents[index].data());
    //           _chat.user = _con.conversation.users.firstWhere((_user) => _user.id == _chat.userId);
    //           return ChatMessageListItem(
    //             chat: _chat,
    //           );
    //         })
    //     :
    // EmptyMessagesWidget();
    // },
    // );
  }
}
