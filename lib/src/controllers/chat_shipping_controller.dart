import 'dart:io';
import '../models/shipping.dart';

import '../models/attachement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/chat.dart';
import '../repository/chat_repository.dart';
import '../repository/user_repository.dart';
import 'package:intl/intl.dart';

class ChatShippingController extends ControllerMVC {
  Chat chat;
  Shipping shipping;
  List<Message> messages = [];
  List<Chat> chats = [];
  ChatRepository _chatRepository;
  Stream<QuerySnapshot> conversations;
  GlobalKey<ScaffoldState> scaffoldKey;
  ScrollController scrollController = new ScrollController();

  ChatShippingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _chatRepository = new ChatRepository();
  }

  Future checkExistingChat(Shipping shipping) async {
    await _chatRepository.getChatByShippingId(shipping.id).then((value) async {
      if(value.docs.isEmpty){
        await _chatRepository.createShippingChat(shipping.id).then((snapshot){
          chat = new Chat.fromQuerySnapshot(snapshot, {
            'lastMessage' : "",
            'lastNameWriter' : "",
            'shippingId' : shipping.id,
            'orderName' : "Envio de ${currentUser.value.name}",
            'ownerId' : int.parse(currentUser.value.id),
            'participantIds' : [
              currentUser.value.firestore_id
            ],
            'photoOrdering' : "https://detoditoapp.net/images/avatar_default.png",
            'photoUrlLastWriter' : "https://detoditoapp.net/images/avatar_default.png"
          });
        });
        getMessagesByChatId(chat);
      } else {
        chat = new Chat.fromQuerySnapshot(value.docs[0].id, value.docs[0].data());
        getMessagesByChatId(chat);
      }
      setState(() { });
    });
  }

  getMessagesByChatId(Chat chat) async {
    await _chatRepository.getMessagesByChatId(chat.id).then((value){
      Stream<QuerySnapshot> stream = value;
      stream.listen((event) {
        if (messages.isEmpty) {
          event.docs.forEach((element) {
            Message message = new Message.fromJSON(element.data());
            messages.add(message);
          });
        } else {
          Map<String, dynamic> lastMessageFromQuery = event.docChanges.first.doc.data();
          Message message = new Message.fromJSON(lastMessageFromQuery);
          messages.add(message);
        }
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent + 100, duration: Duration( milliseconds: 250), curve: Curves.elasticIn);
        }
        setState(() { });
      });
    });
  }

  getChatsByUserId(int userId) async {
    await _chatRepository.getChatsByUserId(userId).then((value){
      Stream<QuerySnapshot> stream = value;
      stream.listen((event) {
        event.docs.forEach((element) {
          Chat _chat = new Chat.fromJSON(element.data());
          chats.add(_chat);
        });
        setState(() { });
      });
    });
  }

  addMessage(String text) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss', ).format(now);
    String timeZone = '';
    if (now.timeZoneOffset.toString().length == 15) {
      timeZone = '0' + now.timeZoneOffset.toString().substring(1, 5);
    } else {
      timeZone = now.timeZoneOffset.toString().substring(0, 5);
    }
    String date = formattedDate + '-' + timeZone;
    if(date.endsWith(':')){
      date = date.substring(0, date.length - 1);
    }
    Message _message = new Message.fromJSON({
      'id'              : (messages.length + 1).toString(),
      'content'         : text,
      'chatId'          : chat.id,
      'senderName'      : currentUser.value.name,
      'date'            : date,
      'reactions'       : [],
      'senderId'        : currentUser.value.firestore_id,
      'senderPhotoUrl'  : currentUser.value.image.url
    });
    await _chatRepository.addMessage(_message, hasImage: false).then((value) {
      // chat.participantIds.forEach((_participantId) {
      //   if (_participantId != currentUser.value.firestore_id) {
      //     sendNotification(text, "Nuevo mensaje de:"+ " " + currentUser.value.name, _participantId);
      //   }
      // });
    });
    setState(() { });
  }

  void showModal(){
    if(Platform.isAndroid){
      showModalBottomSheet(
          context: state.context,
          builder: (context){
            return ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon( Icons.camera_alt_outlined ),
                  title: Text('Camara'),
                  onTap: (){
                    getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon( Icons.photo_album ),
                  title: Text('Galeria'),
                  onTap: (){
                    getImage(ImageSource.gallery);
                  },
                )
              ],
            );
          }
      );
    } else {
      showCupertinoModalPopup(
          context: state.context,
          builder: (context){
            return CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text('Camara'),
                  onPressed: (){
                    getImage(ImageSource.camera);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text('Galeria'),
                  onPressed: (){
                    getImage(ImageSource.gallery);
                  },
                )
              ],
            );
          }
      );
    }
  }

  getImage(ImageSource image_source) async {
    Navigator.pop(state.context);

    File _image;
    final imagePicker = ImagePicker();

    final pickedFile = await imagePicker.getImage(source: image_source, imageQuality: 30);

    setState(() {
      if(pickedFile != null){
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text('Espere mientras se sube la imagen...'),
        ));
        _image = File(pickedFile.path);
        _chatRepository.uploadImage(_image).then((_attachement){
          if(_attachement != null) {
            addImageMessage(_attachement);
          } else {
            ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
              content: Text('Hubo un error al cargar la imagen'),
            ));
            ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
              content: Text('Es posible que su imagen tenga un peso mayor al esperado'),
            ));
            ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
              content: Text('Pruebe haciendo una captura de pantalla'),
            ));
          }
        });
      } else {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text('No se seleccionó ninguna imagen'),
        ));
      }
    });
  }

  addImageMessage(Attachement attachement) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss', ).format(now);
    String timeZone = '';
    if (now.timeZoneOffset.toString().length == 15) {
      timeZone = '0' + now.timeZoneOffset.toString().substring(1, 5);
    } else {
      timeZone = now.timeZoneOffset.toString().substring(0, 5);
    }
    String date = formattedDate + '-' + timeZone;
    if(date.endsWith(':')){
      date = date.substring(0, date.length - 1);
    }
    print(attachement.toMap());
    Message _message = new Message.fromJSON({
      'attachement'     : attachement.toMap(),
      'id'              : (messages.length + 1).toString(),
      'content'         : '',
      'chatId'          : chat.id,
      'senderName'      : currentUser.value.name,
      'date'            : date,
      'reactions'       : [],
      'senderId'        : currentUser.value.firestore_id,
      'senderPhotoUrl'  : currentUser.value.image.url
    });
    await _chatRepository.addImageMessage(_message, hasImage: true).then((value) {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text('Se subió una imagen'),
      ));
      // chat.participantIds.forEach((_participantId) {
      //   if (_participantId != currentUser.value.firestore_id) {
      //     sendNotification('Nuevo archivo', "Nuevo mensaje de" + " " + currentUser.value.name, _participantId);
      //   }
      // });
    });
    setState(() { });
  }

