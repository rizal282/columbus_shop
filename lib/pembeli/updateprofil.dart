import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Updateprofil extends StatefulWidget {
  final String idUser, namaUser, noTelp, alamat;

  const Updateprofil({Key key, this.idUser, this.namaUser, this.noTelp, this.alamat}) : super(key: key);

  @override
  _UpdateprofilState createState() => _UpdateprofilState();
}

class _UpdateprofilState extends State<Updateprofil> {
  String url = MyUrl().getUrlDevice();
  final _namaLengkap = new TextEditingController();
  final _nomorHp = new TextEditingController();
  final _alamat = new TextEditingController();

  void setValueForm() {
    _namaLengkap.text = widget.namaUser;
    _nomorHp.text = widget.noTelp;
    _alamat.text = widget.alamat;
  }

  void _updateProfil() async {
    var result = await http.post("$url/columbus/updateprofil.php", body: {
      "id_user" : widget.idUser,
      "nama_lengkap" : _namaLengkap.text,
      "no_hp" : _nomorHp.text,
      "alamat" : _alamat.text
    });

    if(result.statusCode == 200){
      Fluttertoast.showToast(
        msg: "Profil berhasil diupdate",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM
      );
    }else{
      Fluttertoast.showToast(
          msg: "Profil gagal diupdate",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  @override
  void initState() {
    setValueForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profil"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
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
                          "Update",
                          style: TextStyle(color: Colors.white),
                        )),
                    onTap: () {
                      _updateProfil();
                    },
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
