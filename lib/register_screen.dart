
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saadcart/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final TextEditingController userName = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
          const SizedBox(height: 10,),
          
          TextFormField(
            controller: userName,
          ),

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
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userEmail.text, password: userPassword.text);
            FirebaseFirestore.instance.collection("user").add({
              "name" : userName.text,
              "email" : userEmail.text,
              "password" :userPassword.text
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
          }, child: const Text("Register")),

          const SizedBox(height: 10,),

          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
          }, child: Text("Login Yourself"))

        ],
      ),
    );
  }
}
