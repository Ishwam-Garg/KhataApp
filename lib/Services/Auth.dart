import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

Future<bool> google_sign_in() async {

  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  if(googleSignIn != null)
  {
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken , accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User user = await auth.currentUser;

    print(user.uid);

    return Future.value(true);
  }

}

Future<User> getCurrentUser() async{
  User user = await auth.currentUser;
  return user;
}