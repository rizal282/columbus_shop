import 'dart:convert';
import 'dart:io';

import 'package:columbus_shop/admin/lihatpdfpembeli.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class LaporanPembeli extends StatefulWidget {
  @override
  _LaporanPembeliState createState() => _LaporanPembeliState();
}

class _LaporanPembeliState extends State<LaporanPembeli> {
  String url = MyUrl().getUrlDevice();
  List _listPembeli = List();

  // method untuk mengambil data pembeli produk
  void _getPembeliProduk() async {
    var result = await http.get("$url/columbus/admin/pembeliproduk.php"); // memanggil data pembeli produk

    var listPembeli = jsonDecode(result.body); // mengubah data dari json php ke list (array) dalam flutter

    setState(() {
      _listPembeli = listPembeli;
    });
  }

  // method untuk menghapus data pembeli didalam laporan pembelian 
  void _hapusPembeli(String idbeli) async {
    var result = await http.post("$url/columbus/admin/hapuspembeliproduk.php", body: {
      "id_beli" : idbeli
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
        msg: "Data pembeli dihapus",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM
      );
    }
  }


  // fungsi untuk membentuk tabel laporan pembeli produk
  SingleChildScrollView _tabelPembeli() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            
            // membuat kolom2 data pembeli produk
            columns: [
              DataColumn(label: Text("Nama Pembeli")),
              DataColumn(label: Text("No HP")),
              DataColumn(label: Text("Alamat")),
              DataColumn(label: Text("Produk")),
              DataColumn(label: Text("Harga")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Hapus"))
            ],

            // membentuk data baris pembeli produk
            rows: _listPembeli.map((item) => DataRow(cells: <DataCell>[
              DataCell(Text(item["nama_lengkap"])),
              DataCell(Text(item["no_hp"])),
              DataCell(Text(item["alamat"])),
              DataCell(Text(item["nama_produk"])),
              DataCell(Text(item["harga"])),
              DataCell(Text(item["status_beli"])),
              DataCell(
                OutlineButton(
                  color: Colors.red,
                  onPressed: (){
                    _hapusPembeli(item["id_beli"]);
                  }, 
                  child: Text("Hapus")))
            ])).toList()),
      ),
    );
  }

  // method untuk membuat laporan pdf 
  void _filePDFPembeli(context) async {
    var result = await http.get("$url/columbus/admin/pembeliproduk.php"); // mengambil data dari database
    List _dataPembeli = jsonDecode(result.body);

    final pw.Document pdf = pw.Document(deflate: zlib.encode); // menyiapkan pdf
    
    // membuat data dalam pdf
    pdf.addPage(
        pw.MultiPage(
            orientation: pw.PageOrientation.landscape,
            build: (context) => [
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>["Nama Pembeli", "No HP", "Alamat", "Produk", "Harga", "Status"],
                ..._dataPembeli.map((item) => [
                  item["nama_lengkap"],
                  item["no_hp"],
                  item["alamat"],
                  item["nama_produk"],
                  item["harga"],
                  item["status_beli"],
                ])
              ])
            ]
        )
    );

    // menentukan lokasi penyimpanan file pdf
    final String dir = (await getExternalStorageDirectory()).path;
    final String path = "$dir/Laporan_data_pembeli.pdf"; // disimpan didalam penyimpanan internal/android/data/com.example.columbus_shop/files
    final File file = File(path);

    print(path);
    file.writeAsBytesSync(pdf.save());

    // melihat data laporan pdf
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LihatPdfPembeli(path: path,))
    );
  }

  @override
  void initState() {
    // otomatis menjalankan method _getpembeliproduk ketika laporanpembeli.dart di akses
    _getPembeliProduk();
    super.initState();
  }


  // dibawah ini kodingan untuk tampilan data laporan pembeli sebelum ke pdf

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Pembeli"),
        actions: <Widget>[

          // untuk membuat laporan pdf
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              _filePDFPembeli(context);
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text("Data Laporan Pembeli", style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            _tabelPembeli(),
          ],
        ),
      ),
    );
  }
}
