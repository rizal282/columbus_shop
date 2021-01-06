import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Datanotifikasiadmin extends StatefulWidget {
  @override
  _DatanotifikasiadminState createState() => _DatanotifikasiadminState();
}

class _DatanotifikasiadminState extends State<Datanotifikasiadmin> {
  String url = MyUrl().getUrlDevice();

  // menngambil data notifikasi jika ada pembeli baru
  Future<List> getNotifAdmin() async {
    var result = await http.get("$url/columbus/admin/getdatanotifadmin.php");
    
    return jsonDecode(result.body);
  }
  
  @override
  void initState() {
    getNotifAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifikasi"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: getNotifAdmin(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Text("Tidak ada data");
            
            return Datanotifadmin(snapshot.data);
          },
        ),
      ),
    );
  }
}

class Datanotifadmin extends StatelessWidget {
  String url = MyUrl().getUrlDevice();
  List listNotif;
  
  Datanotifadmin(this.listNotif);

  void readNotif(String id) async {
    var result = await http.post("$url/columbus/admin/updatenotifadmin.php", body: {
      "id_beli" : id,
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Notifikasi Sudah Dibaca",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listNotif == null ? 0 : listNotif.length,
      itemBuilder: (context, i){
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text("Pembeli baru : ${listNotif[i]["nama_lengkap"]}"),
            subtitle: Text("Pembelian : ${listNotif[i]["nama_produk"]}"),
            onTap: () => readNotif(listNotif[i]["id_beli"]),
          ),
        );
      },
    );
  }
}

