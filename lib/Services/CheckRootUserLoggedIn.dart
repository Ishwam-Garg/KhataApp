import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khata_app/FinanceScreen.dart';
import 'package:khata_app/Screens/Views/BottomNavBarScreen.dart';
import 'package:khata_app/Services/Auth.dart';
import 'package:khata_app/SignInScreen.dart';

class RootUserLoggedIn extends StatelessWidget {
  User user;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot){
        if(snapshot.hasData)
        {
          return BottomNavScreen(user);
          //return Home();
        }
        else
        {
          return SignInScreen();
        }
      },
    );
  }
}
