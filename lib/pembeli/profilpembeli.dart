import 'dart:convert';

import 'package:columbus_shop/helperurl.dart';
import 'package:columbus_shop/pembeli/updateprofil.dart';
import 'package:columbus_shop/pembeli/uploadfotoprofil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilPembeli extends StatefulWidget {
  final String idUser;
  
  ProfilPembeli({this.idUser});
  @override
  _ProfilPembeliState createState() => _ProfilPembeliState();
}

class _ProfilPembeliState extends State<ProfilPembeli> {
  String url = MyUrl().getUrlDevice();
  List _dataFoto = List();

  // mengambil data user pembeli
  Future<List> _getDataUser() async {
    var result = await http.post("$url/columbus/profilpembeli.php", body: {
      "id_user" : widget.idUser,
    });
    
    return jsonDecode(result.body);
  }

  // mengambil foto profil pembeli jika ada
  void _getDataFoto() async {
    var result = await http.post("$url/columbus/fotouser.php", body: {
      "id_user" : widget.idUser
    });

    setState(() {
      _dataFoto = jsonDecode(result.body);
    });
  }

  @override
  void initState() {
    _getDataUser();
    _getDataFoto();
    super.initState();
  }

  // tampilan ui profil pembeli
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Anda"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _getDataUser(),
          builder: (context, snapshot){
            if(snapshot.hasData)
              return ViewProfil(dataUser: snapshot.data, dataFoto: _dataFoto,);

            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}

//detail tampilan profil pembeli
class ViewProfil extends StatelessWidget {
  final List dataUser;
  final List dataFoto;
  
  String url = MyUrl().getUrlDevice();

  ViewProfil({this.dataUser, this.dataFoto});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          dataFoto.length == 0
          ? Container(
              width: 200,
              height: 200,
              child: Center(child: Text("Tidak ada foto"),),)
              : Container(
                width: 200,
                height: 200,
                child: Image.network("$url/columbus/fotouser/${dataFoto[0]["file_foto"]}")),
          SizedBox(height: 20,),
          FlatButton(
            child: Text("Ganti Foto Profil"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UploadProfil(idUser: dataUser[0]["id_user"],))
            ),
          ),
          SizedBox(height: 20,),
          Card(
            elevation: 4,
            child: Column(
              children: <Widget>[
                ListTile(title: Text("Nama : ${dataUser[0]["nama_lengkap"]}"),),
                ListTile(title: Text("No Telepon : ${dataUser[0]["no_hp"]}"),),
                ListTile(title: Text("Alamat : ${dataUser[0]["alamat"]}"),),
                ListTile(title: Text("Sebagai : ${dataUser[0]["status"]}"),),
              ],
            ),
          ),
          SizedBox(height: 20,),
          FlatButton(
            child: Text("Update Profil"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Updateprofil(
                idUser: dataUser[0]["id_user"],
                namaUser: dataUser[0]["nama_lengkap"],
                noTelp: dataUser[0]["no_hp"],
                alamat: dataUser[0]["alamat"],
              ))
            ),
          ),
        ],
      ),
    );
  }
}

