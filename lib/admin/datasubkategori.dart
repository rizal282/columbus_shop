import 'dart:convert';
import 'package:columbus_shop/admin/editsubkategori.dart';
import 'package:columbus_shop/admin/tambahsubkategori.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';

class DataSubKategori extends StatefulWidget {
  @override
  _DataSubKategoriState createState() => _DataSubKategoriState();
}

class _DataSubKategoriState extends State<DataSubKategori> {
  String url = MyUrl().getUrlDevice();
  List dataSubKategori = List();

  void _ambilSubKategori() async {
    var result = await http.get("$url/columbus/admin/ambildatasubkategori.php");
    setState(() {
      dataSubKategori = json.decode(result.body);
    });
  }

  void hapusSubKategori(String id) async {
    var result = await http.post("$url/columbus/admin/hapussubkategori.php", body: {
      "idsubkategori" : id
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Data Sub Kategori Dihapus",
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
  
  SingleChildScrollView _tabelSubKategori(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("Grup")),
            DataColumn(label: Text("Nama Sub Kategori")),
            DataColumn(label: Text("Edit")),
            DataColumn(label: Text("Hapus"))
          ],
          rows: dataSubKategori.map((item) => DataRow(cells: <DataCell>[
            DataCell(Text(item["grup_kategori"])),
            DataCell(Text(item["nama_subkat"])),
            DataCell(
              OutlineButton(
                child: Icon(Icons.edit),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditSubKategori(
                      idSubKategori: item["id_subkat"],
                      namaSubKategori: item["nama_subkat"],
                    ))
                  );
                },
              )
            ),
            DataCell(OutlineButton(
                child: Icon(Icons.delete),
                onPressed: () => hapusSubKategori(item["id_subkat"]),
              )),
          ])).toList(),
        ),
      ),
    );
  }
  
  @override
  void initState() {
    _ambilSubKategori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Kategori"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () => _ambilSubKategori())
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: _tabelSubKategori(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TambahSubKategori())
          );
        },
      ),
    );
  }
}
