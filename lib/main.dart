import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/dashboard/presentation/dashboard.dart';
import 'package:provider_test/features/assignment/pages/assigned_page.dart';
import 'package:provider_test/features/assignment/provider/assignment_provider.dart';
import 'package:provider_test/features/login/pages/signup_page.dart';
import 'package:provider_test/features/login/provider/login_provider.dart';
import 'package:provider_test/features/login/provider/test_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // Add this import for NavBar




void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String?token;
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    
  }

  void getToken()async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('auth_token');
    setState(() {
      token;
    });
  }
  
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>TestProvider()),
        ChangeNotifierProvider(create: (context)=>LoginProvider()),
        ChangeNotifierProvider(create: (context)=>AssignmentProvider()),
        ChangeNotifierProvider(create: (context) => UserRoleProvider()),

      
      
      ],
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home:token!=null?Dashboard():Signup()
        ),
      ),
    );
  }
}

