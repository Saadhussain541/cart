import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saadcart/firebase_options.dart';
import 'package:saadcart/home_screen.dart';
import 'package:saadcart/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  Future getuser()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    return email;
  }

  String userEmail = '';

  @override
  void initState() {
    // TODO: implement initState

    getuser().then((val){
      setState(() {
        userEmail = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userEmail != null ? HomeScreen() : LoginScreen();
  }
}


