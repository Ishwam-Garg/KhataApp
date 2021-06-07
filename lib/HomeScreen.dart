import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/AddMonthData.dart';
import 'package:khata_app/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khata_app/Services/Auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _controller = ScrollController();
  User user = FirebaseAuth.instance.currentUser;
  String month,year;
  String monthName;
  Future<bool> IsDataExist() async{
    DocumentSnapshot qn = await FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(month + " "+year).get();
      return qn.exists;
  }

  CreateMonthData() {

    Map<String,dynamic> monthData = {
      "monthName": monthName,
      "year": year,
      "month": month,
      "TotalExpense": 0,
      'Fees': 0,
      'Maintenance': 0,
      'Ration': 0,
      'EMI': 0,
      'Shopping': 0,
      'Entertainment': 0,
      'Medical Expense': 0,
      'timestamp': Timestamp.now(),
    };

    FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(month +" "+year).set(monthData);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(_controller.hasClients)
      {
        _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeIn);
      }
    var now = new DateTime.now();
    month = DateFormat('MM').format(now).toString();
    year = DateFormat('yyyy').format(now).toString();

    switch(month){
      case '01':{
        setState(() {
          monthName = "January";
        });
        break;
      }
      case '02':{
        setState(() {
          monthName = "February";
        });
      break;
    }
    case '03':{
      setState(() {
        monthName = "March";
      });
      break;
    }
    case '04':{
      setState(() {
        monthName = "April";
      });
      break;
    }
    case '05':{
      setState(() {
        monthName = "May";
      });
      break;
    }
    case '06':{
      setState(() {
        monthName = "June";
      });
      break;
    }
    case '07':{
      setState(() {
        monthName = "July";
      });
      break;
    }
      case '08':{
        setState(() {
          monthName = "August";
        });
        break;
      }
      case '09':{
        setState(() {
          monthName = "September";
        });
        break;
      }
      case '10':{
        setState(() {
          monthName = "October";
        });
        break;
      }
      case '11':{
        setState(() {
          monthName = "November";
        });
        break;
      }
      case '12':{
        setState(() {
          monthName = "December";
        });
        break;
      }
    }//switch

    IsDataExist().then((value){
      if(value)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loading',style: TextStyle(color: Colors.blue.shade600,fontWeight: FontWeight.bold,fontSize: 16),),
                Text('We are loading your monthly records ...',style: TextStyle(color: Colors.white70),)
              ]),
          duration: Duration(seconds: 3),
        ));
        print("DATA Exists");
      }
      else
      {
        CreateMonthData();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Creating',style: TextStyle(color: Colors.green.shade500,fontWeight: FontWeight.bold,fontSize: 16),),
                Text('We are creating your monthly records ...',style: TextStyle(color: Colors.white70),)
              ]),
          duration: Duration(seconds: 3),
        ));
        print("Creating");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
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
        backgroundColor: Colors.deepPurple.shade300,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").orderBy('timestamp',descending: true).snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
                {
                  return Center(
                      child: Container(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6),
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            Text('We are creating this months record',overflow: TextOverflow.clip,
                              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ));
                }
              else if(snapshot.hasData)
                {
                  return ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context,index){
                        DocumentSnapshot data = snapshot.data.docs[index];
                        return MonthlyCard(
                            context,
                            data.data()["monthName"],
                            data.data()["year"],
                            data.data()["TotalExpense"].toString(),
                            data.data()["month"],
                            data.data()["EMI"],
                            data.data()["Entertainment"],
                            data.data()["Fees"],
                            data.data()["Maintenance"],
                            data.data()["Ration"],
                            data.data()["Shopping"],
                            user,
                        );
                      });
                }
              else if(snapshot.hasError)
                {
                  print(snapshot.error);
                }
              return Container();
            }),
      ),
    );
  }

  MonthlyCard(BuildContext context,String month,String year,String expense,String monthnumber,
      int emi,int entertainment,int fees,int maintenance,int ration,int shopping,User user){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            MonthData(
              TotalExpense: expense,Year: year,MonthName: month,month: monthnumber,
              EmiAmount: emi,
              EntertainmentAmount: entertainment,
              FeesAmount: fees,
              MaintenanceAmount: maintenance,
              RationAmount: ration,
              ShoppingAmount: shopping,
              User: user,
            ),
        ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20),
        child: Material(
          color: Colors.white,
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.width*0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: AutoSizeText('$month'+' '+'$year',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.orange),maxLines: 1,)),
                Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Center(child: AutoSizeText('Total Expense',maxLines: 1,
                      style: TextStyle(color: Colors.redAccent,fontSize: 24,fontWeight: FontWeight.bold),),)),
                Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Center(
                      child: AutoSizeText('₹' + '  ' +'$expense',maxLines: 1,
                        style: TextStyle(color: Colors.redAccent,fontSize: 32,fontWeight: FontWeight.bold),),)),
                Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: AutoSizeText('Click to view Details',textAlign: TextAlign.center,maxLines: 1,)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
