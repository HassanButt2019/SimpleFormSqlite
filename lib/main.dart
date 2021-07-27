import 'package:flutter/material.dart';
import 'package:sqlite_crud/models/contact.dart';
import 'package:sqlite_crud/utils/database_helper.dart';

void main() {
  runApp(ContactUs());
}


class ContactUs extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
               debugShowCheckedModeBanner: false,
           theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      home: HOMEPAGE(),
    );
  }
}

class HOMEPAGE extends StatefulWidget {

  @override
  _HOMEPAGEState createState() => _HOMEPAGEState();
}

class _HOMEPAGEState extends State<HOMEPAGE> {
  List<Contact> _contacts = [];
  final _formkey = GlobalKey<FormState>();
  Contact contact = Contact();
   DatabaseHelper dbHelper;

   TextEditingController name = TextEditingController();
   TextEditingController number = TextEditingController();

@override
  void initState() {
    super.initState();
    setState(() {
       dbHelper = DatabaseHelper.instance;
    });
  //  if(_contacts.length!=0)
    _refreshList();

  }

  _refreshList() async{
    List<Contact> x = await dbHelper.fetchContacts();

    setState(() {
      _contacts = x ;
    });
  }

     _resetForm(){
      setState(() {
        _formkey.currentState.reset();
        name.clear();
        number.clear();
        contact.id = null;
      });
    }

  _onSubmit()async{
    var form  = _formkey.currentState;
    
    if(form.validate())
    {
     form.save();

     if(contact.id == null) await dbHelper.insertContact(contact);
     else await dbHelper.updateContact(contact);
     
     _refreshList();
    _resetForm();
    
    }

    

    

     

  }

_form() =>Container(
  color: Colors.white,
  padding: EdgeInsets.symmetric(vertical:15 , horizontal:30),
  child: Form(
    key: _formkey,
    child: Column(children: [
      TextFormField(
        controller: name,
        validator: (val)=>(val.length==0?"This Field Is Required":null),
        onSaved: (val){
          setState(() {
            contact.name = val;
          });
        },
        decoration: InputDecoration(labelText: "Full Name"),
      ),
      TextFormField(
        controller: number,
        validator: (val)=>(val.length<10?"Atleast 10 characters required":null),

        onSaved: (val){
          setState(() {
            contact.number = val;
          });
        },
      decoration: InputDecoration(labelText: "Mobile"),
      ),
      Container(
        margin: EdgeInsets.all(10.9),
        child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SizedBox(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    
                    onPressed:_onSubmit,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ),
              ),
            )
  

      ),
    ],),
  ),
);

_list() =>Expanded(
  child:Card(
    margin:EdgeInsets.fromLTRB(20, 30, 20, 0),
    child: ListView.builder(
      padding:EdgeInsets.all(10),
      
      itemCount: _contacts.length,
      itemBuilder: (context , index){
        return _contacts.length==0?Container: Column(
          children: [
            ListTile(
              trailing: IconButton(
                onPressed: () async{
                  await dbHelper.deleteContact(_contacts[index].id);
                  _resetForm();
                  
                  _refreshList();

                },
                icon: Icon(Icons.delete_sweep , color: Colors.blue),
              ),
              leading: Icon(Icons.account_circle ,color: Colors.blue,),
            title: Text(_contacts[index].name.toUpperCase() , style: TextStyle(color:Colors.blue , fontWeight: FontWeight.bold),),
            subtitle: Text(_contacts[index].number ),
            onTap: (){
              setState(() {
                contact = _contacts[index];
                name.text = contact.name;
                number.text = contact.number;
                print(contact.name);
              });
            },

            ),
            Divider(height:5.0)
          ],
        );

      }
      
      ),
  )
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("SqlLite Crud"),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _form(),
              _list()


            ],
          ),
          
          ),
      );

  }
}

