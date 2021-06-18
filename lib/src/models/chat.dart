class Chat {
  // DOCUMENT ID
  String id;
  String lastMessage;
  String lastNameWriter;
  String orderId;
  String orderName;
  int ownerId;
  List<dynamic> participantIds;
  String photoOrdering;
  String photoUrlLastWriter;

  Chat();

  Chat.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id                  = jsonMap['id']                 != null ? jsonMap['id']                 : '';
      lastMessage         = jsonMap['lastMessage']        != null ? jsonMap['lastMessage']        : '';
      lastNameWriter      = jsonMap['lastNameWriter']     != null ? jsonMap['lastNameWriter']     : '';
      orderId             = jsonMap['orderId']            != null ? jsonMap['orderId']            : '';
      orderName           = jsonMap['orderName']          != null ? jsonMap['orderName']          : '';
      ownerId             = jsonMap['ownerId']            != null ? jsonMap['ownerId']            :  0;
      participantIds      = jsonMap['participantIds']     != null ? jsonMap['participantIds']     : [];
      photoOrdering       = jsonMap['photoOrdering']      != null ? jsonMap['photoOrdering']      : '';
      photoUrlLastWriter  = jsonMap['photoUrlLastWriter'] != null ? jsonMap['photoUrlLastWriter'] : '';
    } catch (e) {
      id                  = '';
      lastMessage         = '';
      lastNameWriter      = '';
      orderId             = '';
      orderName           = '';
      ownerId             =  0;
      participantIds      = [];
      photoOrdering       = '';
      photoUrlLastWriter  = '';
      print(e);
    }
  }

  Chat.fromQuerySnapshot(String collectionId, Map<String, dynamic> jsonMap){
    try {
      id = collectionId != null ? collectionId : 0;
      lastMessage         = jsonMap['lastMessage']        != null ? jsonMap['lastMessage']        : '';
      lastNameWriter      = jsonMap['lastNameWriter']     != null ? jsonMap['lastNameWriter']     : '';
      orderId             = jsonMap['orderId']            != null ? jsonMap['orderId']            : '';
      orderName           = jsonMap['orderName']          != null ? jsonMap['orderName']          : '';
      ownerId             = jsonMap['ownerId']            != null ? jsonMap['ownerId']            :  0;
      participantIds      = jsonMap['participantIds']     != null ? jsonMap['participantIds']     : [];
      photoOrdering       = jsonMap['photoOrdering']      != null ? jsonMap['photoOrdering']      : '';
      photoUrlLastWriter  = jsonMap['photoUrlLastWriter'] != null ? jsonMap['photoUrlLastWriter'] : '';
    } catch (e) {
      id                  = '';
      lastMessage         = '';
      lastNameWriter      = '';
      orderId             = '';
      orderName           = '';
      ownerId             =  0;
      participantIds      = [];
      photoOrdering       = '';
      photoUrlLastWriter  = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id']                 = id;
    map['lastMessage']        = lastMessage;
    map['lastNameWriter']     = lastNameWriter;
    map['orderId']            = orderId;
    map['orderName']          = orderName;
    map['ownerId']            = ownerId;
    map['participantIds']     = participantIds;
    map['photoOrdering']      = photoOrdering;
    map['photoUrlLastWriter'] = photoUrlLastWriter;
    return map;
  }
}
