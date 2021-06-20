import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khata_app/FinanceScreen.dart';
import 'package:khata_app/Screens/Views/Fitness_screen.dart';
import 'package:khata_app/Screens/Views/Schedulescreen.dart';
import 'package:khata_app/Screens/Views/Todoscreen.dart';
import 'package:khata_app/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khata_app/SignInScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
class BottomNavScreen extends StatefulWidget {
  final User user;
  BottomNavScreen(this.user);
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  User user = FirebaseAuth.instance.currentUser;
  int _CurrentPage = 0;

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
              ),
            ),
          ),
          backgroundColor: Colors.deepPurple,
          title: Text('Khata App',style: TextStyle(color: Colors.white),),
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: ()async{
                //log out here
                Fluttertoast.showToast(msg: 'Logging Out',textColor: Colors.black,toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.white,gravity: ToastGravity.BOTTOM);
                final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

                try{
                  await googleSignIn.disconnect();
                }
                catch(e){
                  print("Google sign out error : $e");
                }
                try{
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
                  await _firebaseAuth.signOut();
                }catch(e)
                {
                  print("Firebase sign out error : $e");
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Log out',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                    Icon(Icons.supervisor_account,color: Colors.purple,),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (value){
            setState(() {
              _CurrentPage = value;
              _pageController.animateToPage(value, duration: Duration(milliseconds: 5), curve: Curves.easeIn);
            });
          },
          children: [
            FinanceScreen(user),
            TodoScreen(user),
            ScheduleScreen(user),
            FitnessScreen(user),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.deepPurple,
            currentIndex: _CurrentPage,
            unselectedItemColor: Colors.white70,
            selectedItemColor: Colors.white,
            onTap: (value)
            {
              _pageController.animateToPage(value, duration: Duration(milliseconds: 5), curve: Curves.easeIn);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(_CurrentPage == 0 ? Icons.monetization_on_outlined : Icons.monetization_on,color: Colors.white,),
                label: 'Finance',
              ),
              BottomNavigationBarItem(
                icon: Icon(_CurrentPage == 1 ? Icons.task_outlined : Icons.task,color: Colors.white,),
                label: 'Todo',
              ),
              BottomNavigationBarItem(
                icon: Icon(_CurrentPage == 2 ? Icons.lock_clock_outlined : Icons.lock_clock,color: Colors.white,),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(_CurrentPage == 3 ? Icons.health_and_safety_outlined : Icons.health_and_safety,color: Colors.white,),
                label: 'Fitness',
              ),
            ]
        ),
      ),
    );
  }
}
