import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photo_sharing_app/home_screen/home_screen.dart';
import 'package:photo_sharing_app/log_in/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();


  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization =Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder:  (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: Text('welcome to photo sharing app'),
                  ),
                ),
              );
            }
          if(snapshot.hasError)
          {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(

                body: Center(
                  child: Text('An error occured,please wait...'),
                ),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'flutter photo sharing app',
            home: FirebaseAuth.instance.currentUser == null ? LoginScreen():HomeScreen(),
          );
        }
    );
  }
}

