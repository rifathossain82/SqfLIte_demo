import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/notes_database.dart';
import '../model/note.dart';
import 'edit_NotePage.dart';

class NoteDetailsPage extends StatefulWidget {
  late final int noteId;


  NoteDetailsPage(this.noteId);

  @override
  _NoteDetailsPageState createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {

  late Note note;
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshNote();
  }

  Future refreshNote()async{
    setState(() {
      isLoading=true;
    });

    this.note=await NotesDatabase.instance.readNote(widget.noteId);

    setState(() {
      isLoading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editButton(),
          deleteButton()
        ],
      ),
      body: isLoading?
      Center(child: CircularProgressIndicator(),):
      Padding(
          padding: EdgeInsets.all(12),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          children: [
            Text(note.title,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Text(DateFormat.yMMMd().format(note.createdTime),style: TextStyle(color: Colors.white38),),
            SizedBox(height: 8,),
            Text(note.description,style: TextStyle(color: Colors.white70),)
          ],
        ),
      ),
    );
  }
  Widget deleteButton(){
    return IconButton(
        onPressed: ()async{
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
        icon: Icon(Icons.delete));
  }

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note,),
        ));

        refreshNote();
      });
}
