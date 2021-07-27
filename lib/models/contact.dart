class Contact{

  static const tableName = 'contacts';
   static const idColumn = 'id';
    static const nameColumn = 'name';
     static const numberColumn = 'number';

  int id ; 
  String name;
  String number;

  Contact({this.id , this.name , this.number});


  Contact.fromMap(Map<String , dynamic> map){
    id = map[idColumn];
    name = map[nameColumn];
    number = map[numberColumn];
  }


  Map<String , dynamic> toMap(){
    var map = <String,dynamic>{nameColumn:name , numberColumn:number};
      
      if(id != null){
        map[idColumn] = id;
      }
      return map;
  }


}