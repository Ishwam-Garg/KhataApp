import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khata_app/HomeScreen.dart';
import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonthData extends StatefulWidget {

  final User;
  final String TotalExpense,MonthName,Year,month;
  final int FeesAmount,MaintenanceAmount,RationAmount,EmiAmount,ShoppingAmount,EntertainmentAmount;
  const MonthData({Key key, this.TotalExpense, this.MonthName,
    this.Year,this.month,this.EmiAmount,this.EntertainmentAmount,this.FeesAmount,
    this.MaintenanceAmount,this.RationAmount,this.ShoppingAmount,this.User}) : super(key: key);

  @override
  _MonthDataState createState() => _MonthDataState();
}


class _MonthDataState extends State<MonthData> {

  String Date;
  User user;
  final _key = GlobalKey<FormState>();
  TextEditingController _textcontrollerAmount = TextEditingController();
  TextEditingController _textcontrollerDescription = TextEditingController();
  int totalExpense;

  int FeesAmount,MaintenanceAmount,RationAmount,EmiAmount,ShoppingAmount,EntertainmentAmount,MedicalExpenseAmount;

  List<String> TypesOfExpenses =['Fees','Maintenance','Ration','EMI','Shopping','Entertainment','Medical'];

  String OngoingMonth,OnGoingYear;

