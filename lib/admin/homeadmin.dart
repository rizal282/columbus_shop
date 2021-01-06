import 'dart:async';
import 'dart:convert';

import 'package:columbus_shop/admin/dataadmin.dart';
import 'package:columbus_shop/admin/datakategori.dart';
import 'package:columbus_shop/admin/datanotifikasiadmin.dart';
import 'package:columbus_shop/admin/datasubkategori.dart';
import 'package:columbus_shop/admin/kelolaproduk.dart';
import 'package:columbus_shop/admin/laporanpembeli.dart';
import 'package:columbus_shop/admin/laporanpenjualan.dart';
import 'package:columbus_shop/admin/pembeliproduk.dart';
import 'package:columbus_shop/helperurl.dart';
// import 'package:columbus_shop/helper/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:columbus_shop/login.dart';
import 'package:flutter/material.dart';

class Homeadmin extends StatefulWidget {
  // parameter login admin
  final String idAdmin, userName, statusUser, noHp;

  const Homeadmin({Key key, this.idAdmin, this.userName, this.statusUser, this.noHp}) : super(key: key);

  @override
  _HomeadminState createState() => _HomeadminState();
}

class _HomeadminState extends State<Homeadmin> {
  String url = MyUrl().getUrlDevice();
  String totalNotif = "";
  final Stream<int> _periodicStream = Stream.periodic(Duration(microseconds: 1000), (i) => i);

  // mengambil total notifikasi dari tabel pembeli dengan cara menghitung jumlah produk yng tervalidasi dan yg belum dibaca oleh pembeli
  hitungNotifAdmin() async {
    var result = await http.get("$url/columbus/admin/hitungnotifadmin.php");

    var totalNotif = json.decode(result.body);

    setState(() {
      this.totalNotif = totalNotif[0]["totalnotif"];
    });
  }

  @override
  void initState() {
    hitungNotifAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // ini adalah menu sidebar admin
    final drawerHeader = UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        child: Icon(Icons.person),
      ),
      accountName: Text("${widget.userName}"),
      accountEmail: Text("${widget.statusUser}"),
    );

    // ini adalah item menu sidebar admin
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
                  MaterialPageRoute(builder: (context) => Datanotifikasiadmin())
                ),
              ),

              ListTile(
                leading: Icon(Icons.add_moderator),
                title: Text("Data Admin"),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataAdmin())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.category),
                title: Text("Data Kategori"),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataKategori())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.category),
                title: Text("Data Sub Kategori"),
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DataSubKategori())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Kelola Produk"),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => KelolaProduk())
                ),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text("Pembeli Produk"),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PembeliProduk())
                ),
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text("Laporan Pembeli"),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LaporanPembeli())
                ),
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text("Laporan Penjualan"),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LaporanPenjualan())
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text("Logout"),
                onTap: () {
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PageLogin())
                  );
                },
              )
            ],
          );
      
      // tampilan ui homepage admin
      return Scaffold(
        appBar: AppBar(
          title: Text("Admin Columbus"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh), 
              onPressed: (){
                hitungNotifAdmin();
              })
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          child: ListView(
              children: <Widget>[
                Image.asset("assets/icon/icon_app.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                  child: Center(child: Text("Administrator Aplikasi", style: TextStyle(fontSize: 25),)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 70),
                  child: Center(child: Text("Columbus Shop", style: TextStyle(fontSize: 25),)),
                ),

                // tombol untuk melihat data produk

              ],
            ),
        ),
        drawer: Drawer(
          child: drawerItems,
        ),
      );
  }
}