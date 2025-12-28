import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      Get.log('Error adding user info: $e', isError: true);
    });
  }

  getUserInfo(String token) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("token", isEqualTo: token)
        .get()
        .catchError((e) {
      Get.log('Error getting user info: $e', isError: true);
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  // Create Message
  Future<void> createMessage(Message message) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(message.id)
        .set(message.toJson())
        .catchError((e) {
      Get.log('Error creating message: $e', isError: true);
    });
  }

  // to remove message from firebase
  Future<void> deleteMessage(Message message) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(message.id)
        .delete()
        .catchError((e) {
      Get.log('Error deleting message: $e', isError: true);
    });
  }

  Stream<QuerySnapshot> getUserMessages(String userId, {perPage = 10}) {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('visible_to_users', arrayContains: userId)
        .orderBy('time', descending: true)
        .limit(perPage)
        .snapshots();
  }

  Future<Message> getMessage(Message message) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(message.id)
        .get()
        .then((value) {
      return Message.fromDocumentSnapshot(value);
    });
  }

  Stream<QuerySnapshot> getUserMessagesStartAt(
      String userId, DocumentSnapshot lastDocument,
      {perPage = 10}) {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('visible_to_users', arrayContains: userId)
        .orderBy('time', descending: true)
        .startAfterDocument(lastDocument)
        .limit(perPage)
        .snapshots();
  }

  Stream<List<Chat>> getChats(Message message) {
    updateMessage(message.id!, {'read_by_users': message.readByUsers});
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(message.id)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Chat> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Chat.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<void> addMessage(Message message, Chat chat) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(message.id)
        .collection("chats")
        .add(chat.toJson())
        .whenComplete(() {
      updateMessage(message.id!, message.toUpdatedMap());
    }).catchError((e) {
      Get.log('Error adding message: $e', isError: true);
    });
  }

  Future<void> updateMessage(String messageId, Map<String, dynamic> message) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(messageId)
        .update(message)
        .catchError((e) {
      Get.log('Error updating message: $e', isError: true);
    });
  }

  Future<String> uploadFile(File _imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(_imageFile);
    return uploadTask.then((TaskSnapshot storageTaskSnapshot) {
      return storageTaskSnapshot.ref.getDownloadURL();
    }, onError: (e) {
      throw Exception(e.toString());
    });
  }
}
