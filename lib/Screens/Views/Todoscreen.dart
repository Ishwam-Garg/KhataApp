import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khata_app/Screens/Views/CreateTodoPost.dart';

class TodoScreen extends StatefulWidget {
  final User user;
  TodoScreen(this.user);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  ScrollController _scrollController = ScrollController();


  Stream<QuerySnapshot> getTodoData(User user) {

    Stream<QuerySnapshot> snapshot;

    snapshot = FirebaseFirestore.instance.collection("Users").doc(user.email).collection('Todo').orderBy('timestamp',descending: true).snapshots();

    return snapshot;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>CreateTodoPost(widget.user)));
        },
      ),
      body: StreamBuilder(
        stream: getTodoData(widget.user),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Container();
            }
          else if(snapshot.hasData)
            {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return TodoTile(
                        context,
                        data.data()["description"],
                        data.data()["Title"],
                        data.data()["time"],
                        data.data()["date"]
                    );
                  });
            }
          else
            return Container();
        },
      ),
    );
  }

  Widget TodoTile(BuildContext context,String content,String title,String time,String date){
    return Container(
      margin: EdgeInsets.only(top: 15,left: 15,right: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.purple.shade400,
      ),
      child: Stack(
        children: [
          Positioned(
            child: Text(
              date,
              style: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold),
            ),
            left: 25,bottom: 10,),
          Positioned(
            child: Text(
              time,
              style: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold),
            ),
            right: 15,bottom: 10,),
          Padding(
            padding: EdgeInsets.only(left: 25,right: 25,top: 25,bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //title
                Text(title,style: TextStyle(
                  color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold,
                ),
                  maxLines: 1,overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 15,),
                Text(content,
                  style: TextStyle(fontSize: 14,color: Colors.white70,fontWeight: FontWeight.bold),
                  maxLines: 10,overflow: TextOverflow.ellipsis,)
              ],
            ),
          ),
        ],
      ),
    );
  }



}

