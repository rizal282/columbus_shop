import 'dart:convert';

import 'package:columbus_shop/admin/lihatfotobayar.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PembeliProduk extends StatefulWidget {
  @override
  _PembeliProdukState createState() => _PembeliProdukState();
}

class _PembeliProdukState extends State<PembeliProduk> {
  String url = MyUrl().getUrlDevice();
  List _listPembeli = List();
  
  // method untuk mengambil data pembeli produk
  void _getPembeliProduk() async {
    var result = await http.get("$url/columbus/admin/pembeliproduk.php"); // proses pengambilan data

    var listPembeli = jsonDecode(result.body);

    setState(() {
      _listPembeli = listPembeli;
    });
  }

  @override
  void initState() {
    _getPembeliProduk();
    super.initState();
  }

  // method untuk membuat tampilan data tabel pembeli produk
  SingleChildScrollView _tabelPembeli() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
        
        // data kolom pembeli
        columns: [
          DataColumn(label: Text("Nama Pembeli")),
          DataColumn(label: Text("No HP")),
          DataColumn(label: Text("Alamat")),
          DataColumn(label: Text("Produk")),
          DataColumn(label: Text("Harga")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Validasi")),
        ],

        // baris data pembeli
        rows: _listPembeli.map((item) => DataRow(cells: <DataCell>[
          DataCell(Text(item["nama_lengkap"])),
          DataCell(Text(item["no_hp"])),
          DataCell(Text(item["alamat"])),
          DataCell(Text(item["nama_produk"])),
          DataCell(Text(item["harga"])),
          DataCell(Text(item["status_beli"])),
          DataCell(
            item["status_beli"] == "Valid"
                ? Icon(Icons.check, color: Colors.green,)
                : OutlineButton(
              child: Text("Validasi"),
              onPressed: () {
                // print(item["id_beli"]);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Lihatfotobayar(
                    idbeli: item["id_beli"],
                    namaPembeli: item["nama_lengkap"],
                  ))
                );
              },
            )
          ),
        ])).toList()),
      ),
    );
  }
  
  // tampilan ui data tabel pembeli
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembeli Produk"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text("Data Pembeli", style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            _tabelPembeli(),
          ],
        ),
      ),
    );
  }
}
