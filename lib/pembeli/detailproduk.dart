import 'package:columbus_shop/helperurl.dart';
// import 'package:columbus_shop/pembeli/keranjangbeli.dart';
import 'package:columbus_shop/pembeli/konfirmorder.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DetailProduk extends StatefulWidget {
  // parameter untuk tampilan data detail produk yg dipilih pembeli
  final String idPembeli, idProduk, namaProduk, hargaProduk, stokProduk, deskProduk, fotoProduk;

  // konstruktor untuk set data parameter diatas
  const DetailProduk(
      {Key key,
      this.idProduk,
      this.namaProduk,
      this.hargaProduk,
      this.fotoProduk,
      this.idPembeli, this.deskProduk, this.stokProduk})
      : super(key: key);
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  String url = MyUrl().getUrlDevice();

  // tampilan ui detail produk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: ListView(
            children: <Widget>[
              Text(widget.namaProduk),
              SizedBox(
                height: 15,
              ),
              Image.network("$url/columbus/produk/${widget.fotoProduk}"),
              SizedBox(
                height: 15,
              ),
              Text("Harga : ${widget.hargaProduk}"),
              SizedBox(
                height: 15,
              ),
              Text("Stok : ${widget.stokProduk}"),
              SizedBox(
                height: 15,
              ),
              Text("Deskripsi : "),
              SizedBox(height: 15,),
              Text(widget.deskProduk),
              SizedBox(
                height: 15,
              ),
              OutlineButton(
                color: Theme.of(context).primaryColor,
                child: Text("Beli"),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Konfirmorder(
                    idProduk: widget.idProduk,
                    stokProduk: widget.stokProduk,
                  ))
                ),
              )
            ],
          ),
      ),
    );
  }
}
