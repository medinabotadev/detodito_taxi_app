import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import 'package:intl/intl.dart';
import '../repository/user_repository.dart';

class ChatMessageListItem extends StatelessWidget {
  final Message message;

  ChatMessageListItem({this.message});

  @override
  Widget build(BuildContext context) {
    return currentUser.value.firestore_id == this.message.senderId ? getSentMessageLayout(context) : getReceivedMessageLayout(context);
  }

  Widget getSentMessageLayout(context) {
    DateTime      _time       = DateTime.parse(message.date).toLocal();
    DateFormat    _formatter  = DateFormat('hh:mm');
    String        _timeFormatted  = _formatter.format(_time);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.2),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(currentUser.value.name, style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.w600))),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: message.attachement.url.isEmpty
                          ? new Text(
                        message.content,
                      ) : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: GestureDetector(
                          child: Hero(
                            tag: message.attachement.url,
                            child: CachedNetworkImage(
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              imageUrl: message.attachement.url,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: Container(width: 50.0, height: 50.0 ,child: CircularProgressIndicator(value: downloadProgress.progress, backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(246, 202, 23, 1.0))
                                    ,))),
                              errorWidget: (context, url, error) => Image.asset('assets/img/loading.gif'),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/DetailImage', arguments: message.attachement.url);
                          },
                        ),
                      )
                  ),
                  new SizedBox(height: 2.0,),
                  new Text(_timeFormatted, style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11.0)),)
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 8.0),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: currentUser.value.image.url,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReceivedMessageLayout(context) {
    DateTime      _time       = DateTime.parse(message.date).toLocal();
    DateFormat    _formatter  = DateFormat('hh:mm');
    String        _timeFormatted  = _formatter.format(_time);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 10),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: message.senderPhotoUrl,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Image.asset('assets/img/loading.gif'),
                ),
              ),
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(message.senderName,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor))),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: message.attachement.url.isEmpty
                          ? new Text(
                        message.content,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ) : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: GestureDetector(
                          child: Hero(
                            tag: message.attachement.url,
                            child: CachedNetworkImage(
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              imageUrl: message.attachement.url,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: Container(width: 50.0, height: 50.0 ,child: CircularProgressIndicator(value: downloadProgress.progress, backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(246, 202, 23, 1.0))
                                  ))),
                              errorWidget: (context, url, error) => Image.asset('assets/img/loading.gif'),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/DetailImage', arguments: message.attachement.url);
                          },
                        ),
                      )
                  ),
                  SizedBox(height: 2.0,),
                  new Text(_timeFormatted, style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11.0, color: Colors.black)),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
