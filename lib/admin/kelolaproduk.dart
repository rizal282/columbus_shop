import 'dart:async';
import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:columbus_shop/produk/addproduk.dart';
import 'package:columbus_shop/produk/editproduk.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class KelolaProduk extends StatefulWidget {
  @override
  _KelolaProdukState createState() => _KelolaProdukState();
}

class _KelolaProdukState extends State<KelolaProduk> {
  String url = MyUrl().getUrlDevice(); // memanggil url ip address device
  String _itemSelected; // variable
  List dataProduk = List(); // variable untuk menampung data produk
  List menuKategori = List();

  StreamController<List> _streamController =
      StreamController(); // variabel untuk handle output list produk

  // method untuk proses ambil data produk
  void _ambilProduk() async {
    var response =
        await http.post("$url/columbus/admin/ambilproduk.php", body: {
      "kategori": _itemSelected,
    });

    dataProduk = jsonDecode(response.body);
    _streamController.add(dataProduk);
  }

  void _ambilMenuKategori() async {
    var result = await http.get("$url/columbus/admin/ambilmenukategori.php");
    var datakategori = jsonDecode(result.body);

    setState(() {
      menuKategori = datakategori;
    });
  }

  // menu pilihan edit hapus produk
  static const menuPopupItems = <String>[
    "Edit",
    "Hapus",
  ];

  final List<PopupMenuItem<String>> _popupMenuItems = menuPopupItems
      .map((String val) => PopupMenuItem<String>(
            value: val,
            child: Text(val),
          ))
      .toList();

  // method untuk proses hapus produk
  void _hapusProduk(String id, String namafile) async {
    // menampilkan pesan sebelum menghapus produk
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Perhatian"),
              content: Text("Anda yakin ingin menghapus item ini?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Tidak"),
                  onPressed: () => Navigator.of(context).pop(),
                ),

                // tombol untuk menghapus produk
                FlatButton(
                  child: Text("Ya"),
                  onPressed: () async {
                    var res = await http
                        .post("$url/columbus/admin/hapusproduk.php", body: {
                      "idproduk": id,
                      "namafile": namafile,
                    });

                    Fluttertoast.showToast(
                        msg: "Data Produk sudah dihapus",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM);

                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  // method untuk menuju ke page edit produk
  void _onSelectedItem(String val, String id, String namafile) {
    val == "Edit"
        ? Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProduk(
                  idProduk: id,
                )))
        : _hapusProduk(id, namafile);
  }

  @override
  void initState() {
    _ambilMenuKategori();
    super.initState();
  }

  // tampilan ui data produk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Produk"),

        // harus memilih kategori dulu sebelum kelola produk
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
              "Kategori",
              style: TextStyle(color: Colors.white),
            ),
            onChanged: ((String newVal) {
              setState(() {
                _itemSelected = newVal;
                _ambilProduk();
              });
            }),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<List>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return GridView.count(
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
                                Expanded(
                                  child: Text(snapshot.data[i][
                                      "nama_produk"]),
                                ), // menampilkan data nama produk
                                PopupMenuButton(
                                  onSelected: (String newVal) {
                                    _onSelectedItem(
                                        newVal,
                                        snapshot.data[i]["id_produk"],
                                        snapshot.data[i]["foto"]);
                                  },
                                  itemBuilder: (context) => _popupMenuItems,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 100,
                              child: Image.network(
                                  "$url/columbus/produk/${snapshot.data[i]["foto"]}"), // menampilkan data foto
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(snapshot.data[i]
                                ["kategori"]), // menampilkan data kategori
                            SizedBox(
                              height: 15,
                            ),
                            Text(snapshot.data[i]
                                ["harga"]), // menampilkan data harga
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );

            return Center(child: Text("Pilih kategori..."));
          },
        ),
      ),

      // tombol untuk menambah data produk
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddProduk())),
        backgroundColor: Colors.red,
      ),
    );
  }
}
