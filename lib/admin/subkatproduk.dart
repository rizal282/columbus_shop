import 'dart:convert';

import 'package:columbus_shop/pembeli/detailproduk.dart';
import 'package:http/http.dart' as http;
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';

class SubKatProduk extends StatefulWidget {
  final String namaSubKat;

  const SubKatProduk({Key key, this.namaSubKat}) : super(key: key);
  @override
  _SubKatProdukState createState() => _SubKatProdukState();
}

class _SubKatProdukState extends State<SubKatProduk> {
  String url = MyUrl().getUrlDevice();
  List dataProdukSubKat = List();

  void _getProdukSubKat() async {
    var result = await http.post("$url/columbus/admin/ambilproduksubkat.php", body: {
      "namasubkat" : widget.namaSubKat
    });

    setState(() {
      dataProdukSubKat = json.decode(result.body);
    });
  }

  @override
  void initState() {
    _getProdukSubKat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Kategori ${widget.namaSubKat}"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: dataProdukSubKat == null
        ? Center(child: Text("Tidak ada data"),)
        : GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: List.generate(dataProdukSubKat.length, (i) {
             return Card(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(dataProdukSubKat[i]["nama_produk"]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 100,
                                    child: Image.network(
                                        "$url/columbus/produk/${dataProdukSubKat[i]["foto"]}"),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(dataProdukSubKat[i]["kategori"]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(dataProdukSubKat[i]["harga"]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  OutlineButton(
                                    child: Text("Lihat"),
                                    onPressed: () =>
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => DetailProduk(
                                                  idProduk: dataProdukSubKat[i]
                                                      ["id_produk"],
                                                  namaProduk: dataProdukSubKat[i]
                                                      ["nama_produk"],
                                                  hargaProduk: dataProdukSubKat[i]
                                                      ["harga"],
                                                  deskProduk: dataProdukSubKat[i]
                                                      ["deskripsi"],
                                                  fotoProduk: dataProdukSubKat[i]
                                                      ["foto"],
                                                  stokProduk: dataProdukSubKat[i]
                                                      ["stok"],
                                                ))),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
          }),
        ),
      ),
    );
  }
}