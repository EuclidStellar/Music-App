
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ml/bar.dart';
// import 'package:ml/mlwow.dart';
// import 'package:ml/t1.dart';
import 'package:music_dev/m2.dart';

// FIrebase Implmentation is going to start from this commit 

void main() async{
  
  runApp(const Login());
}


class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),

     // home: CreateTeamScreenT(),
     home : MusicApp(),

    );
    
}
}