import 'package:columbus_shop/helperurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditKategori extends StatefulWidget {
  final String idkat, namakat;

  const EditKategori({Key key, this.idkat, this.namakat}) : super(key: key);
  @override
  _EditKategoriState createState() => _EditKategoriState();
}

class _EditKategoriState extends State<EditKategori> {
  String url = MyUrl().getUrlDevice();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaKategori = new TextEditingController();

  void editKategori() async {
    var result = await http.post("$url/columbus/admin/editkategori.php", body: {
      "idkategori" : widget.idkat,
      "nama_kat" : _namaKategori.text
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Data Kategori Diedit",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );
    }else{
      Fluttertoast.showToast(
          msg: "Gagal Mengedit",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  @override
  void initState() {
    _namaKategori.text = widget.namakat;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Kategori"),
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
                onPressed: () => editKategori(),
                child: Text("Edit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
