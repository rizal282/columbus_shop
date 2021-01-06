import 'dart:convert';
import 'dart:io';

import 'package:columbus_shop/admin/lihatpdfpenjualan.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class LaporanPenjualan extends StatefulWidget {
  @override
  _LaporanPenjualanState createState() => _LaporanPenjualanState();
}

class _LaporanPenjualanState extends State<LaporanPenjualan> {

  String url = MyUrl().getUrlDevice();
  List _listPenjualan = List();

  // method untuk mengambil data penjualan produk
  void _getPenjualanProduk() async {
    var result = await http.get("$url/columbus/admin/penjualanproduk.php");

    var listPembeli = jsonDecode(result.body);

    setState(() {
      _listPenjualan = listPembeli;
    });
  }

  // method untuk membuat tabel data penjualan produk
  SingleChildScrollView _tabelPenjualan() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            
            // kolom data penjualan
            columns: [
              DataColumn(label: Text("Kode Produk")),
              DataColumn(label: Text("Produk")),
              DataColumn(label: Text("Harga")),
              DataColumn(label: Text("Kategori")),
              DataColumn(label: Text("Tanggal Jual")),
            ],

            // baris data penjualan
            rows: _listPenjualan.map((item) => DataRow(cells: <DataCell>[
              DataCell(Text(item["kode_produk"])),
              DataCell(Text(item["nama_produk"])),
              DataCell(Text(item["harga"])),
              DataCell(Text(item["kategori"])),
              DataCell(Text(item["tgl_beli"])),
            ])).toList()),
      ),
    );
  }

  // method untuk membuat file pdf penjualan produk
  void _filePDFpenjualan(context) async {
    var response = await http.get("$url/columbus/admin/penjualanproduk.php");
    List _dataPenjualan = jsonDecode(response.body);

    final pw.Document pdf = pw.Document(deflate: zlib.encode);
    pdf.addPage(
        pw.MultiPage(
            orientation: pw.PageOrientation.landscape,
            build: (context) => [
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>["Kode Produk", "Produk", "Harga", "Kategori", "Tgl Beli"],
                ..._dataPenjualan.map((item) => [
                  item["kode_produk"],
                  item["nama_produk"],
                  item["harga"],
                  item["kategori"],
                  item["tgl_beli"],
                ])
              ])
            ]
        )
    );

    // menyimpan file pdf
    final String dir = (await getExternalStorageDirectory()).path;
    final String path = "$dir/Laporan_data_penjualan.pdf";
    final File file = File(path);

    print(path);
    file.writeAsBytesSync(pdf.save());

    // melihat file pdf
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LihatPdfPenjualan(path: path,))
    );
  }

  @override
  void initState() {
    _getPenjualanProduk(); // otomatis menjalankan dan memanggil data penjualan
    super.initState();
  }

  // tampilan ui untuk data penjualan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Penjualan"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: (){
              _filePDFpenjualan(context);
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text("Data Laporan Penjualan", style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            _tabelPenjualan(),
          ],
        ),
      ),
    );
  }
}
