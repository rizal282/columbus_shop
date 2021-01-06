import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LupaPassword extends StatefulWidget {
  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  String url = MyUrl().getUrlDevice();

  // variable untuk menangkap input dari user
  final _nomorHp = new TextEditingController();

  void resetPasswordUser() async {
    // cek apakah nomor hp sudah dimasukan
    if(_nomorHp.text == "" || _nomorHp.text == null){
      Fluttertoast.showToast(
          msg: "Nomor HP belum dimasukan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }else{
      var response = await http.post("$url/columbus/resetpassword.php", body: {
        "nomorHp" : _nomorHp.text
      });

      if(response.statusCode == 200){
        Fluttertoast.showToast(
            msg: "Password Anda sudah direset ke 1234",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );

        Navigator.of(context).pop();
      }else{
        Fluttertoast.showToast(
            msg: "Gagal reset Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Reset Password Anda"),
            Text("Masukan Nomor HP Anda dibawah ini"),
            TextFormField(
              controller: _nomorHp,
              decoration: InputDecoration(
                labelText: "Nomor HP",
                hintText: "Masukan nomor HP Anda"
              ),
            ),
            OutlineButton(
                onPressed: () => resetPasswordUser(),
                child: Text("Reset"))
          ],
        ),
      ),
    );
  }
}
