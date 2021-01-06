import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:columbus_shop/produk/formeditproduk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProduk extends StatefulWidget {
  final String idProduk;

  EditProduk({this.idProduk});
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  String url = MyUrl().getUrlDevice();

  Future<List> _ambilProduk() async {
    var result = await http.post("$url/columbus/admin/ambileditproduk.php", body: {
      "idproduk" : widget.idProduk,
    });

    return jsonDecode(result.body);
  }

  @override
  void initState() {
    _ambilProduk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Produk"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _ambilProduk(),
          builder: (context, snapshot){
            var dataeditproduk = snapshot.data;
            if(snapshot.hasData)
              return FormEditProduk(listEditProduk: dataeditproduk,);

            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
