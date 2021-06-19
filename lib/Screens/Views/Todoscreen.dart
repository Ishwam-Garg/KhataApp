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
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>CreateTodoPost(widget.user,'','',false,'')));
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

                    String docId = data.id;
                    return TodoTile(
                        context,
                        widget.user,
                        data.data()["description"],
                        data.data()["Title"],
                        data.data()["time"],
                        data.data()["date"],
                        data.data()["timestamp"].toString(),
                        docId
                    );
                  });
            }
          else
            return Container();
        },
      ),
    );
  }

  Widget TodoTile(BuildContext context,User user,String content,String title,String time,String date,String timestamp,String id){
    return GestureDetector(
      onLongPress: (){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text('Action',style: TextStyle(color: Colors.white70),),
            backgroundColor: Colors.deepPurple.shade300,
            content: Text('You are about to delete this post',style: TextStyle(color: Colors.white60),),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Discard',style: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold),))),
                    GestureDetector(
                        onTap: (){
                          FirebaseFirestore.instance.collection("Users").doc(user.email).collection('Todo').doc(id).delete();
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.red.shade800,
                                  width: 1
                              ),
                            ),
                            child: Text('Delete',style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.bold),))),
                  ],
                ),
              ),
            ],
          );
        }
        );
      },
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>CreateTodoPost(widget.user, title, content,true,timestamp)));
      },
      child: Container(
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
      ),
    );
  }



}

