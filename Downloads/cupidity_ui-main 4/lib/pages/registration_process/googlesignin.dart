import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
AuthCredential credential;
Future<User> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn().catchError((onError) {
    print("googleSignInAccount -- $onError");
  });
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication.catchError((onError) {
    print(onError.runtimeType);
    log("googleSignInAuthentication -- $onError");
  });

  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential).catchError((onError) {
    log("signInWithCredential -- $onError");
  });
  final User user = userCredential.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    log('signInWithGoogle succeeded: $user');
    print("User is NEW: " +
        (user.metadata.creationTime == user.metadata.lastSignInTime)
            .toString());
    return user;
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}
