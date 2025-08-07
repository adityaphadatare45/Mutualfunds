import 'package:flutter/material.dart';

class Investmentdetails extends StatefulWidget{
  const Investmentdetails({super.key});

   
   @override
  State<StatefulWidget> createState() => _InvestmentPage();
}

 class _InvestmentPage extends State<Investmentdetails>{
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: const Text('Investment Details',
      style: TextStyle(
        fontSize: 24,

      ),
      ),
     ),
     body: Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
           
        )
        ),
      )
    );
  }
}