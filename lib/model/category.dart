

class Category{
  int _categoryID;
  String _categoryName;

  Category.withID(this._categoryID, this._categoryName);

  Category(this._categoryName);

  String get categoryName => _categoryName;

  set categoryName(String value) {
    _categoryName = value;
  }

  int get categoryID => _categoryID;

  set categoryID(int value) {
    _categoryID = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['categoryID'] = _categoryID;
    map['categoryName'] = _categoryName;
    return map;
  }

  Category.fromMap(Map<String,dynamic> map){
    this._categoryID = map['categoryID'];
    this._categoryName = map['categoryName'];
  }

  @override
  String toString() {
    return 'Category{_categoryID: $_categoryID, _categoryName: $_categoryName}';
  }
}