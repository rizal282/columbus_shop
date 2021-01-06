import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:columbus_shop/pembeli/pembayaran.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KeranjangBeli extends StatefulWidget {
  final String idPembeli;

  const KeranjangBeli({Key key, this.idPembeli}) : super(key: key);
  @override
  _KeranjangBeliState createState() => _KeranjangBeliState();
}

class _KeranjangBeliState extends State<KeranjangBeli> {
  String url = MyUrl().getUrlDevice();
  List dataKeranjang = List();
  
  // mengambil data keranjang produk yg dibeli user sebelum validasi admin
  void _getDataKeranjang() async {
    var response = await http.post("$url/columbus/getdatakeranjang.php", body: {
      "idPembeli" : widget.idPembeli
    });
    
    setState(() {
      dataKeranjang = jsonDecode(response.body);
    });
  }
  
  @override
  void initState() {
    print(dataKeranjang);
    _getDataKeranjang();
    super.initState();
  }
  
  // tabel tampilan data keranjang produk yg dibeli
  SingleChildScrollView _tabelKeranjang() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
            columns: [
              DataColumn(label: Text("Kode Produk")),
              DataColumn(label: Text("Nama Produk")),
              DataColumn(label: Text("Harga Produk")),
              DataColumn(label: Text("Foto Produk")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Transaksi")),
            ], 
            rows: dataKeranjang.map((item) => DataRow(cells: <DataCell>[
              DataCell(Text(item["kode_produk"])),
              DataCell(Text(item["nama_produk"])),
              DataCell(Text(item["harga"])),
              DataCell(
                Container(
                  width: 100,
                  child: Image.network("$url/columbus/produk/${item["foto"]}"),
                )
              ),
              DataCell(Text(item["status_beli"])),
              DataCell(
                item["foto_bayar"] == ""
                    ? OutlineButton(
                  child: Text("Bayar Transaksi"),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Pembayaran(idBeli: item["id_beli"],))
                  ),
                ) : Text("Transaksi dibayar")
              ),
                ])).toList()),
      ),
    );
  }
  
  // tampilan ui dari data keranjang produk yg dibeli
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text("Keranjang Pembelian Anda", style: TextStyle(fontSize: 20),),
            SizedBox(height: 15,),
            dataKeranjang.length == 0
            ? Center(child: Text("Tidak ada pembelian...")) : _tabelKeranjang()
          ],
        ),
      ),
    );
  }
}
