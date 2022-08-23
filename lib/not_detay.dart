import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/model/category.dart';
import 'package:flutter_not_defteri/model/note.dart';
import 'package:flutter_not_defteri/utils/database_helper.dart';

import 'model/category.dart';

class NotDetay extends StatefulWidget {
  String title;
  Note updatedNote;

  NotDetay({this.title, this.updatedNote});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  List<Category> allCategories;
  DatabaseHelper db;
  int categoryID ;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];
  int secilenOncelik;
  String noteTitle, noteContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCategories = List<Category>();
    db = DatabaseHelper();
    db.getCategories().then((values) {
      for (Map okunanMap in values) {
        allCategories.add(Category.fromMap(okunanMap));
      }

      if(widget.updatedNote != null){
        categoryID = widget.updatedNote.categoryID;
        secilenOncelik = widget.updatedNote.noteOncelik;
      }else{
        categoryID = 1;
        secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: allCategories.length <= 0 ? Center(
        child: CircularProgressIndicator(),) :
      Container(
        child: Form(
          key: formKey,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Kategori :", style: TextStyle(fontSize: 24,),),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        items: createCategoryItems(),
                        value: categoryID,
                        onChanged: (selectedCategoryID) {
                          setState(() {
                            categoryID = selectedCategoryID;
                          });
                        }),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.updatedNote != null ? widget.updatedNote
                    .noteTitle : "",
                validator: (text) {
                  if (text.length < 2) {
                    return "2 karakterden az olamaz";
                  }
                },
                onSaved: (text) {
                  noteTitle = text;
                },
                decoration: InputDecoration(
                  hintText: "Not Başlığı giriniz",
                  labelText: "Başlık",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.updatedNote != null ? widget.updatedNote
                    .noteContent : "",
                onSaved: (text) {
                  noteContent = text;
                },
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Not giriniz",
                  labelText: "İçerik",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Öncelik :", style: TextStyle(fontSize: 24,),),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                        items: _oncelik.map((oncelik) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              oncelik, style: TextStyle(fontSize: 24),),
                            value: _oncelik.indexOf(oncelik),
                          );
                        }).toList(),
                        value: secilenOncelik,
                        onChanged: (secilenOncelikID) {
                          setState(() {
                            secilenOncelik = secilenOncelikID;
                          });
                        }),
                  ),
                ),
              ],
            ),

            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("Vazgeç"), color: Colors.redAccent.shade200,),
                RaisedButton(onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    var now = DateTime.now();
                    if (widget.updatedNote == null) {
                      db.addNote(Note(
                          categoryID, noteTitle, noteContent, now.toString(),
                          secilenOncelik)).then((kaydedilenID) =>
                      {

                        if(kaydedilenID != 0){
                          Navigator.pop(context)
                        }
                      });
                    }
                    else {
                      db.updateNote(Note.withID(
                          widget.updatedNote.noteID, categoryID, noteTitle,
                          noteContent, now.toString(), secilenOncelik)).then((updatedID){
                        if(updatedID != 0){
                          Navigator.pop(context);
                        }
                      } );
                    }
                  }
                },
                    child: Text(
                      "kaydet", style: TextStyle(color: Colors.white),),
                    color: Colors.lightBlue),
              ],
            )
          ],),),
      ),
    );
  }

  List<DropdownMenuItem<int>> createCategoryItems() {
    List<DropdownMenuItem<int>> categories = [];

    return allCategories
        .map((category) =>
        DropdownMenuItem<int>(
          value: category.categoryID,
          child: Text(category.categoryName, style: TextStyle(fontSize: 24),),
        ))
        .toList();
  }
}

// Form(
//        key: formKey,
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            Center(
//              child: DropdownButtonHideUnderline(child: allCategories.length <= 0
//                  ? CircularProgressIndicator()
//                  : Container(
//                padding: EdgeInsets.symmetric(vertical: 4,horizontal: 30),
//                margin: EdgeInsets.all(12),
//                decoration: BoxDecoration(
//                  border: Border.all(color: Colors.lightBlue,width: 2),
//                  borderRadius: BorderRadius.all(Radius.circular(10)),
//                ),
//                child: DropdownButton<int>(
//                    items: createCategoryItems(),
//                    value: categoryID,
//                    onChanged: (selectedCategoryID) {
//                      setState(() {
//                        categoryID = selectedCategoryID;
//                      });
//                    }),
//              ),)
//            ),
//          ],
//        ),
//      ),
