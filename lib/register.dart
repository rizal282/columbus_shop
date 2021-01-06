import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String url = MyUrl().getUrlDevice();
  final _namaLengkap = new TextEditingController();
  final _nomorHp = new TextEditingController();
  final _alamat = new TextEditingController();
  final _password = new TextEditingController();

  void _registerPembeli() async {
    if(_formKey.currentState.validate()){
      var cekuser = await http.post("$url/columbus/cekregister.php", body: {
        "nomorHp" : _nomorHp.text,
      });

      var datauser = jsonDecode(cekuser.body);

      if(datauser.length == 1){
        Fluttertoast.showToast(
          msg: "Nomor HP ini sudah digunakan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
        );
      }else{
        var response = await http.post("$url/columbus/registerpembeli.php", body: {
          "namalengkap" : _namaLengkap.text,
          "nomorhp" : _nomorHp.text,
          "alamat" : _alamat.text,
          "password" : _password.text
        });

        hapusForm();

        if(response.statusCode == 200){
          Fluttertoast.showToast(
              msg: "Akun user Anda sudah dibuat, silahkan login",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );

          Navigator.of(context).pop();
        }
      }
    }
  }

  void hapusForm() {
    _namaLengkap.clear();
    _nomorHp.clear();
    _alamat.clear();
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Pembeli"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              height: 150,
              child: Icon(
                Icons.person_add,
                size: 90,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.orangeAccent),
            ),
            SizedBox(
              height: 20,
            ),
            _formRegister(),
          ],
        ),
      ),
    );
  }

  Widget _formRegister() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _namaLengkap,
            validator: (String val){
              if(val.isEmpty){
                return "Nama lengkap tidak boleh kosong";
              }

              return null;
            },
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              hintText: "Masukan Nama Lengkap",
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: _nomorHp,
            keyboardType: TextInputType.number,
            validator: (String val){
              if(val.isEmpty){
                return "Nomor HP tidak boleh kosong";
              }

              return null;
            },
            decoration: InputDecoration(
              labelText: "Nomor HP",
              hintText: "Masukan Nomor HP",
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: _alamat,
            validator: (String val){
              if(val.isEmpty){
                return "Alamat tidak boleh kosong";
              }

              return null;
            },
            decoration: InputDecoration(
              labelText: "Alamat",
              hintText: "Masukan Alamat",
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: _password,
            validator: (String val){
              if(val.isEmpty){
                return "Password tidak boleh kosong";
              }

              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Masukan Password",
            ),
          ),
          SizedBox(height: 20,),
          Card(
                elevation: 4,
                color: Colors.red,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.white,
                    child: Center(
                        child: Text(
                      "Daftar",
                      style: TextStyle(color: Colors.white),
                    )),
                    onTap: () => _registerPembeli(),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
