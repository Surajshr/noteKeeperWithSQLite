import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:untitled/utils/database_helper.dart';
import 'package:untitled/models/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['Hight', 'Low'];
  //var _currentValueSelected = 'Low';
  DatabaseHelper helper = DatabaseHelper();
  String appBarTile;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTile);

  // @override
  // void initState() {
  //   super.initState();
  //   _currentValueSelected = _priority[0];
  // }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text =note.description;
    // return WillPopScope(
    //     //
    //     onWillPop: () async {
    //       moveToLastScreeb();
    //     },
    //    child:
    return Scaffold(
            appBar: AppBar(
              title: Text(appBarTile),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                },
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        style:textStyle,

                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updatePriorityAsInt(valueSelectedByUser);
                          });
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something Changed in title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something Changed in Description Text Field');
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                          ),
                          label: Text('Save'),
                          icon: Icon(Icons.save),
                          onPressed: () {
                            setState(() {
                              debugPrint('save button clicked');
                              _save();
                            });
                          },
                        )),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                            child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                          ),
                          label: Text('Deleter'),
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              debugPrint('delete button clicked');
                              _delete();
                            });
                          },
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  void moveToLastScreen() {
   // Navigator.of(context).pop();
    Navigator.pop(context,true);
  }

  //Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(var value){
    switch(value){
      case 'High':
        note.priority =1;
        break;
      case 'Low':
        note.priority =2;
        break;
    }
  }
  //Convert int priority to String priority and display it to user in Dropdown
  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _priorities[0]; //'High'
        break;
      case 2:
        priority =_priorities[1];//'Low'
        break;
    }
    return priority;
  }
  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }
  //Update the description of Note Object
  void updateDescription(){
    note.description = descriptionController.text;
  }
  // save data to database
  void _save()async {

    moveToLastScreen();
    note.date =DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) { //case 1 update operation
    result =  await helper.updateNote(note);
    }
    else{ //case 2 Insert operation
      result = await helper.insertNote(note);
    }
    if(result !=0){
      _showAlterDialog('Status','Note Saved Successfully');
    }else {
      _showAlterDialog('Status','Problem Saved Note');
    }
  }
  void _delete() async{

    moveToLastScreen();
    // Case 1 : If user is trying to delete the NEW NOTE
    // i.e. he has come to the detail page by pressing the FAB of NoteList page.
    if(note.id == null){
      _showAlterDialog('Status', 'No Note was deleted');
      return;
    }

    //Case 2 : User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if(result !=0){
      _showAlterDialog('Status', 'Note Deleted Successfully');

    }else{
      _showAlterDialog('Status', 'Error occurred while Deleting Note');
    }
  }
void _showAlterDialog(String title,String message){
    AlertDialog alertDialog = AlertDialog(
      title:Text(title),
      content:Text(message),
    );
    showDialog(
      context: context,
      builder: (_)=> alertDialog
    );
}

}
