import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Amount extends StatefulWidget {
  final String month,year;

  const Amount({Key key, this.month, this.year}) : super(key: key);
  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  int totalExpenditure;
  Future getTotalExpenditure() async{
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("Accounts").doc(widget.month + " " + widget.year).get();
      setState(() {
        totalExpenditure = ds.data()["TotalExpense"];
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalExpenditure().whenComplete((){
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.width*0.2,
            child: Material(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              child: Icon(Icons.arrow_back_ios,color: Colors.white,),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(totalExpenditure == null ? "Not yet got": totalExpenditure.toString(), style: TextStyle(color: Colors.black),),
      ),
    );
  }
}
