import 'dart:convert';

import 'package:columbus_shop/admin/editkategori.dart';
import 'package:columbus_shop/admin/tambahkategori.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DataKategori extends StatefulWidget {
  @override
  _DataKategoriState createState() => _DataKategoriState();
}

class _DataKategoriState extends State<DataKategori> {
  String url = MyUrl().getUrlDevice();
  List dataKategori = List();

  void getDataKategori() async {
    var result = await http.get("$url/columbus/admin/ambilmenukategori.php");
    setState(() {
      dataKategori = json.decode(result.body);
    });
  }

  void hapusKategori(String id) async {
    var result = await http.post("$url/columbus/admin/hapuskategori.php", body: {
      "idkategori" : id
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
        msg: "Data Kategori Dihapus",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT
      );
    }else{
      Fluttertoast.showToast(
          msg: "Gagal Menghapus",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  SingleChildScrollView _dataTableKategori(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("No")),
            DataColumn(label: Text("Nama Kategori")),
            DataColumn(label: Text("Edit")),
            DataColumn(label: Text("Hapus")),
          ], 
          rows: dataKategori.map((item) => DataRow(cells: <DataCell>[
            DataCell(Text(item["id_kat"])),
            DataCell(Text(item["nama_kat"])),
            DataCell(OutlineButton(
                child: Icon(Icons.edit),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditKategori(idkat: item["id_kat"], namakat: item["nama_kat"],))
                  );
                },
              )),
            DataCell(OutlineButton(
                child: Icon(Icons.delete),
                onPressed: () => hapusKategori(item["id_kat"]),
              )),
          ])).toList()),
      ),
    );
  }

  @override
  void initState() {
    getDataKategori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Kategori"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () => getDataKategori())
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: _dataTableKategori(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TambahKategori())
          );
        },
      ),
    );
  }
}