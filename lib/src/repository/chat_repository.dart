import 'dart:convert';
import 'dart:io';


import '../models/attachement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mime_type/mime_type.dart';
import '../models/message.dart';
import 'user_repository.dart';
import '../models/conversation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart' as userModel;
import 'package:path/path.dart';

class ChatRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<QuerySnapshot> getChatByOrderId(String orderId) async{
    return await FirebaseFirestore.instance.collection("chats").where("orderId", isEqualTo: orderId).get();
  }

  Future<QuerySnapshot> getChatByShippingId(String shippingId) async{
    return await FirebaseFirestore.instance.collection("chats").where("shippingId", isEqualTo: shippingId).get();
  }

  Future<String> createOrderChat(String orderId) async {
    return await FirebaseFirestore.instance.collection('chats')
        .add({
      'lastMessage' : "",
      'lastNameWriter' : "",
      'orderId' : orderId,
      'orderName' : "Pedido de ${currentUser.value.name}",
      'ownerId' : int.parse(currentUser.value.id),
      'participantIds' : [
        currentUser.value.firestore_id
      ],
      'photoOrdering' : "https://detoditoapp.net/images/avatar_default.png",
      'photoUrlLastWriter' : "https://detoditoapp.net/images/avatar_default.png"
    })
        .then((value){
      return value.id;
    })
        .catchError((e){
      return null;
    });
  }

  Future<String> createShippingChat(String shippingId) async {
    return await FirebaseFirestore.instance.collection('chats')
        .add({
      'lastMessage' : "",
      'lastNameWriter' : "",
      'shippingId' : shippingId,
      'orderName' : "Pedido de ${currentUser.value.name}",
      'ownerId' : int.parse(currentUser.value.id),
      'participantIds' : [
        currentUser.value.firestore_id
      ],
      'photoOrdering' : "https://detoditoapp.net/images/avatar_default.png",
      'photoUrlLastWriter' : "https://detoditoapp.net/images/avatar_default.png"
    })
        .then((value){
      return value.id;
    })
        .catchError((e){
      return null;
    });
  }

  Future<Stream<QuerySnapshot>> getChatsByUserId(int userId) async {
    return await FirebaseFirestore.instance.collection('chats').where("ownerId", isEqualTo: userId).orderBy('orderId', descending: true).snapshots();
  }

  Future<Stream<QuerySnapshot>> getMessagesByChatId(String chatId) async {
    return await FirebaseFirestore.instance.collection("messages").where("chatId", isEqualTo: chatId).orderBy('date').snapshots();
    // print('Obtener mensajes de chatId: $chatId');
  }

  Future<void> addMessage(Message message, {bool hasImage}) async {
    return FirebaseFirestore.instance.collection('messages').doc().set(message.toMap(hasImage));
  }

  Future<Attachement> uploadImage(File image) async {
    File _image = image;
    userModel.User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final url = Uri.parse('${GlobalConfiguration().getValue('api_base_url')}messages/upload-file?$_apiToken');
    final mimeType = mime(_image.path).split('/');
    final fileName = basename(_image.path);
    final fileSize = _image.lengthSync() / 1000;

    final imageUploadRequest = http.MultipartRequest(
        'POST',
        url
    );

    final imageToUpload = await http.MultipartFile.fromPath(
      'file',
      _image.path,
    );

    imageUploadRequest.files.add(imageToUpload);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print(resp.body);
      return null;
    } else {
      print('Se subio la imagen');
      print(fileSize);
      print(fileName);
      print(mimeType);
      print(json.decode(resp.body)['data']['fileUrl']);

      return Attachement.fromJSON({
        'size'     : '${fileSize} Kb',
        'name'     : fileName,
        'mimetype' : '${mimeType[0]}/${mimeType[1]}',
        'url'      :  json.decode(resp.body)['data']['fileUrl'].toString()
      });
    }

  }

  Future<void> addImageMessage(Message message, {bool hasImage}) async {
    return FirebaseFirestore.instance.collection('messages').doc().set(message.toMap(hasImage));
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String token) async {
    return FirebaseFirestore.instance.collection("users").where("token", isEqualTo: token).get().catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance.collection("users").where('userName', isEqualTo: searchField).get();
  }

  // Create Conversation
  Future<void> createConversation(Conversation conversation) {
    return FirebaseFirestore.instance.collection("conversations").doc(conversation.id).set(conversation.toMap()).catchError((e) {
      print(e);
    });
  }

  Future<Stream<QuerySnapshot>> getUserConversations(String userId) async {
    return await FirebaseFirestore.instance
        .collection("conversations")
        .where('visible_to_users', arrayContains: userId)
    //.orderBy('time', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChats(Conversation conversation) async {
    return updateConversation(conversation.id, {'read_by_users': conversation.readByUsers}).then((value) async {
      return await FirebaseFirestore.instance
          .collection("conversations")
          .doc(conversation.id)
          .collection("chats")
          .orderBy('time', descending: true)
          .snapshots();
    });
  }


  Future<void> updateConversation(String conversationId, Map<String, dynamic> conversation) {
    return FirebaseFirestore.instance.collection("conversations").doc(conversationId).update(conversation).catchError((e) {
      print(e.toString());
    });
  }
}
