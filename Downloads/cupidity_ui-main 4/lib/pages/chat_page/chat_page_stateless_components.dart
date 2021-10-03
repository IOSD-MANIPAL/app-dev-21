import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_registreation1/pages/chat_page/chatting_page.dart';
import 'package:new_registreation1/pages/chat_page/models.dart';

const double _Large = 12;
const double _Medium = 8;
const double _Small = 4;
Color _maroon = Color(0xffDA2753);
Color _notBlack = Color(0xff2F2E41);
Color _white = Color(0xffFFFFFF);
Color _pinkish = Color(0xffFE3782);
Color _pinkish2 = Color(0xffEB3581);
Color _shadow = Color(0xffBDBFC0);

//Message card to display list of recieved messages
class MessageCard extends StatelessWidget {
  final RecievedConversation data;
  const MessageCard({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width * 10;

    return ListTile(
      onTap:  () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(data)));
      },
      subtitle:Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder(
          stream: data.getLatestMessage(),
          builder: (context, snapshot) {
            var newMessageData;
            try {
              newMessageData = snapshot.data.data();
            }
            catch(e){
              print(e);
            }
            if(newMessageData==null){
              return Container();
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${newMessageData['latest-message']??" "}"),
                (){
                var newMessageNotification=newMessageData["new-message-notification-${data.userId}"];
                print(newMessageNotification);
                if(newMessageNotification=="unread"){
                return Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: _pinkish,
                    shape: BoxShape.circle
                  ),
                );
                }

                if(newMessageNotification=="read" || newMessageNotification==0){
                  return Container();
                }
                throw Exception("Undefined Message Notification State");
              }(),
              ],
            );
          }
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(data.recipient.imageUrl),
        radius: MediaQuery.of(context).size.width * 0.1,
      ),
      title:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${data.recipient.name}",
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            "${data.conversationStartTime}",
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}
