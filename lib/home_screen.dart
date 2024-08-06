import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saadcart/cart_screen.dart';
import 'package:saadcart/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController pName = TextEditingController();
  final TextEditingController pPrice = TextEditingController();
  final TextEditingController pCate = TextEditingController();


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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen(),));
          }, icon: Icon(Icons.shopping_cart)),
          SizedBox(
            width: 20,
          )
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("user").where('email', isEqualTo: userEmail).snapshots(),
              builder: (BuildContext context,  snapshot) {
                if (snapshot.hasData) {
                  var dataLength = snapshot.data!.docs.length;
                  return  ListView.builder(
                    itemCount: dataLength,
                    itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: ()async{
                        FirebaseAuth.instance.signOut();
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.clear();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                      },
                      child: ListTile(
                        title: Text(snapshot.data!.docs[index]['name']),
                      ),
                    );
                  },);
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("product").snapshots(),
          builder: (BuildContext context,  snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.docs[index]['pName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data!.docs[index]['pPrice']),
                      Text(snapshot.data!.docs[index]['pCate'])
                    ],
                  ),
                  trailing: IconButton(onPressed: ()async{
                    await FirebaseFirestore.instance.collection("cart").add(
                        {
                          "email" : userEmail,
                          "pID" : snapshot.data!.docs[index].id,
                          "pName" : snapshot.data!.docs[index]['pName'],
                          "pPrice" : snapshot.data!.docs[index]['pPrice'],
                          "pCate" : snapshot.data!.docs[index]['pCate'],
                          "count" : 1
                        });
                  }, icon: Icon(Icons.shopping_cart_checkout)),
                );
              },);
            } else if (snapshot.hasError) {
              return Icon(Icons.error_outline);
            } else {
              return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(onPressed: (){

        showModalBottomSheet(context: context, builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            setState((){

            });
            return Column(
              children: [
                TextFormField(
                  controller: pName,
                ),
                TextFormField(
                  controller: pPrice,
                ),
                TextFormField(
                  controller: pCate,
                ),
                ElevatedButton(onPressed: ()async{
                  await FirebaseFirestore.instance.collection("product").add(
                      {
                        "pName" : pName.text,
                        "pPrice" : pPrice.text,
                        "pCate": pCate.text,
                      });
                  Navigator.pop(context);
                }, child: Text("Add Product"))
              ],
            );
          },);
        },);

      },child: Icon(Icons.add),),
    );
  }
}
