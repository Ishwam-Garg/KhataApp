import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateTodoPost extends StatefulWidget {
  final User user;
  CreateTodoPost(this.user);

  @override
  _CreateTodoPostState createState() => _CreateTodoPostState();
}

class _CreateTodoPostState extends State<CreateTodoPost> {

  String title = '';
  String content = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController _titlecontroller = TextEditingController(text: '');
  TextEditingController _contentcontroller = TextEditingController(text: '');


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
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String time = DateFormat('kk:mm').format(now);
    String date = DateFormat('d EEE, MMM').format(now);
    print(time);
    print(date);
    return WillPopScope(
      onWillPop: () async{

        _contentcontroller.clear();
        _titlecontroller.clear();
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
            onPressed: (){
              if(_formKey.currentState.validate()) {
                if (content.isNotEmpty) {
                  AddTodoPost(widget.user, title, content, time, date);
                  _titlecontroller.clear();
                  _contentcontroller.clear();
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
                      controller: _titlecontroller,
                      onSaved: (value){
                        title = value;
                      },
                      onChanged: (value){
                        title = value;
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
                        controller: _contentcontroller,
                        onSaved: (value){
                          content = value;
                        },
                        onChanged: (value){
                          content = value;
                        },
                        autofocus: true,
                        cursorColor: Colors.white60,
                        keyboardType: TextInputType.text,
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
