import 'dart:convert';

import 'package:columbus_shop/admin/homeadmin.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:columbus_shop/lupapassword.dart';
import 'package:columbus_shop/pembeli/homepembeli.dart';
import 'package:columbus_shop/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomorHp = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  String url = MyUrl().getUrlDevice();
  String idUser, namaUser, statusUser, noHp;

  // proses login user
  void _loginUser() async {

    // ambil data user
    var response = await http.post("$url/columbus/loginuser.php", body: {
      "no_hp" : _nomorHp.text,
      "password" : _password.text
    });

    List dataUser = jsonDecode(response.body);

    if(dataUser.length == 0){
      // jika user tidak ditemukan
      Fluttertoast.showToast(
        msg: "User tidak ada",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER
      );
    }else{
      // jika user ada
      setState(() {
        idUser = dataUser[0]["id_user"];
        namaUser = dataUser[0]["nama_lengkap"];
        statusUser = dataUser[0]["status"];
        noHp = dataUser[0]["no_hp"];
      });

      statusUser == "Admin"
      ?// alihkan ke admin jika status admin 
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homeadmin(idAdmin: idUser, userName: namaUser, statusUser: statusUser, noHp: noHp,)))
      :
      // alihkan ke pembeli jika status pembeli
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePembeli(idPembeli: idUser, userName: namaUser, statusUser: statusUser, noHp: noHp,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login User"),
        centerTitle: true,
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
                Icons.person,
                size: 90,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.orangeAccent),
            ),
            SizedBox(
              height: 20,
            ),
            _formElement(),
          ],
        ),
      ),
    );
  }


  // komponen form login user
  Widget _formElement() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nomorHp,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Nomor HP",
              hintText: "Masukan Nomor HP",
            ),
            validator: (String val) {
              if (val.isEmpty) {
                return "Nomor HP atau Username Belum Diisi";
              }

              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Masukan Password",
            ),
            validator: (String val) {
              if (val.isEmpty) {
                return "Password Belum Diisi";
              }

              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
                      child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LupaPassword())
                    ),
                    child: Center(
                      child: Text("*Lupa Password"),
                    )),
                Card(
                  elevation: 4,
                  color: Colors.red,
                  child: Container(
                    width: 150,
                    height: 50,
                    child: InkWell(
                      splashColor: Colors.white,
                      child: Center(
                          child: Text(
                        "Masuk",
                        style: TextStyle(color: Colors.white),
                      )),
                      onTap: () => _loginUser(),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),

          Center(
            child: FlatButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Register())
                  ),
                  child: Center(
                    child: Text("Register"),
                  )),
          )
        ],
      ),
    );
  }
}
