import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:khata_app/AddMonthData.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String month,year;
  String monthName;
  Future<bool> IsDataExist() async{
    DocumentSnapshot qn = await FirebaseFirestore.instance.collection("Accounts").doc(month + " "+year).get();
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
    };

    FirebaseFirestore.instance.collection("Accounts").doc(month +" "+year).set(monthData);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        print("DATA Exists");
      }
      else
      {
        CreateMonthData();
        print("Creating");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        color: Colors.deepPurpleAccent.withOpacity(0),
        height: 60,
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Khata App',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Accounts").snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Container();
              }
            else if(snapshot.hasData)
              {
                return ListView.builder(
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
                      );
                    });
              }
            else if(snapshot.hasError)
              {
                print(snapshot.error);
              }
            return Container();
          }),
    );
  }

  MonthlyCard(BuildContext context,String month,String year,String expense,String monthnumber,
      int emi,int entertainment,int fees,int maintenance,int ration,int shopping){
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
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: AutoSizeText('$month'+',',textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.orange),maxLines: 1,)),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: AutoSizeText('$year',textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.deepOrange),maxLines: 1,)),
                  ],
                ),
                SizedBox(height: 10,),
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
