import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  static const routeNmae = '/signin';
  var books;
  SignInPage({Key key, this.books}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loading = false;

  _googleSignIn() async {
    final bool isSignedIn = await GoogleSignIn().isSignedIn();
    GoogleSignInAccount googleUser;
    googleUser = isSignedIn
        ? await GoogleSignIn().signInSilently()
        : await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final User user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    print("signed in " + user.displayName);

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) async {
      if (value.data == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'email': user.email, 'create': DateTime.now()});
        print('Create data');
      }
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignIn Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loading ? Text('Logging in ...') : Text('Click to Sign In'),
            _loading
                ? CircularProgressIndicator()
                : SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      try{
                        setState(() {
                          _loading = true;
                        });
                        await _googleSignIn();
                        FirebaseAuth.instance.authStateChanges().listen((fu) {
                          print(fu);
                          Navigator.pushReplacementNamed(context, '/home', arguments: {
                            'user':fu,
                            'books':widget.books
                          });
                        });
                        _loading = false;
                      }catch(e){
                        print(e);
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}
