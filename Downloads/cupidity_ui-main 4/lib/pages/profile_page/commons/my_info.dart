import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_registreation1/models/app_user.dart';
import 'package:new_registreation1/pages/profile_page/about_me/about_me_info.dart';
import 'package:new_registreation1/pages/profile_page/style_guide/text_style.dart';

class MyInfo extends StatefulWidget {
  final AppUser appUser;

  const MyInfo({Key key, this.appUser}) : super(key: key);
  @override
  _MyInfoState createState() => _MyInfoState(appUser);
}

class _MyInfoState extends State<MyInfo> {
  final AppUser appUser;
  _MyInfoState(this.appUser);

  @override
  void initState() {
    super.initState();
    appUser.printDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.height / 12,
              backgroundImage: NetworkImage(
                appUser.profile,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  appUser.name,
                  style: whiteNameTextStyle,
                ),
                Text(
                  ", ${appUser.age}",
                  style: whiteNameTextStyle,
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ],
            ),
          ),
          Text(
            // "Lorem Ipsymflesw fjoewo ifjoi cvrju whfjvwnjg fklj  fdklsfj kl femcki ",
            '${appUser.gender}',
            style: titleStyle,
            softWrap: true, maxLines: 5, textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              // "Lorem Ipsymflesw fjoewo ifjoi cvrju whfjvwnjg fklj  fdklsfj kl femcki ",
              '${appUser.bio}',
              style: whiteSubHeadingTextStyle,
              softWrap: true, maxLines: 5, textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
