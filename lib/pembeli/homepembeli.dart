import 'dart:async';
import 'dart:convert';

import 'package:columbus_shop/helper/topbrandshelper.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:columbus_shop/login.dart';
import 'package:columbus_shop/pembeli/datanotifikasi.dart';
import 'package:columbus_shop/pembeli/keranjangbeli.dart';
import 'package:columbus_shop/pembeli/profilpembeli.dart';
import 'package:columbus_shop/produk/listproduk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePembeli extends StatefulWidget {
  final String idPembeli, userName, statusUser, noHp;

  const HomePembeli({Key key, this.idPembeli, this.userName, this.statusUser, this.noHp}) : super(key: key);

  @override
  _HomePembeliState createState() => _HomePembeliState();
}

class _HomePembeliState extends State<HomePembeli> {
  String url = MyUrl().getUrlDevice();
  List<Topbrandshelper> dataBrand = List();
  String totalNotif = "";

  // mengambil data top brand dari database sebanyak 4 buah
  // 4 adalah limit query sql yang berasal daro topbrand.php
  getTopBrands() async {
    var result = await http.get("$url/columbus/topbrand.php");
    var dataTopBrand = json.decode(result.body);

    for(int i = 0; i < dataTopBrand.length; i ++){
      var topbrhelper = Topbrandshelper(
        dataTopBrand[i]["kode_produk"],
        dataTopBrand[i]["nama_produk"],
        dataTopBrand[i]["kategori"],
        dataTopBrand[i]["no_produk"],
        dataTopBrand[i]["harga"],
        dataTopBrand[i]["foto"],
      );
      
      dataBrand.add(topbrhelper);
    }

    return dataBrand;
  }
  
  // mengambil total notifikasi dari tabel pembeli dengan cara menghitung jumlah produk yng tervalidasi dan yg belum dibaca oleh pembeli
  void hitungNotifPembeli() async {
    var result = await http.post("$url/columbus/hitungnotifpembeli.php", body: {
      "pembeli" : widget.noHp
    });

    var totalNotif = json.decode(result.body);

    setState(() {
      this.totalNotif = totalNotif[0]["totalnotif"];
    });
  }

  
  @override
  void initState() {
    getTopBrands();
    hitungNotifPembeli();
    super.initState();
  }

  // sidebar menu pembeli
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
    currentAccountPicture: CircleAvatar(
      child: Icon(Icons.person),
    ),
    accountName: Text("${widget.userName}"),
    accountEmail: Text("${widget.statusUser}"),
  );

  // menu item pembeli
  final drawerItems = ListView(
          children: <Widget>[
            drawerHeader,
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Beranda"),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Notifikasi"),
                  Text(this.totalNotif),
                ],
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Datanotifikasi(idpembeli: widget.noHp,))
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text("Kelola Profil"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfilPembeli(idUser: widget.idPembeli,))
              ),
            ),
            ListTile(
              leading: Icon(Icons.multiline_chart),
              title: Text("Pembelian"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => KeranjangBeli(idPembeli: widget.noHp,))
              ),
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text("Logout"),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (contex) => PageLogin())
              ),
            )
          ],
        );

    // tampilan ui homepage pembeli
    return Scaffold(
      appBar: AppBar(
        title: Text("Columbus Shop"),
        actions: [
            IconButton(
              icon: Icon(Icons.refresh), 
              onPressed: (){
                hitungNotifPembeli();
              })
          ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: DefaultTabController(
                    length: dataBrand.length,
                    child: Builder(
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: TabBarView(
                                children: dataBrand.map((f) => Container(
                                  child: Image.network("$url/columbus/produk/${f.foto}"),
                                )).toList(),
                              ),
                            ),
                            SizedBox(height: 15,),
                            TabPageSelector(color: Colors.red,selectedColor: Colors.black,),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0, bottom: 10),
                child: Text("Aplikasi", style: TextStyle(fontSize: 25),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 70),
                child: Text("Columbus Shop", style: TextStyle(fontSize: 25),),
              ),

              // tombol untuk melihat data produk
              Card(
                elevation: 4,
                color: Colors.redAccent[700],
                child: Container(
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListProduk())
                    ),
                    child: Center(child: Text("Lihat Produk", style: TextStyle(color: Colors.white, fontSize: 17),),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}