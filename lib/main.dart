import 'dart:async';
import 'package:columbus_shop/produk/listproduk.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Columbus Shop",
      theme: ThemeData(
        primaryColor: Colors.redAccent[700],
        
      ),
      debugShowCheckedModeBanner: false,
      home: Splashpage(),
    );
  }
}

class Splashpage extends StatefulWidget {
  @override
  _SplashpageState createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {

  // method yg akan mengalihkan dari splashpage ke login
  void _movePage() async {
    var duration = const Duration(seconds: 5);
    Timer(duration, (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ListProduk())
      );
    });
  }

  @override
  void initState() {
    _movePage();
    super.initState();
  }

  // tampilan splash page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orangeAccent[400]
              ),
              child: Image.asset("assets/icon/icon_app.png"),
            ),
            SizedBox(height: 15,),
            Text("Selamat Datang di", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),),
            SizedBox(height: 15,),
            Text("COLUMBUS SHOP", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),)
          ],
        ),
      ),
    );
  }
}