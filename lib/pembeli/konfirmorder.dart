import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Konfirmorder extends StatefulWidget {
  final String idProduk, stokProduk;

  const Konfirmorder({Key key, this.idProduk, this.stokProduk}) : super(key: key);
  @override
  _KonfirmorderState createState() => _KonfirmorderState();
}

class _KonfirmorderState extends State<Konfirmorder> {
  String url = MyUrl().getUrlDevice();
  final _nomorHpLogin = new TextEditingController();

  void _konfirmasiOrder() async {
    if(_nomorHpLogin.text != ""){
      var ceknomor = await http.post("$url/columbus/ceknohpkonfirm.php", body: {
        "nohp" : _nomorHpLogin.text
      });

      List datanohp = jsonDecode(ceknomor.body);

      if(datanohp.length == 0){
        Fluttertoast.showToast(
            msg: "No HP Anda tidak terdaftar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );
      }else{
        var result = await http.post("$url/columbus/addtokeranjang.php", body: {
          "idproduk" : widget.idProduk,
          "idpembeli" : _nomorHpLogin.text,
          "stok" : widget.stokProduk,
        });

        if(result.statusCode == 200){
          Fluttertoast.showToast(
              msg: "Produk sudah diorder",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
        }
      }
    }else{
      Fluttertoast.showToast(
          msg: "Nomor HP belum dimasukan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konfirmasi Order"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Masukan nomor HP Login Anda untuk konfirmasi order", style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,),
            SizedBox(height: 15,),
            TextFormField(
              controller: _nomorHpLogin,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nomor HP",
                hintText: "Masukan Nomor HP Login Anda"
              ),
            ),
            SizedBox(height: 15,),
            Card(
              elevation: 4,
              color: Colors.red,
              child: Container(
                width: 150,
                height: 50,
                child: InkWell(
                  splashColor: Colors.white,
                  child: Center(
                      child: Text(
                        "Konfirmasi",
                        style: TextStyle(color: Colors.white),
                      )),
                  onTap: () => _konfirmasiOrder(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
