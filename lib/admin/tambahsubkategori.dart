import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TambahSubKategori extends StatefulWidget {
  @override
  _TambahSubKategoriState createState() => _TambahSubKategoriState();
}

class _TambahSubKategoriState extends State<TambahSubKategori> {
  String url = MyUrl().getUrlDevice();
  String itemKategori;
  List menuKategori = List();

  final namaSubKategori = new TextEditingController();

  void _ambilMenuKategori() async {
    var result = await http.get("$url/columbus/admin/ambilmenukategori.php");
    var datakategori = jsonDecode(result.body);

    setState(() {
      menuKategori = datakategori;
    });
  }

  void _tambahSubKategori() async {
    var result = await http.post("$url/columbus/admin/tambahsubkategori.php", body: {
      "grupkategori" : itemKategori,
      "subkategori" : namaSubKategori.text,
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
        msg: "Sub Kategori Baru Disimpan",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT
      );
    }else{
      Fluttertoast.showToast(
          msg: "Gagal Tersimpan",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  @override
  void initState() {
    _ambilMenuKategori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Sub Kategori"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: formElement(),
      ),
    );
  }

  Widget formElement(){
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Kategori"),
            DropdownButton(
                value: itemKategori,
                hint: Text(
                  "Pilih Kategori :",
                  style: TextStyle(color: Colors.black),
                ),
                items: menuKategori
                    .map((val) => DropdownMenuItem<String>(
                  value: val["nama_kat"],
                  child: Text(val["nama_kat"]),
                ))
                    .toList(),
                onChanged: ((String newVal){
                  setState(() {
                    itemKategori = newVal;
                  });
                }))
          ],
        ),
        TextFormField(
          controller: namaSubKategori,
          decoration: InputDecoration(
            labelText: "Nama Sub Kategori",
          ),
        ),
        OutlineButton(
          child: Text("Simpan"),
          onPressed: () => _tambahSubKategori(),
        )
      ],
    );
  }
}
