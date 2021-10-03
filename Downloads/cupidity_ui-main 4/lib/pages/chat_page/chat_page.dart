import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_registreation1/pages/Constants/colors.dart';
import 'package:new_registreation1/pages/chat_page/chat_page_stateless_components.dart';

import 'chat_services.dart';
import 'models.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  static const double large = 12;
  static const double medium = 8;
  static const double small = 4;

  Future<List<RecievedConversation>> receivedConversation;
  @override
  void initState() {
    receivedConversation = loadConversations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ThemeColor.white,
        body: SafeArea(
          child: Column(
            children: [
              matchAppBar(context),
              // matchedProfiles(h),
              // messageAppBar(context),
              messages(h)
//if there are no messages, the following widget should be used
              // noMessagesUI(w, h),
            ],
          ),
        ));
  }

  Padding matchAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: large, vertical: small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          Text(
            "Messages",
            style: Theme.of(context).textTheme.headline6,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                initializeNewMatchConversations(); //Start a conversation with all new matches
              });
            },
            iconSize: 25,
          )
        ],
      ),
    );
  }

  Container userMatches(index) {
    return Container(
        height: double.infinity,
        padding: const EdgeInsets.only(right: large, top: small, bottom: small),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("---"),
            ),
            Text("--")
          ],
        ));
  }

  Widget messages(double h) {
    return Expanded(
      child: FutureBuilder(
          future: receivedConversation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return noMessagesUI();
              }
              return Container(
                padding: const EdgeInsets.symmetric(
                    vertical: large, horizontal: medium),
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data != null) {
                        final data = snapshot.data[index];
                        return MessageCard(data: data);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                    separatorBuilder: (context, index) => const Divider(
                          color: ThemeColor.shadow,
                          indent: 8,
                          endIndent: 8,
                        ),
                    itemCount: snapshot.data.length),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Padding messageAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: large),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Messages",
            style: Theme.of(context).textTheme.headline6,
          )),
    );
  }

  Container matchedProfiles(double h) {
    return Container(
      padding: const EdgeInsets.only(left: large),
      height: h * 0.18,
      child: Center(
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return userMatches(index);
            }),
      ),
    );
  }

  Column noMessagesUI() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // height: 250,
            child: SvgPicture.asset('assets/noMessage.svg')),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            "No message, yet\n",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: ThemeColor.notBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
