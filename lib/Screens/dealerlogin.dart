import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ledgerapp/Screens/DealerScreen.dart';
class ListItem{
  int value;
  String name;
  ListItem(this.value,this.name);
}
class DealerLogin extends StatefulWidget {
  static String tag = 'dealerlogin-page';
  @override
  _DealerLoginState createState() => _DealerLoginState();
}

class _DealerLoginState extends State<DealerLogin> {
  TextEditingController emailC = new TextEditingController(text: '');
  TextEditingController pw = new TextEditingController(text: '');
  List<ListItem>_dropdownItems=[
    ListItem(1,"Division Head 1"),
    ListItem(2,"Division Head 2"),
    ListItem(3,"Division Head 3"),
  ];
  List<DropdownMenuItem<ListItem>>_dropdownMenuItems;
  ListItem _selectedItem;
  void initState(){
    super.initState();
    _dropdownMenuItems=buildDropDownMenuItems(_dropdownItems);

  }
  List<DropdownMenuItem<ListItem>>buildDropDownMenuItems(List listItems){
    List<DropdownMenuItem<ListItem>>items=List();
    for(ListItem listItem in listItems){
      items.add(DropdownMenuItem(child:Text(listItem.name),
      value:listItem,));
    }
    return items;
  }
  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
    final password = TextFormField(
      controller: pw,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
       if(_selectedItem=='Division Head 1'){
         final db = FirebaseDatabase.instance.reference().child("Division Head 1").child("Dealers");
         db.once().then((DataSnapshot snapshot){
           snapshot.value.foreach((key,values)
           {
             print(values['Email']);
             print(email.toString());
             if(values["Email"] == emailC.text &&
                 values["Password"] == pw.text){
               Navigator.of(context).pushNamed(dealerScreen.tag);
             }

           });
         }
         );
       }
       if(_selectedItem=='Division Head 2'){
         final db = FirebaseDatabase.instance.reference().child("Division Head 2").child("Dealers");
         db.once().then((DataSnapshot snapshot){
           snapshot.value.foreach((key,values)
           {
             print(values['Email']);
             print(email.toString());
             if(values["Email"] == emailC.text &&
                 values["Password"] == pw.text){
               Navigator.of(context).pushNamed(dealerScreen.tag);
             }

           });
         }
         );
       }
       if(_selectedItem=='Division Head 3'){
         final db = FirebaseDatabase.instance.reference().child("Division Head 3").child("Dealers");
         db.once().then((DataSnapshot snapshot){
           snapshot.value.foreach((key,values)
           {
             print(values['Email']);
             print(email.toString());
             if(values["Email"] == emailC.text &&
                 values["Password"] == pw.text){
               Navigator.of(context).pushNamed(dealerScreen.tag);
             }

           });
         }
         );
       }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
           Container(padding:EdgeInsets.all(12.0),
           child:DropdownButtonHideUnderline(
             child: DropdownButton<ListItem>(
               value:_selectedItem,
               items:_dropdownMenuItems,
               onChanged: (value){
                 setState(() {
                   _selectedItem=value;
                 });
                 },
               isExpanded: true,
               hint:Text('Choose your division head')
             ),
           )),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }

}
