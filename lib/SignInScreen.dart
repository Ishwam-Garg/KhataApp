import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khata_app/Screens/Views/BottomNavBarScreen.dart';
import 'package:khata_app/Services/Auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:khata_app/FinanceScreen.dart';
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
                    child: AutoSizeText('Hi, There.\nWelcome',
                      style: TextStyle(color: Colors.white.withOpacity(0.95),fontSize: 58,fontWeight: FontWeight.w600),maxFontSize: 58,minFontSize: 12,),
                ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.3,
              left: MediaQuery.of(context).size.width*0.05,
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: AutoSizeText(
                  'Tired of keeping records in registers?\nYou are steps away from saving a ton of time and keeping yourself relaxed',
                  style: TextStyle(color: Colors.white.withOpacity(0.95),fontWeight: FontWeight.bold,fontSize: 20),
                  overflow: TextOverflow.clip,),
              ),
            ),
            /*
            Positioned(
              top: MediaQuery.of(context).size.height*0.5,
              left: MediaQuery.of(context).size.width*0.1,
              right: MediaQuery.of(context).size.width*0.1,
              child: Container(width: MediaQuery.of(context).size.width*0.8,
              child: AutoSizeText('Sign In Using Google',textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600),),),
            ),
            */
            Positioned(
              top: MediaQuery.of(context).size.height*0.6,
              left: MediaQuery.of(context).size.width*0.2,
              right: MediaQuery.of(context).size.width*0.2,
              child: GestureDetector(
                onTap: (){
                  //signInMethod + CreateUserInFireStore
                  google_sign_in().then((user){
                    if(user!=null)
                      {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return WillPopScope(
                            onWillPop: () async{
                              await googleSignIn.disconnect();
                              FirebaseAuth.instance.signOut();
                              return true;
                            },
                            child: AlertDialog(
                              title: Align(
                                alignment: Alignment.center,
                                child: Text('Press Back to exit or Continue'),
                              ),
                              content: Container(
                                height: MediaQuery.of(context).size.height*0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: MediaQuery.of(context).size.width*0.1,
                                      backgroundImage: NetworkImage(user.photoURL),
                                    ),
                                    Text(user.displayName,textAlign: TextAlign.center,),
                                    Text(user.email,textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async{
                                        await googleSignIn.disconnect();
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pop(context);
                                        return true;
                                      },
                                      child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                            child: Text('Back',style: TextStyle(color: Colors.red.shade500,fontWeight: FontWeight.bold),)
                                        ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Fluttertoast.showToast(msg: 'Logged In',backgroundColor: Colors.white,textColor: Colors.black,gravity: ToastGravity.CENTER,toastLength: Toast.LENGTH_SHORT);
                                        CreateUserInFireStore();
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavScreen(user)));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.green.shade500,
                                              width: 2,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.green.shade500,
                                              width: 2,
                                            ),
                                            right: BorderSide(
                                              color: Colors.green.shade500,
                                              width: 2,
                                            ),
                                            left: BorderSide(
                                              color: Colors.green.shade500,
                                              width: 2,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text('Continue',style: TextStyle(color: Colors.green.shade400,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      );

                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                      }
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
            Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('assets/images/House.gif',height: MediaQuery.of(context).size.width*0.5,width: MediaQuery.of(context).size.width*0.5,)),
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