  String CurrentExpense,Description;
  int Amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var dateformat = DateFormat('dd-MM-yyyy');
    Date = dateformat.format(now).toString();
    OngoingMonth = DateFormat('MM').format(now).toString();
    OnGoingYear = DateFormat('yyyy').format(now).toString();
    user = widget.User;

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
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurpleAccent,
                    elevation: 10,
                    child: Center(child: Icon(Icons.arrow_back,color: Colors.white,)),
                  ),
                ),
              ),
          ),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: AutoSizeText(
                    'Total Expense',
                    textAlign: TextAlign.center,maxLines: 1,
                    style: TextStyle(color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold,fontSize: 18),),
              ),
              SizedBox(height: 10,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(widget.month + " " + widget.Year).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Container();
                    }
                  else if(snapshot.hasData)
                    {
                      DocumentSnapshot data = snapshot.data;
                      totalExpense = data.data()["TotalExpense"];
                      FeesAmount = data.data()["Fees"];
                      EntertainmentAmount = data.data()["Entertainment"];
                      ShoppingAmount = data.data()["Shopping"];
                      MaintenanceAmount = data.data()["Maintenance"];
                      RationAmount = data.data()["Ration"];
                      EmiAmount = data.data()["EMI"];
                      MedicalExpenseAmount = data.data()['Medical Expense'];
                      return Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            AutoSizeText(
                              '₹ '+data.data()["TotalExpense"].toString(),
                              textAlign: TextAlign.center,maxLines: 1,
                              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: AutoSizeText(
                                    'EMI: ₹'+data.data()["EMI"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: AutoSizeText(
                                    'Fees: ₹'+data.data()["Fees"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: AutoSizeText(
                                    'Medical: ₹'+data.data()["Medical Expense"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: AutoSizeText(
                                    'Ration: ₹'+data.data()["Ration"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: AutoSizeText(
                                    'Maintenance: ₹'+data.data()["Maintenance"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: AutoSizeText(
                                    'Shopping: ₹'+data.data()["Shopping"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: AutoSizeText(
                                'Entertainment: ₹'+data.data()["Entertainment"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  else{
                    return Container();
                  }
                },
              ),
              //add amount
              addAmountBox(),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transactions',style: TextStyle(fontSize: 16,color: Colors.grey.shade700),),
                    GestureDetector(
                        onTap: (){},
                        child: Container(child: Text('See all',style: TextStyle(color: Colors.grey.shade100),))),
                  ],
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").doc(user.email).
                collection("Accounts").doc(widget.month+" "+widget.Year).
                collection("Transactions").orderBy('CreatedAt',descending: true).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData)
                  {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context,index){
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return dailyTransaction(
                            context,
                            data.data()["Amount Spend"].toString(),
                            data.data()["Expense Types"],
                            data.data()["Date"],
                            data.data()["Description"],
                          );
                        });
                  }
                  else
                  {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addAmountBox(){
    if((OngoingMonth == widget.month) && (OnGoingYear == widget.Year))
      {
        return Container(
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
                            ? Text('Select Expense',style: TextStyle(color: Colors.deepPurple,fontSize: 14),)
                            : Text(
                          CurrentExpense,
                          style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 14),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 14),
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
                    //Select Amount field
                    Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: TextFormField(
                        controller: _textcontrollerAmount,
                        autovalidate: false,
                        keyboardType: TextInputType.number,
                        onSaved: (value){
                          Amount = int.parse(value);
                        },
                        style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18),
                        maxLines: 1,
                        onChanged: (value){
                          Amount = int.parse(value);
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
                          labelText: '₹ Amount',
                          labelStyle: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: TextFormField(
                        controller: _textcontrollerDescription,
                        autovalidate: false,
                        keyboardType: TextInputType.text,
                        maxLength: null,
                        onSaved: (value){
                          Description = value;
                        },
                        style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18),
                        maxLines: 1,
                        onChanged: (value){
                          Description = value;
                        },
                        validator: (value) {
                          if (value.isEmpty)
                          {
                            return "Please enter description";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '',
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
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16),
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
                    else {
                      {
                        setState(() {
                          totalExpense = totalExpense + Amount;
                        });
                        String docadd = widget.month + " " + widget.Year;
                        switch(CurrentExpense)
                        {
                          case 'Fees': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'Fees': FeesAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
                            });
                            break;
                          }
                          case 'EMI': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'EMI': EmiAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
                            });
                            break;
                          }
                          case 'Ration': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'Ration': RationAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
                            });
                            break;
                          }
                          case 'Entertainment': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'Entertainment': EntertainmentAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
                            });
                            break;
                          }
                          case 'Shopping': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'Shopping': ShoppingAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
                            });
                            break;
                          }
                          case 'Maintenance': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'Maintenance': MaintenanceAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
                            });
                            break;
                          }
                          case 'Medical': {
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).update({
                              'Medical Expense': MedicalExpenseAmount + Amount,
                              'TotalExpense': totalExpense,
                            });
                            FirebaseFirestore.instance.collection("Users").doc(user.email).collection("Accounts").doc(docadd).collection("Transactions").add({
                              "Expense Types": CurrentExpense,
                              "Amount Spend": Amount,
                              'Description': Description,
                              'Date': Date,
                              'CreatedAt': Timestamp.now().toString(),
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
                        _textcontrollerAmount.clear();
                        _textcontrollerDescription.clear();
                        print("$CurrentExpense");
                        print("$Amount");
                        print("$Description");
                        setState(() {
                          CurrentExpense = null;
                          Amount = null;
                          Description = null;
                        });
                        //Navigator.pop(context);
                      }
                    }
                  }
                  else
                  {
                    Fluttertoast.showToast(
                        msg: 'Missing details',
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER);
                  }
                },
                color: Colors.deepPurpleAccent,
                child: Text('ADD',style: TextStyle(color: Colors.white),),
              ),
            ],),
        );
      }
    else
      return Container();
  }

  dailyTransaction(BuildContext context,String amount,String type,String date,String description){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.deepPurple,
            width: 0.5,
          ),
          top: BorderSide(
            color: Colors.deepPurple,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(alignment: Alignment.centerRight,
              child: Text(
                date,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.bold),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type,textAlign: TextAlign.left,style: TextStyle(color: Color(0xff006400),fontSize: 18,fontWeight: FontWeight.bold),),
                  Container(
                      width: MediaQuery.of(context).size.width*0.50,
                      child: Text(
                        description,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                  ),
                ],
              ),
              Text('₹ '+amount,textAlign: TextAlign.left,style: TextStyle(color: Colors.red,fontSize: 24,fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      ),
    );
  }
  
}
