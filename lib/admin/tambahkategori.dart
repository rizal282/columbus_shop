import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TambahKategori extends StatefulWidget {
  @override
  _TambahKategoriState createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  String url = MyUrl().getUrlDevice();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaKategori = new TextEditingController();

  void simpanKategori() async {
    var result = await http.post("$url/columbus/admin/tambahkategori.php", body: {
      "kategori" : _namaKategori.text
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
            msg: "Kategori Sudah Ditambahkan",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);

      _namaKategori.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Kategori"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaKategori,
                decoration: InputDecoration(
                    hintText: "Masukan Nama Kategori",
                    labelText: "Nama Kategori"),
              ),
              SizedBox(height: 10,),
              OutlineButton(
                onPressed: () => simpanKategori(),
                child: Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
