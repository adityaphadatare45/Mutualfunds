import 'package:flutter/material.dart';

class Personaldetails extends StatefulWidget{
  const Personaldetails({super.key});

  @override
  State<StatefulWidget> createState()=> _PersonaldetailsPage();
}

class _PersonaldetailsPage extends State<Personaldetails>{
   final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 48, 128, 194),
       title: const Text(
        'Personal Details', 
        style: TextStyle(
          fontSize: 24,
          //fontStyle: 
        ),
       ),
     ),
     body:Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key:_formKey,
        child: ListView(
         children: [
          
         ], 
        )
      ), 
     )
    );
  }
}