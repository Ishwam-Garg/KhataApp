import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateTodoPost extends StatefulWidget {
  final String timestamp;
  final String title,content;
  final bool isEditing;
  final User user;
  CreateTodoPost(this.user,this.title,this.content,this.isEditing,this.timestamp);

  @override
  _CreateTodoPostState createState() => _CreateTodoPostState();
}

class _CreateTodoPostState extends State<CreateTodoPost> {

  String title = '';
  String content = '';

  final _formKey = GlobalKey<FormState>();

  /*
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _contentcontroller = TextEditingController()
   */


  UpdateTodoPost(User user,String title,String des,String time,String date,String timestamp) async {

    Map<String,String> Data = {
      'Title' : title,
      'description': des,
      'date': date,
      'time': time,
      'timestamp': Timestamp.now().toString(),
    };

    QuerySnapshot snap = await FirebaseFirestore.instance.collection("Users").doc(user.email).collection('Todo').where('timestamp',isEqualTo: timestamp).get();

    DocumentSnapshot ds = snap.docs[0];

    String docId = await ds.reference.id;

    FirebaseFirestore.instance.collection("Users").doc(user.email).collection('Todo').doc(docId).update(Data);

  }

  AddTodoPost(User user,String title,String description,String time,String date) async{

    Map<String,String> Data = {
      'Title' : title,
      'description': description,
      'date': date,
      'time': time,
      'timestamp': Timestamp.now().toString(),
    };

    FirebaseFirestore.instance.collection("Users").doc(user.email).collection('Todo').add(Data);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    content = widget.content;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String time = DateFormat('kk:mm').format(now);
    String date = DateFormat('d EEE, MMM').format(now);
    return WillPopScope(
      onWillPop: () async{
        //_contentcontroller.clear();
        //_titlecontroller.clear();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade300,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Create',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: !widget.isEditing ? (){
              if(_formKey.currentState.validate()) {
                if (content.length > 0) {
                  AddTodoPost(widget.user, title, content, time, date);
                  //_titlecontroller.clear();
                  //_contentcontroller.clear();
                  Navigator.pop(context);
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Content cannot be empty'),
                  ));
                }
              }
              else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error fill details properly'),
                ));
              }
            } : (){
              if(_formKey.currentState.validate()) {
                if (content.isNotEmpty) {
                  UpdateTodoPost(widget.user, title, content, time, date, widget.timestamp);
                  //_titlecontroller.clear();
                  //_contentcontroller.clear();
                  Navigator.pop(context);
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Content cannot be empty'),
                  ));
                }
              }
              else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error fill details properly'),
                ));
              }
            },
            backgroundColor: Colors.deepPurple.shade400,
            label: Text('Save',style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.upload_sharp,color: Colors.white,),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height-80,
          width: MediaQuery.of(context).size.width,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    margin: EdgeInsets.only(top: 15,left: 15,right: 15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade500,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      //controller: _titlecontroller,
                      initialValue: widget.title,
                      onSaved: (value){
                        //_formKey.currentState.save();
                        title = value;
                        //_titlecontroller.text = value;
                      },
                      onChanged: (value){
                        title = value;
                        //_titlecontroller.text = value;
                      },
                      cursorColor: Colors.white60,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                       alignLabelWithHint: true,
                        enabled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold),
                        counterStyle: TextStyle(color: Colors.white60),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.white60
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                          width: 2,
                          color: Colors.white60
                      ),
          ),
                      ),
                      maxLength: 120,
                      style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                  //content
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade500,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        //controller: _contentcontroller,
                        initialValue: widget.content,
                        maxLines: null,
                        onSaved: (value){
                          content = value;
                          print(content);
                        },
                        onChanged: (value){
                          content = value;
                          print(content);
                        },
                        autofocus: true,
                        cursorColor: Colors.white60,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          enabled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16,color: Colors.white60,fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )),
        )
      ),
    );
  }
}
