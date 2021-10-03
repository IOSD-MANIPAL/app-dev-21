import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:new_registreation1/models/app_user.dart';

import 'chat_services.dart';

class RecievedConversation{
  List<Message> conversation;//Turn this to a stream to recieve live updates.
  int _messageLength;
  ConversationUser recipient;
  String userId;
  String conversationId;
  String conversationStartDate;
  String conversationStopDate;
  String conversationStartTime;
  String conversationStopTime;




  RecievedConversation({this.conversationId,this.recipient,this.conversationStartDate,this.conversationStartTime,this.userId}){
  }
  Stream NewMessageNotifier(){
    return FirebaseFirestore.instance.collection('chats').doc(
        conversationId
    ).collection('message-data').snapshots();
  }
  Stream getLatestMessage(){
    return FirebaseFirestore.instance.collection('chats').doc(
        conversationId
    ).snapshots();
  }

  Stream loadMessages() {
    FirebaseFirestore.instance.collection('chats').doc(
        conversationId
    ).update({
      "new-message-notification-$userId":"read"
    });
    return FirebaseFirestore.instance.collection('chats').doc(conversationId).collection('message-data').snapshots();
  }


  void sendMessage(String message) {
    FirebaseFirestore.instance.collection('chats')
          .doc(conversationId)
          .collection('message-data')
          .doc(DateTime.now().toString())
          .set(_messageConversationTemplate(date: DateTime.now().toString(), data: message, senderId: userId, recieverId: recipient.id)
          ,SetOptions(merge: true)
    )
          .catchError((e) {
        print(e);
      });
    FirebaseFirestore.instance.collection('chats').doc(
      conversationId
    ).update({
      "latest-message":message,
      "new-message-notification-${recipient.id}":"unread"
    });
  }
  Map<String,String>  _messageConversationTemplate({String date, String data, String senderId, String recieverId}) => {'date': date, "data": data, 'sender': senderId, 'recipient': recieverId};

}

class Message{
  final String data;
  final String date;
  final String recipientId;
  final String senderId;
  Message(this.data, this.date, this.recipientId, this.senderId);

}

class ConversationUser{
  final String name;
  final String id;
  final String imageUrl;
  ConversationUser(this.name,this.id,this.imageUrl);
}