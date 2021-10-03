//This contains functions and utilities that provide data base access and processing for the chat page views.dynamic
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:new_registreation1/models/app_user.dart';
import 'package:new_registreation1/pages/chat_page/models.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

///This function makes a call to firebase to initialize all conversations without their message data
Future<List<RecievedConversation>> loadConversations() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userId = auth.currentUser.uid;
  List chatIndex;
  List<RecievedConversation> conversations = [];

  DocumentSnapshot myUser = await users.doc(userId).get();
  chatIndex = myUser['chat_index'];
  for (var i = 0; i < chatIndex.length; i++) {
    DocumentSnapshot chatValue = await FirebaseFirestore.instance.collection('chats').doc(chatIndex[i]).get().catchError((e){
      print("Found in index but not in chat section");
    });
    //Find the person you are chatting withs ID
    List membersOfTheConversation = chatValue['members'];
    //Pick all members that are not you
    membersOfTheConversation.remove(userId);

    //Use the id to retreive his details from the user collection
    for (var i = 0; i < membersOfTheConversation.length; i++) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(membersOfTheConversation[i]).get();
      final data = userDoc;
      final name = data['name'];
      final id = membersOfTheConversation[i];
      final image = data["imageUrl"][0];
      print(chatValue.data());
      final conversationStartDate = chatValue['start-date'];
      final conversationStartTime = chatValue['start-time'];
      conversations.add(
          RecievedConversation(conversationId: chatIndex[i], recipient: ConversationUser(name, id, image), conversationStartDate: conversationStartDate, conversationStartTime: conversationStartTime,userId: userId));
    }
    //Send it to recived conversation object.
    //
  }
  print(conversations);
  return conversations;
}

//When a new match is found then start a conversation
void initializeNewMatchConversations() {
  //Get all matches
  List userMatches;
  var response;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userId = auth.currentUser.uid;
  final startDate = DateFormat("yy-MM-dd").format(DateTime.now());
  final currentTime = DateFormat("h:mm a").format(DateTime.now());

  getCurrentAppUserData().then((currentUserData) {
    response = json.decode(currentUserData.body);
    appUserData(response);
    userMatches = (response as Map)['meta']['user_matches'];
    //find the hash of the matches and the user
    if (userMatches != null) {
      userMatches.forEach((matchedPerson) {

        var messageId =  md5
            .convert(utf8.encode((userId.hashCode ^ matchedPerson["_id"].hashCode).toString()))
            .toString();
        //Check chats if their conversation exists,
        CollectionReference chats = FirebaseFirestore.instance.collection('chats');
        chats.get().then((chats){
          chats.docs.forEach((chat){
            var messageExistsInChats=false;
            var messageExistsInIndex=false;

            if(chat.id==messageId){
              messageExistsInChats=true;
              //Do nothing
            }
            else{
              messageExistsInChats=false;
              print("Message does not exist");
              //Write to firestore chats that these two people are having a conversation.
              print(messageId);
              FirebaseFirestore.instance.collection('chats').doc(messageId).set(
                  messageMetaDataTemplate(senderId: userId, recieverId: matchedPerson["_id"], startDate: startDate, stopDate: startDate, startTime: currentTime)
              , SetOptions(merge: true)
              );
            }
            //Check their chat index if they have the conversation id.
            CollectionReference users = FirebaseFirestore.instance.collection('users');
            users.doc(userId).get().then((accountInformation) {
              if(accountInformation['chat_index']==messageId){
                    messageExistsInIndex=true;
              }
              else{
                //Write Message to index
                print("Message does not exist in my index");
                users.doc(userId).update({
                  'chat_index': FieldValue.arrayUnion([messageId])
                });
              }
            });
            //Check the matched persons chat index
            users.doc(matchedPerson['_id']).get().then((accountInformation) {
              if(accountInformation['chat_index']==messageId){
                messageExistsInIndex=true;
              }
              else{
                //Write Message to index
                print("Message does not exist in recipient index");
                users.doc(matchedPerson['_id']).update({
                  'chat_index': FieldValue.arrayUnion([messageId])
                });
              }
            });
          }
        );
        });

      });
    }
  });


}



List<String> appUserMatches() {
  var response;
  getCurrentAppUserData().then((value) {
    response = json.decode(value.body);
    AppUser appUser = appUserData(response);
    return appUser.matches;
  });
}

Future getCurrentAppUserData() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  var res = json.encode({
    "target_id": user.uid,
  });
  final response = await http.post(
    Uri.parse("https://cupidity-api.herokuapp.com/users/fetchUser/?API_KEY=CUPIDITY"),
    body: res,
    headers: {"Content-Type": "application/json"},
  );

  return response;
}

AppUser appUserData(Map responseData) {
  return AppUser(
    age: responseData["cached_age"],
    name: responseData["name"],
    ageMaxPref: responseData["age_pref"]["age_max"],
    ageMinPref: responseData["age_pref"]["age_min"],
    bio: responseData["bio"],
    images: responseData["images"],
    profile: responseData["images"][0],
    gender: responseData["gender"],
    genderPref: responseData["gender_pref"],
    uid: responseData["_id"],
    dob: responseData["dob"],
    likedBy: responseData["meta"]["user_liked_by"],
    matches: responseData["meta"]["user_matches"],
    dislikes: responseData["meta"]["user_dislikes"],
    favArtists: responseData["fav_artists"],
  );
}

Map<String,dynamic> messageMetaDataTemplate({String senderId, String recieverId, String startDate, String stopDate, String startTime}) => {
      "members": [senderId, recieverId],
      "start-date": startDate.toString(),
      "stop-date": stopDate.toString(),
      "start-time": startTime,
      "new-message-notification-$senderId":0
    };
