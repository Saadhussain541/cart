import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saadcart/home_screen.dart';
import 'package:saadcart/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          const SizedBox(height: 10,),

          TextFormField(
            controller: userEmail,
          ),

          const SizedBox(height: 10,),

          TextFormField(
            controller: userPassword,
          ),

          const SizedBox(height: 10,),

          ElevatedButton(onPressed: ()async{
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail.text, password: userPassword.text);
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('email', userEmail.text);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));

          }, child: const Text("Login")),

          const SizedBox(height: 10,),

          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen(),));
          }, child: Text("Register Yourself"))

        ],
      ),
    );
  }
}
