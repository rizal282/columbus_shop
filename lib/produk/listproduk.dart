import 'dart:async';
import 'dart:convert';
import 'package:columbus_shop/admin/subkatproduk.dart';
import 'package:columbus_shop/login.dart';
import 'package:columbus_shop/pembeli/detailproduk.dart';
import 'package:http/http.dart' as http;
import 'package:columbus_shop/helper/DBHelper.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';

class ListProduk extends StatefulWidget {
  @override
  _ListProdukState createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  var db = DBHelper();
  String _itemSelected, _itemSubSelected;
  String url = MyUrl().getUrlDevice();
  List dataProduk = [];
  List menuKategori = List();
  List subKategori = List();

  StreamController<List> _streamController = StreamController();

  void _ambilProduk() async {
    var result = await http.post("$url/columbus/ambildataproduk.php", body: {
      "kategori": _itemSelected,
    });
    dataProduk = jsonDecode(result.body);
    _streamController.sink.add(dataProduk);
  }

  void _ambilMenuKategori() async {
    var result = await http.get("$url/columbus/admin/ambilmenukategori.php");
    var datakategori = jsonDecode(result.body);

    setState(() {
      menuKategori = datakategori;
    });
  }

  void _ambilSubKategori(String item) async {
    var result = await http.post("$url/columbus/admin/ambilsubkategori.php", body: {
      "idkategori" : item
    });

    setState(() {
      subKategori = json.decode(result.body);
    });
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
        title: Text("Produk"),
        actions: <Widget>[
          DropdownButton(
            value: _itemSelected,
            items: menuKategori
                .map((val) => DropdownMenuItem<String>(
                      value: val["nama_kat"],
                      child: Text(val["nama_kat"]),
                    ))
                .toList(),
            hint: Text(
              "Pilih Kategori :",
              style: TextStyle(color: Colors.white),
            ),
            onChanged: ((String newVal) {
              setState(() {
                _itemSelected = newVal;
                _ambilProduk();
                _ambilSubKategori(_itemSelected);
              });
            }),
          ),
          IconButton(
              icon: Icon(
                Icons.input,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PageLogin())))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<List>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sub Kategori"),
                      DropdownButton(
                        value: _itemSubSelected,
                        items: subKategori
                            .map((val) => DropdownMenuItem<String>(
                          value: val["nama_subkat"],
                          child: Text(val["nama_subkat"]),
                        ))
                            .toList(),
                        hint: Text(
                          "Pilih Sub Kategori :",
                          style: TextStyle(color: Colors.black),
                        ),
                        onChanged: ((String newVal) {
                          setState(() {
                            _itemSubSelected = newVal;
                          });

                          // alihkan ke halaman sub kategori sesuai item yg dipilih
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SubKatProduk(namaSubKat: newVal,))
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      children: List.generate(snapshot.data.length, (i) {
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshot.data[i]["nama_produk"]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 100,
                                    child: Image.network(
                                        "$url/columbus/produk/${snapshot.data[i]["foto"]}"),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(snapshot.data[i]["kategori"]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(snapshot.data[i]["harga"]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  OutlineButton(
                                    child: Text("Lihat"),
                                    onPressed: () =>
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => DetailProduk(
                                                  idProduk: snapshot.data[i]
                                                      ["id_produk"],
                                                  namaProduk: snapshot.data[i]
                                                      ["nama_produk"],
                                                  hargaProduk: snapshot.data[i]
                                                      ["harga"],
                                                  deskProduk: snapshot.data[i]
                                                      ["deskripsi"],
                                                  fotoProduk: snapshot.data[i]
                                                      ["foto"],
                                                  stokProduk: snapshot.data[i]
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
                ],
              );

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.redAccent[700],
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/icon/icon_app.png"),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Pilih kategori untuk melihat produk",
                  style: TextStyle(fontSize: 18),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
