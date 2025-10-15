import 'package:flutter/material.dart';
import 'package:provider_test/features/core/utils/constants/app_color.dart';
import 'package:provider_test/features/home/pages/home_page.dart';
import 'package:provider_test/features/home/pages/setting_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> widgetList=[HomePage(),SettingPage()];
  int index=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: widgetList[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (value){
          setState(() {
            index=value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
        
        

      ]),
    );
  }
}