import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khata_app/Services/Auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:khata_app/HomeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple,
                Colors.deepPurple.withOpacity(0.9),
                Colors.deepPurple.withOpacity(0.8),
              ]),
        ),
        child: Stack(
          children: [
            Positioned(
                left: MediaQuery.of(context).size.width*0.05,
                top: MediaQuery.of(context).size.height*0.05,
                child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: AutoSizeText('Welcome',style: TextStyle(color: Colors.white,fontSize: 58,fontWeight: FontWeight.w600),maxFontSize: 58,minFontSize: 12,),
                ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.2,
              left: MediaQuery.of(context).size.width*0.05,
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: AutoSizeText(
                  'Your monthly Records\nAwaits you to fill them!',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                  overflow: TextOverflow.clip,),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.4,
              left: MediaQuery.of(context).size.width*0.1,
              right: MediaQuery.of(context).size.width*0.1,
              child: Container(width: MediaQuery.of(context).size.width*0.8,
              child: AutoSizeText('Sign In Using Google',textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600),),),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.5,
              left: MediaQuery.of(context).size.width*0.2,
              right: MediaQuery.of(context).size.width*0.2,
              child: GestureDetector(
                onTap: (){
                  //signInMethod + CreateUserInFireStore
                  google_sign_in().whenComplete((){
                    Fluttertoast.showToast(msg: 'Logging In Please Wait',backgroundColor: Colors.white,textColor: Colors.black,gravity: ToastGravity.CENTER,toastLength: Toast.LENGTH_SHORT);
                    CreateUserInFireStore();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                  });
                },
                child: Material(
                  elevation: 10,
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: AutoSizeText('Google Sign In',
                                style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),
                                maxLines: 1,
                                maxFontSize: 28,
                                minFontSize: 14,
                                textAlign: TextAlign.right,),
                          ),
                          SizedBox(width: 5,),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/google.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CreateUserInFireStore() async{

    User user = await auth.currentUser;
    DocumentReference ref = FirebaseFirestore.instance.collection("Users").doc(user.email);

    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    String searchIndexWord = user.displayName.replaceAll(" ","").toLowerCase();
    List<String> searchIndex = [];

    for(int i=0;i<=searchIndexWord.length;i++)
    {
      searchIndex.add(searchIndexWord.substring(0,i));
    }

    Map<String,dynamic> UserData = {
      "Name": user.displayName,
      "uid": user.uid,
      "photoUrl": user.photoURL,
      "phoneNumber": user.phoneNumber,
      "Email": user.email,
      "loginDate": formattedDate.toString(),
      "loginMode": "Google Mail",
      "SearchIndex": searchIndex,
    };

    ref.set(UserData);

  }

}
