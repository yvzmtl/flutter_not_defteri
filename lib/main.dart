import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/model/category.dart';
import 'package:flutter_not_defteri/model/note.dart';
import 'package:flutter_not_defteri/not_detay.dart';
import 'package:flutter_not_defteri/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteList(),
    );
  }
}

class NoteList extends StatelessWidget {
  DatabaseHelper db = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text("Not Listesi"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "KategoriEkle",
            child: Icon(
              Icons.category,
            ),
            mini: true,
            tooltip: "Kategori Ekle",
            onPressed: () {
              addCategoryDialog(context);
            },
          ),
          FloatingActionButton(
            heroTag: "NotEkle",
            child: Icon(Icons.add),
            tooltip: "Not Ekle",
            onPressed: () => _notDetaySayfasinaGit(context),
          ),
        ],
      ),
      body: Notes(),
    );
  }

  void addCategoryDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var newCategoryName;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yenideger) {
                      newCategoryName = yenideger;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (categoryName) {
                      if (categoryName.length < 3) {
                        return "En az 3 Karakter giriniz";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orange,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        db
                            .addCategory(Category(newCategoryName))
                            .then((categoryID) {
                          if (categoryID > 0) {
                            //debugPrint("Kategori eklendi : $categoryID");
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Kategori eklendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.blue,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  _notDetaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  title: "Yeni Not",
                )));
  }
}

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Note> notes;
  DatabaseHelper db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notes = List<Note>();
    db = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.getNoteList(),
      builder: (context, AsyncSnapshot<List<Note>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          notes = snapshot.data;
          sleep(Duration(milliseconds: 300));
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  leading: _oncelikIconAtama(notes[index].noteOncelik),
                  title: Text(notes[index].noteTitle),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Kategori",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  notes[index].categoryName,
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Oluşturulma Tarihi",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  db.dateFormat(
                                      DateTime.parse(notes[index].noteDate)),
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              notes[index].noteContent,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      _noteDelete(notes[index].noteID),
                                  child: Text(
                                    "SİL",
                                    style: TextStyle(color: Colors.redAccent),
                                  )),
                              FlatButton(
                                  onPressed: () {
                                    _notDetaySayfasinaGit(context, notes[index]);
                                  },
                                  child: Text(
                                    "GÜNCELLE",
                                    style:
                                        TextStyle(color: Colors.orangeAccent),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              });
        } else {
          return Center(child: Text("Yükleniyor..."));
        }
      },
    );
  }

  _notDetaySayfasinaGit(BuildContext context, Note note) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
              title: "Notu Düzenle",
              updatedNote : note,
            )));
  }

  _oncelikIconAtama(int noteOncelik) {
    switch (noteOncelik) {
      case 0:
        return CircleAvatar(
          child: Text(
            "AZ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade100,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text(
            "ORTA",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade400,
        );
        break;
      case 2:
        return CircleAvatar(
          child: Text(
            "ACİL",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade700,
        );
        break;
    }
  }

  _noteDelete(int noteID) {
    db.deleteNote(noteID).then((deletedID) {
      if (deletedID != 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Not Silindi"),
        ));
        setState(() {});
      }
    });
  }
}
