import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Datanotifikasi extends StatefulWidget {
  final String idpembeli;

  const Datanotifikasi({Key key, this.idpembeli}) : super(key: key);

  @override
  _DatanotifikasiState createState() => _DatanotifikasiState();
}

class _DatanotifikasiState extends State<Datanotifikasi> {
  String url = MyUrl().getUrlDevice();

  Future<List> _dataNotifPembeli() async {
    var result = await http.post("$url/columbus/getdatanotifpembeli.php", body: {
      "pembeli" : widget.idpembeli
    });

    return jsonDecode(result.body);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifikasi"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: _dataNotifPembeli(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Text("Tidak ada notifikasi");

            return ListNotifikasi(snapshot.data);
          },
        ),
      ),
    );
  }
}

class ListNotifikasi extends StatelessWidget {
  final List listNotif;

  ListNotifikasi(this.listNotif);

  String url = MyUrl().getUrlDevice();

  void readNotifPembeli(String id) async {
    var result = await http.post("$url/columbus/updatenotifpembeli.php", body: {
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Valid!"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${listNotif[i]["nama_produk"]}"),
                  Text("Dibeli tanggal ${listNotif[i]["tgl_beli"]} sudah tervalidasi!"),
                ],
              ),
              onTap: () => readNotifPembeli(listNotif[i]["id_beli"]),
            ),
          ),
        );
      },
    );
  }
}

