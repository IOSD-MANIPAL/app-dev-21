//This contains the view for where the actual conversations take place

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/chat_page/models.dart';

class ConversationScreen extends StatefulWidget {
  final RecievedConversation data;
  const ConversationScreen(
    this.data, {
    Key key,
  }) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String reportString = 'Report';
  String unMatchString = 'Un-Match';
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: chatAppBar(context, w),
      body: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/doodle.svg',
              alignment: Alignment.center,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: [
                //create List of Messages

                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    child: widget.data.conversationId == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.pink),
                            ),
                          )
                        : MessageSection(
                            widget: widget,
                            w: w,
                            listScrollController: listScrollController),
                  ),
                ),
                ChatInput(
                  data: widget.data,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar chatAppBar(context, double w) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      elevation: 0.1,
      leadingWidth: w * 0.1,
      leading: IconButton(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: w * 0.04),
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xff381d21),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ProfilePage()));
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.data.recipient.imageUrl),
                maxRadius: 20,
              ),
            ),
            Text(
              widget.data.recipient.name,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xff381d21),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Color(0xff381d21),
          ),
          // color:
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: handlePopupMenuClick,
          itemBuilder: (BuildContext context) {
            // ignore: sdk_version_set_literal
            return {
              reportString,
              unMatchString,
            }.map(
              (String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: ListTile(
                    hoverColor: Colors.pink,
                    isThreeLine: false,
                    dense: true,
                    horizontalTitleGap: 0,
                    leading: choice == reportString
                        ? const SizedBox(
                            width: 24, child: Icon(Icons.warning_rounded))
                        : const SizedBox(width: 24, child: Icon(Icons.cancel)),
                    title: Text(
                      choice,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                );
              },
            ).toList();
          },
        ),
      ],
    );
  }

  void handlePopupMenuClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }
}

class MessageSection extends StatelessWidget {
  const MessageSection({
    Key key,
    @required this.widget,
    @required this.w,
    @required this.listScrollController,
  }) : super(key: key);

  final ConversationScreen widget;
  final double w;
  final ScrollController listScrollController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.data.loadMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            itemBuilder: (context, index) {
              String myId = widget.data.userId;
              //When I am the sender
              // print(snapshot.data.docs[index]);
              if (snapshot.data.docs[index].data()['sender'] == myId) {
                return RightBubble(
                    data: snapshot.data.docs[index].data()['data']);
              }
              //When I am the recipient
              if (snapshot.data.docs[index].data()['recipient'] == myId) {
                return LeftBubble(
                    data: snapshot.data.docs[index].data()['data']);
              }
              throw Exception(
                  "No Conditioned recognised for message String parssing");

              return LeftBubble();
            },
            itemCount: snapshot.data.docs.length,
            controller: listScrollController,
          );
        }
      },
    );
  }
}

class RightBubble extends StatelessWidget {
  final String data;
  const RightBubble({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, minHeight: 50),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: 45),
      child: Bubble(
        padding: const BubbleEdges.symmetric(horizontal: 12, vertical: 6),
        color: const Color(0xfffe3c72),
        elevation: 0.0,
        radius: const Radius.circular(12),
        nipWidth: 12,
        nip: BubbleNip.rightBottom,
        margin: const BubbleEdges.symmetric(vertical: 8),
        nipRadius: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Text(
            data,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class LeftBubble extends StatelessWidget {
  final String data;

  const LeftBubble({
    this.data,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, minHeight: 50),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 45),
      child: Bubble(
        padding: const BubbleEdges.symmetric(horizontal: 12, vertical: 6),
        color: const Color(0xffff5864),
        elevation: 0.0,
        radius: const Radius.circular(12),
        nipWidth: 12,
        nip: BubbleNip.leftBottom,
        margin: const BubbleEdges.symmetric(vertical: 8),
        nipRadius: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Text(
            data,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Profile Page"),
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput({Key key, this.data}) : super(key: key);
  final RecievedConversation data;

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final FocusNode focusNode = FocusNode();

  final TextEditingController textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 0.1,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: textEditController,
              focusNode: focusNode,
              cursorHeight: 24,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 1,
              cursorColor: const Color(0xffFE3782),
              decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0)),
            ),
          ),
          MaterialButton(
            onPressed: () {
              // print("--${textEditController.text}");

              widget.data.sendMessage(textEditController.text);
              textEditController.clear();
            },
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
            // fillColor: Colors.white,
            child: SvgPicture.asset(
              'assets/Send.svg',
              color: const Color(0xffe24985),
              alignment: Alignment.center,
              allowDrawingOutsideViewBox: true,
              //  fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
