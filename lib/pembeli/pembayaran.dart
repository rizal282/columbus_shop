import 'dart:io';
import 'package:async/async.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Pembayaran extends StatefulWidget {
  final String idBeli;

  const Pembayaran({Key key, this.idBeli}) : super(key: key);
  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  File _fileTransaksi;
  String myUrl = MyUrl().getUrlDevice();
  String tgl = DateTime.now().toString(); // ubah tipe tanggal ke string

  // untuk mengambil foto bukti transfer dari galeri
  void _ambilFotoGaleri() async {
    // ignore: deprecated_member_use
    var _fileFoto = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      _fileTransaksi = _fileFoto;
    });
  }

  // untuk mengambil foto bukti transfer dari kamera
  void _ambilFotoKamera() async {
    // ignore: deprecated_member_use
    var _fileFoto = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    setState(() {
      _fileTransaksi = _fileFoto;
    });
  }

  // untuk memproses pembayaran dengan mengupload bukti transfer
  void _uploadPembayaran(File file) async {
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var url = Uri.parse("$myUrl/columbus/uploadpembayaran.php");

    var request = http.MultipartRequest("POST", url);
    var multipartFile = http.MultipartFile("bayar", stream, length, filename: basename(file.path)); // proses upload foto

    var splitTgl = tgl.split(" ");

    request.fields["id_beli"] = widget.idBeli;
    request.fields["tanggal"] = splitTgl[0];
    request.files.add(multipartFile);

    var result = await request.send();

    if(result.statusCode == 200){
      // jika berhasil upload
      Fluttertoast.showToast(
        msg: "Pembayaran berhasil",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT
      );
    }else{
      // jika gagal upload
      Fluttertoast.showToast(
          msg: "Pembayaran Gagal",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }
  

  // tampilan untuk proses upload bukti pembayaran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.camera), onPressed: () => _ambilFotoKamera()),
          IconButton(icon: Icon(Icons.image), onPressed: () => _ambilFotoGaleri()),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _fileTransaksi == null
              ? Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30,),
                    Center(child: Text("Jika Anda ingin beli barang tersebut \nmaka silahkan transfer ke \nNo.Rekening 2310431403 \nBank BCA a/n Adironi Gulo \natau hubungi kami 081381613148", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),)),
                    SizedBox(height: 30,),
                    Center(child: Text("Pilih atau ambil foto"),),
                  ],
                ),
              )
                  : Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: Image.file(_fileTransaksi),
              ),
              SizedBox(height: 20,),

              // tombol untuk upload bukti pembayaran
              Card(
                elevation: 4,
                color: Colors.redAccent[700],
                child: Container(
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      _uploadPembayaran(_fileTransaksi);
                      Navigator.of(context).pop();
                    },
                    child: Center(child: Text("Upload Bukti Pembayaran", style: TextStyle(color: Colors.white, fontSize: 17),),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
