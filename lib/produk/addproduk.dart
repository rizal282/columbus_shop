import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddProduk extends StatefulWidget {
  @override
  _AddProdukState createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  String urlDevice = MyUrl().getUrlDevice();
  GlobalKey<FormState> _formValidasi = GlobalKey<FormState>();
  File _fileProduk;
  String _itemSelected, _itemSubKat;
  List menuKategori = List();
  List subKategori = List();

  // kode untuk menangkap value yg diinput user
  final _kodeProduk = new TextEditingController();
  final _namaProduk = new TextEditingController();
  final _noProduk = new TextEditingController();
  final _stokProduk = new TextEditingController();
  final _hargaProduk = new TextEditingController();
  final _deskProduk = new TextEditingController();

  void _ambilMenuKategori() async {
    var result = await http.get("$urlDevice/columbus/admin/ambilmenukategori.php");
    var datakategori = jsonDecode(result.body);

    setState(() {
      menuKategori = datakategori;
    });
  }

  void _ambilSubKategori() async {
    var result = await http.get("$urlDevice/columbus/admin/ambilsubkategoritambahproduk.php");

    setState(() {
      subKategori = json.decode(result.body);
    });
  }

  void _ambilFotoProduk() async {
    var foto = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _fileProduk = foto;
    });
  }

  // mereset form jika berhasil diinput
  void emptyForm() {
    _kodeProduk.clear();
    _namaProduk.clear();
    _itemSelected = null;
    _itemSubKat = null;
    _noProduk.clear();
    _stokProduk.clear();
    _hargaProduk.clear();
    _fileProduk = null;
    _deskProduk.clear();
  }
  
  // membuat kode produk
  void _buatKodeProduk(String kat, String nama) async {
    var result = await http.post("$urlDevice/columbus/admin/getkodeproduk.php", body: {
      "kategori" : kat,
      "namaproduk" : nama
    });

    var data = jsonDecode(result.body);

    setState(() {
      _kodeProduk.text = data["kode_produk"];
    });
  }

  // kode untuk memproses tambah data produk
  void _addProduk(File file) async {
    if (_formValidasi.currentState.validate()) {
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var url = Uri.parse("$urlDevice/columbus/admin/uploadproduk.php");

      var request = http.MultipartRequest("POST", url);
      var multipartFile = http.MultipartFile("produk", stream, length,
          filename: basename(file.path));

      request.fields["kodeproduk"] = _kodeProduk.text;
      request.fields["namaproduk"] = _namaProduk.text;
      request.fields["kategori"] = _itemSelected;
      request.fields["sub_kat"] = _itemSubKat;
      request.fields["noproduk"] = _noProduk.text;
      request.fields["stokproduk"] = _stokProduk.text;
      request.fields["hargaproduk"] = _hargaProduk.text;
      request.fields["deskProduk"] = _deskProduk.text;
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        // jika berhasil
        Fluttertoast.showToast(
            msg: "Produk baru berhasil ditambahkan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);

        emptyForm();
      } else {

        // jika gagal
        Fluttertoast.showToast(
            msg: "Produk baru gagal ditambahkan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);

        emptyForm();
      }
    }
  }

  @override
  void initState() {
    _ambilMenuKategori();
    _ambilSubKategori();
    super.initState();
  }


  // ui form tambah produk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Produk"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formValidasi,
          child: _formProduk(),
        ),
      ),
    );
  }

  // form tamba produk
  Widget _formProduk() {
    return ListView(
      children: <Widget>[

        // kode text input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Kategori"),
            DropdownButton(
              value: _itemSelected,
              items: menuKategori.map((val) => DropdownMenuItem<String>(
                      value: val["nama_kat"],
                      child: Text(val["nama_kat"]),
                    )).toList(),
              hint: Text("Pilih Kategori"),
              onChanged: ((String newVal) {
                setState(() {
                  _itemSelected = newVal;
                  print(_itemSelected);
                });
              }),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Sub Kategori"),
            DropdownButton(
              value: _itemSubKat,
              items: subKategori.map((val) => DropdownMenuItem<String>(
                      value: val["nama_subkat"],
                      child: Text(val["nama_subkat"]),
                    ))
                .toList(),
              hint: Text("Pilih Sub Kategori"),
              onChanged: ((String newVal) {
                setState(() {
                  _itemSubKat = newVal;
                  print(_itemSubKat);
                });
              }),
            )
          ],
        ),
        TextFormField(
          controller: _namaProduk,
          validator: (String val) {
            if (val.isEmpty) {
              return "Nama Produk kosong";
            }

            return null;
          },
          onChanged: (String val){
            _buatKodeProduk(_itemSelected, val);
          },
          decoration: InputDecoration(
              labelText: "Nama Produk", hintText: "Masukan nama produk"),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _kodeProduk,
          validator: (String val) {
            if (val.isEmpty) {
              return "Kode Produk kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Kode Produk", hintText: "Masukan kode produk"),
        ),
        SizedBox(
          height: 15,
        ),


        TextFormField(
          controller: _noProduk,
          keyboardType: TextInputType.number,
          validator: (String val) {
            if (val.isEmpty) {
              return "Nomor Produk kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Nomor Produk", hintText: "Masukan nomor produk"),
        ),
        SizedBox(
          height: 15,
        ),
         TextFormField(
          controller: _stokProduk,
          keyboardType: TextInputType.number,
          validator: (String val) {
            if (val.isEmpty) {
              return "Stok Produk kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Stok Produk", hintText: "Masukan Stok produk"),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _hargaProduk,
          keyboardType: TextInputType.number,
          validator: (String val) {
            if (val.isEmpty) {
              return "Harga Produk kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Harga Produk", hintText: "Masukan harga produk"),
        ),
        SizedBox(
          height: 15,
        ),

        TextFormField(
          controller: _deskProduk,
          validator: (String val) {
            if (val.isEmpty) {
              return "Deskripsi Produk kosong";
            }

            return null;
          },
          decoration: InputDecoration(
              labelText: "Deskripsi Produk", hintText: "Masukan Deskripsi produk"),
          maxLines: 3,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _fileProduk == null
                ? Text("Pilih foto...")
                : Container(
                    width: 200,
                    height: 150,
                    child: Image.file(_fileProduk),
                  ),
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () => _ambilFotoProduk())
          ],
        ),
        SizedBox(
          height: 15,
        ),
        OutlineButton(
          child: Text("Simpan"),
          onPressed: () => _addProduk(_fileProduk),
        )
      ],
    );
  }
}
