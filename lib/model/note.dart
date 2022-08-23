class Note{
  int _noteID;
  int _categoryID;
  String _noteTitle;
  String _categoryName;
  String _noteContent;
  String _noteDate;
  int _noteOncelik;

//  Note(this._categoryID, this._noteTitle, this._noteContent,this._noteOncelik);

  Note(this._categoryID, this._noteTitle, this._noteContent,this._noteDate, this._noteOncelik);

  Note.withID(this._noteID, this._categoryID, this._noteTitle, this._noteContent,
      this._noteDate, this._noteOncelik);

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['noteID'] = _noteID;
    map['categoryID'] = _categoryID;
    map['noteTitle'] = _noteTitle;
    map['noteContent'] = _noteContent;
    map['noteDate'] = _noteDate;
    map['noteOncelik'] = _noteOncelik;
    return map;
  }

  Note.fromMap(Map<String,dynamic> map){
    this._noteID = map['noteID'];
    this._categoryID = map['categoryID'];
    this._noteTitle = map['noteTitle'];
    this._noteContent = map['noteContent'];
    this._noteDate = map['noteDate'];
    this._noteOncelik = map['noteOncelik'];
    this._categoryName = map['categoryName'];
  }



  int get noteOncelik => _noteOncelik;

  set noteOncelik(int value) {
    _noteOncelik = value;
  }

  String get noteDate => _noteDate;

  set noteDate(String value) {
    _noteDate = value;
  }

  String get noteContent => _noteContent;

  set noteContent(String value) {
    _noteContent = value;
  }

  String get noteTitle => _noteTitle;

  set noteTitle(String value) {
    _noteTitle = value;
  }

  int get categoryID => _categoryID;

  set categoryID(int value) {
    _categoryID = value;
  }

  int get noteID => _noteID;

  set noteID(int value) {
    _noteID = value;
  }

  String get categoryName => _categoryName;

  set categoryName(String value) {
    _categoryName = value;
  }
}