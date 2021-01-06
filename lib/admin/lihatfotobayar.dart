import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Lihatfotobayar extends StatefulWidget {
  final String idbeli, namaPembeli;

  const Lihatfotobayar({Key key, this.namaPembeli, this.idbeli}) : super(key: key);
  @override
  _LihatfotobayarState createState() => _LihatfotobayarState();
}

class _LihatfotobayarState extends State<Lihatfotobayar> {
  String url = MyUrl().getUrlDevice();
  List dataFoto = List();

  @override
  void initState() {
    getFotBayar(widget.idbeli);
    // print(widget.idbeli);
    super.initState();
  }

  void getFotBayar(String idbeli) async {
    var result = await http.post("$url/columbus/admin/ambilfotobayar.php", body: {
      "id_beli" : idbeli
    });

    setState(() {
      dataFoto = jsonDecode(result.body);
    });

    print(dataFoto[0]["id_beli"]);
  }

  // method untuk memvalidasi pembeli yang sudah upload bukti transaksi
  void _validasiPembeli(String id) {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Perhatian"),
          content: Text("Ubah validasi pembeli ini?"),
          actions: <Widget>[
            
            // tombol jika batal divalidasi
            FlatButton(
              child: Text("Tidak"),
              onPressed: () => Navigator.of(context).pop(),
            ),

            // tombol jika akan divalidasi
            FlatButton(
              child: Text("Ya"),
              onPressed: () async {

                // proses validasi
                var response = await http.post("$url/columbus/admin/validasipembeli.php", body: {
                  "id_beli" : id,
                });

                if(response.statusCode == 200){

                  // jika berhasil divalidasi
                  Fluttertoast.showToast(
                    msg: "Pembeli divalidasi",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  );
                }else{

                  // jika gagal validasi
                  Fluttertoast.showToast(
                      msg: "Pembeli gagal divalidasi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM
                  );
                }

                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Foto Pembayaran ${widget.namaPembeli}"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: dataFoto.length == 0
              ? Center(child: Text("Loading..."),)
              : Image.network("$url/columbus/fotobayar/${dataFoto[0]["foto_bayar"]}"),
            ),
            SizedBox(height: 20,),
            OutlineButton(
              child: Text("Validasi"),
              onPressed: (){
                _validasiPembeli(dataFoto[0]["id_beli"]);
              },
            )
          ],
        ),
      ),
    );
  }
}