import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("cart").where('email',isEqualTo: userEmail).snapshots(),
          builder: (BuildContext context,  snapshot) {
            if (snapshot.hasData) {
              var dataLength = snapshot.data!.docs.length;
              return  ListView.builder(
                itemCount: dataLength,
                itemBuilder: (context, index) {


                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['pName']),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        children: [
                          IconButton(onPressed: (){

                            int count = snapshot.data!.docs[index]['count'];
                            int total = snapshot.data!.docs[index]['tprice'];
                            String price = snapshot.data!.docs[index]['pPrice'];
                            int priceP = int.parse(price);

                              count += 1;
                              FirebaseFirestore.instance.collection("cart").doc(snapshot.data!.docs[index].id).update({
                                "count" : count,
                                "tprice" : count * priceP
                              });
                          }, icon: Icon(Icons.add)),
                          Text("${snapshot.data!.docs[index]['count']}"),
                          IconButton(onPressed: (){
                            int count = snapshot.data!.docs[index]['count'];
                            int total = snapshot.data!.docs[index]['tprice'];
                            String price = snapshot.data!.docs[index]['pPrice'];
                            int priceP = int.parse(price);
                            if(count > 1){
                                count -= 1;
                                FirebaseFirestore.instance.collection("cart").doc(snapshot.data!.docs[index].id).update({
                                  "count" : count,
                                  "tprice" : count * priceP
                                });

                            }
                          }, icon: Icon(Icons.minimize)),
                        ],
                      ),
                    ),
                  );
                },);
            } else if (snapshot.hasError) {
              return Icon(Icons.error_outline);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
