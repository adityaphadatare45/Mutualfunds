import 'package:flutter/material.dart';
import 'package:portfolio/screens/Welcomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pie_chart/pie_chart.dart';


class HomePage extends StatelessWidget {         // Home page class
    const HomePage({super.key});                   // Constructor


  final Map <String,double> dataMap = const{
   'Gold':40.31,
   'Mutual Funds':2.3,
   'SIP':4.5,
   'Cash':20.24,

  };

  final List<Color> colorList= const[
    Colors.blue,
    Colors.red,
    Colors.yellowAccent,
    Colors.green,
  ];

  // Logout function that clears login state and navigates to WelcomeScreen
  Future<void> logout(BuildContext context) async {  // Logout function
    final prefs = await SharedPreferences.getInstance(); // Get instance of SharedPreferences
    await prefs.setBool('isLoggedIn', false);  // Clear login state
    await prefs.setBool('isSignedIn', false);  // Clear sign-up state
    // Navigate to WelcomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {      // Build function
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashBoard'),
        backgroundColor: Colors.blue[50],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context); // Call logout function
            },
          ),
        ],
      ),
  /*        body: Padding();
      PieChart(
        dataMap: dataMap,
        animationDuration: Duration(microseconds: 1000),
        chartType: ChartType.ring,
        chartRadius: MediaQuery.of(context).size.width/3.2,
        chartLegendSpacing: 32,
        colorList: colorList,
        initialAngleInDegree: 0,
        ringStrokeWidth: 32,
        centerText: 'Center',
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          )
        ),
         chartValuesOptions: ChartValuesOptions(

         ),
      );*/
    );
  }
}