// print(messages);
// if (messages.isNotEmpty) {
//   messages.sort();
//   messages.add(int.parse(event.docs.last.data()['id']));
// } else {
// event.docs.forEach((element) {
//   // print(element.data()['id']);
//   // print('Linea 64 ${messages.toString()}');
//   messages.add(int.parse(element.data()['id']));
//   messages.sort();
// });
// print(messages);
// print('Llegaron los datos');
// }


// listenForChatByOrderId(orderId) async {
//   await _chatRepository.getChatByOrderId(orderId).then((value){
//     setState(() {
//       chat = value;
//     });
//   });
// }

// createConversation(Conversation _conversation) async {
//   _conversation.users.insert(0, currentUser.value);
//   _conversation.lastMessageTime = DateTime.now().toUtc().millisecondsSinceEpoch;
//   _conversation.readByUsers = [currentUser.value.id];
//   setState(() {
//     conversation = _conversation;
//   });
//   _chatRepository.createConversation(conversation).then((value) {
//     listenForChats(conversation);
//   });
// }

// listenForConversations() async {
//   _chatRepository.getUserConversations(currentUser.value.id).then((snapshots) {
//     setState(() {
//       conversations = snapshots;
//     });
//   });
// }

// listenForChats(Conversation _conversation) async {
//   _conversation.readByUsers.add(currentUser.value.id);
//   _chatRepository.getChats(_conversation).then((snapshots) {
//     setState(() {
//       chats = snapshots;
//       //chats.
//     });
//   });
// }

// orderSnapshotByTime(AsyncSnapshot snapshot) {
//   final docs = snapshot.data.documents;
//   docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
//     var time1 = a.get('time');
//     var time2 = b.get('time');
//     return time2.compareTo(time1) as int;
//   });
//   return docs;
// }
}
