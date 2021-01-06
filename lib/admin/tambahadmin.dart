import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TambahAdmin extends StatefulWidget {
  @override
  _TambahAdminState createState() => _TambahAdminState();
}

class _TambahAdminState extends State<TambahAdmin> {
  String url = MyUrl().getUrlDevice();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _namaLengkap = new TextEditingController();
  final _noHp = new TextEditingController();
  final _alamat = new TextEditingController();
  final _password = new TextEditingController();

  void tambahAdmin() async {
    if (_formKey.currentState.validate()) {
      var respons =
          await http.post("$url/columbus/admin/tambahadmin.php", body: {
        "namaLengkap": _namaLengkap.text,
        "noHp": _noHp.text,
        "alamat": _alamat.text,
        "password": _password.text
      });

      if (respons.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Admin Baru Sudah Ditambahkan",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);
        
        resetForm();
      } else {
        Fluttertoast.showToast(
            msg: "Admin Baru Gagal Ditambahkan",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);
        
        resetForm();
      }
    }
  }

  void resetForm(){
    _namaLengkap.text = "";
    _noHp.text = "";
    _alamat.text = "";
    _password.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Admin"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: formAdmin(),
        ),
      ),
    );
  }

  Widget formAdmin() {
    return ListView(
      children: [
        TextFormField(
          controller: _namaLengkap,
          validator: (String val){
            if(val.isEmpty){
              return "Nama Lengkap Masih Kosong";
            }

            return null;
          },
          decoration: InputDecoration(
            labelText: "Nama Lengkap",
            hintText: "Masukan Nama Lengkap",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _noHp,
          validator: (String val){
            if(val.isEmpty){
              return "Nomor HP Masih Kosong";
            }

            return null;
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Nomor HP",
            hintText: "Masukan Nomor HP",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _alamat,
          validator: (String val){
            if(val.isEmpty){
              return "Alamat Masih Kosong";
            }

            return null;
          },
          decoration: InputDecoration(
            labelText: "Alamat",
            hintText: "Masukan Alamat",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _password,
          validator: (String val){
            if(val.isEmpty){
              return "Password Masih Kosong";
            }

            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Masukan Password",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        OutlineButton(
          onPressed: () => tambahAdmin(),
          child: Text("Simpan"),
        )
      ],
    );
  }
}
