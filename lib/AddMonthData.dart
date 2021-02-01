import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khata_app/HomeScreen.dart';

class MonthData extends StatefulWidget {

  final String TotalExpense,MonthName,Year,month;
  final int FeesAmount,MaintenanceAmount,RationAmount,EmiAmount,ShoppingAmount,EntertainmentAmount;
  const MonthData({Key key, this.TotalExpense, this.MonthName,
    this.Year,this.month,this.EmiAmount,this.EntertainmentAmount,this.FeesAmount,this.MaintenanceAmount,this.RationAmount,this.ShoppingAmount}) : super(key: key);

  @override
  _MonthDataState createState() => _MonthDataState();
}


class _MonthDataState extends State<MonthData> {

  final _key = GlobalKey<FormState>();
  int totalExpense;

  int FeesAmount,MaintenanceAmount,RationAmount,EmiAmount,ShoppingAmount,EntertainmentAmount;

  List<String> TypesOfExpenses =['Fees','Maintenance','Ration','EMI','Shopping','Entertainment'];

  String CurrentMonth;

  String CurrentExpense;
  int Amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    totalExpense = int.parse(widget.TotalExpense);
    FeesAmount = widget.FeesAmount;
    EntertainmentAmount = widget.EntertainmentAmount;
    ShoppingAmount = widget.ShoppingAmount;
    MaintenanceAmount = widget.MaintenanceAmount;
    RationAmount = widget.RationAmount;
    EmiAmount = widget.EmiAmount;
    return WillPopScope(
      onWillPop: (){},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Container(
            width: MediaQuery.of(context).size.width*0.6,
            child: Row(
              children: [
                AutoSizeText(widget.MonthName+", ",maxLines: 1,style: TextStyle(color: Colors.white),),
                AutoSizeText(widget.Year,maxLines: 1,style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurpleAccent,
                  elevation: 10,
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                ),
              ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: AutoSizeText(
                    'Total Expense',
                    textAlign: TextAlign.center,maxLines: 1,
                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 24),),
              ),
              SizedBox(height: 20,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Accounts").doc(widget.month + " " + widget.Year).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Container();
                    }
                  else if(snapshot.hasData)
                    {
                      DocumentSnapshot data = snapshot.data;
                      return Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: AutoSizeText(
                          '₹'+data.data()["TotalExpense"].toString(),
                          textAlign: TextAlign.center,maxLines: 1,
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 30),),
                      );
                    }
                  else{
                    return Container();
                  }
                },
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                        key: _key,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.6,
                              child: DropdownButton(
                                hint: CurrentExpense == null
                                    ? Text('Select Expense',style: TextStyle(color: Colors.deepPurple),)
                                    : Text(
                                  CurrentExpense,
                                  style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18),
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18),
                                items: TypesOfExpenses.map(
                                      (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                        () {
                                      CurrentExpense = val;
                                    },
                                  );
                                },
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width*0.6,
                              child: TextFormField(
                                autovalidate: true,
                                keyboardType: TextInputType.number,
                                onSaved: (value){
                                  setState(() {
                                    Amount = int.parse(value);
                                  });
                                },
                                style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18),
                                maxLines: 1,
                                onChanged: (value){
                                  setState(() {
                                    Amount = int.parse(value);
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty)
                                    {
                                      return "Please enter value";
                                    }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: TextStyle(color: Colors.deepPurple),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purpleAccent,
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                      width: 1,
                                    ),
                                  ),
                                  icon: Container(
                                    child: Text('₹',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 24),),
                                  ),
                                  labelText: 'Amount',
                                  labelStyle: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                      FlatButton(
                        onPressed: (){
                          if(_key.currentState.validate())
                            {
                              if(CurrentExpense == null)
                                {
                                    Fluttertoast.showToast(
                                        msg: 'Please choose expense Type',
                                        backgroundColor: Colors.deepPurple,
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER);
                                }
                              else{
                                {
                                  setState(() {
                                    totalExpense = totalExpense + Amount;
                                  });
                                  String docadd = widget.month + " " + widget.Year;
                                    switch(CurrentExpense)
                                    {
                                      case 'Fees': {
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).update({
                                          'Fees': FeesAmount + Amount,
                                          'TotalExpense': totalExpense,
                                        });
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).collection("Daily").add({
                                          "Expense Types": CurrentExpense,
                                          "Amount Spend": Amount,
                                        });
                                        break;
                                      }
                                      case 'EMI': {
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).update({
                                          'EMI': EmiAmount + Amount,
                                          'TotalExpense': totalExpense,
                                        });
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).collection("Daily").add({
                                          "Expense Types": CurrentExpense,
                                          "Amount Spend": Amount,
                                        });
                                        break;
                                      }
                                      case 'Ration': {
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).update({
                                          'Ration': RationAmount + Amount,
                                          'TotalExpense': totalExpense,
                                        });
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).collection("Daily").add({
                                          "Expense Types": CurrentExpense,
                                          "Amount Spend": Amount,
                                        });
                                        break;
                                      }
                                      case 'Entertainment': {
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).update({
                                          'Entertainment': EntertainmentAmount + Amount,
                                          'TotalExpense': totalExpense,
                                        });
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).collection("Daily").add({
                                          "Expense Types": CurrentExpense,
                                          "Amount Spend": Amount,
                                        });
                                        break;
                                      }
                                      case 'Shopping': {
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).update({
                                          'Shopping': ShoppingAmount + Amount,
                                          'TotalExpense': totalExpense,
                                        });
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).collection("Daily").add({
                                          "Expense Types": CurrentExpense,
                                          "Amount Spend": Amount,
                                        });
                                        break;
                                      }
                                      case 'Maintenance': {
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).update({
                                          'Maintenance': MaintenanceAmount + Amount,
                                          'TotalExpense': totalExpense,
                                        });
                                        FirebaseFirestore.instance.collection("Accounts").doc(docadd).collection("Daily").add({
                                          "Expense Types": CurrentExpense,
                                          "Amount Spend": Amount,
                                        });
                                        break;
                                      }
                                    }//end of switch
                                  Fluttertoast.showToast(
                                      msg: 'Amount Added',
                                      backgroundColor: Colors.deepPurple,
                                      textColor: Colors.white,
                                      toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER
                                  );
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                                }
                              }
                            }
                          else
                            {
                              Fluttertoast.showToast(
                                  msg: 'Please check details',
                                  backgroundColor: Colors.deepPurple,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER);
                            }
                        },
                        color: Colors.deepPurpleAccent,
                        child: Text('Add',style: TextStyle(color: Colors.white),),
                      ),
                ],),
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Accounts").doc(widget.month+" "+widget.Year).collection("Daily").snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasData)
                        {
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context,index){
                                DocumentSnapshot data = snapshot.data.docs[index];
                                return dailyTransaction(
                                  context,
                                  data.data()["Amount Spend"].toString(),
                                  data.data()["Expense Types"],
                                );
                              });
                        }
                      else
                        {
                          return Container();
                        }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  dailyTransaction(BuildContext context,String Amount,String Type){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.deepPurple,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Amount spend on: ' + Type,textAlign: TextAlign.left,style: TextStyle(color: Colors.deepPurple,fontSize: 20,fontWeight: FontWeight.bold),),
          Text('₹ ' + Amount.toString(),textAlign: TextAlign.left,style: TextStyle(color: Colors.deepPurple,fontSize: 20,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
  
}
