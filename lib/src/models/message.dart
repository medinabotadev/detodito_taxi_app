import 'attachement.dart';

class Message{
  String id;
  String content;
  String chatId;
  String senderName;
  String date;
  List<dynamic> reactions;
  String senderId;
  String senderPhotoUrl;
  Attachement attachement;

  Message();

  Message.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id              = jsonMap['id']               != null ? jsonMap['id']                                 : '';
      content         = jsonMap['content']          != null ? jsonMap['content']                            : '';
      chatId          = jsonMap['chatId']           != null ? jsonMap['chatId']                             : '';
      senderName      = jsonMap['senderName']       != null ? jsonMap['senderName']                         : '';
      date            = jsonMap['date']             != null ? jsonMap['date']                               : '';
      reactions       = jsonMap['reactions']        != null ? jsonMap['reactions']                          : [];
      senderId        = jsonMap['senderId']         != null ? jsonMap['senderId']                           : '';
      senderPhotoUrl  = jsonMap['senderPhotoUrl']   != null ? jsonMap['senderPhotoUrl']                     : '';
      attachement     = jsonMap['attachement']      != null ? Attachement.fromJSON(jsonMap['attachement'])  : Attachement.fromJSON({});
    } catch (e) {
      id             = '';
      content        = '';
      senderName     = '';
      date           = '';
      reactions      = [];
      senderId       = '';
      senderPhotoUrl = '';
      attachement    = Attachement.fromJSON({});
      print('Hay una excepcion $e');
    }
  }

  Map toMap(bool hasImage) {
    var map = new Map<String, dynamic>();
    map['id']             = id;
    map['content']        = content;
    map['chatId']         = chatId;
    map['senderName']     = senderName;
    map['date']           = date;
    map['reactions']      = reactions;
    map['senderId']       = senderId;
    map['senderPhotoUrl'] = senderPhotoUrl;
    if(hasImage){
      map['attachement']  = attachement.toMap();
    }
    return map;
  }
}