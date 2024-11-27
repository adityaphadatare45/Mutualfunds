import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservices {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async{
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
       if( googleUser == null )  return null;
        
      final GoogleSignInAuthentication? gooleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gooleAuth?.accessToken,
        idToken: gooleAuth?.idToken
      );
       
       final UserCredential userCredential = await _auth.signInWithCredential(credential);
       return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error:$e");
      return null;
    }
  }
  Future<void> signOut() async{
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}