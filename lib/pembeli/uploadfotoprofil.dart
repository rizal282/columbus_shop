import 'dart:io';
import 'package:async/async.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UploadProfil extends StatefulWidget {
  final String idUser;

  const UploadProfil({Key key, this.idUser}) : super(key: key);
  @override
  _UploadProfilState createState() => _UploadProfilState();
}

class _UploadProfilState extends State<UploadProfil> {
  String myurl = MyUrl().getUrlDevice();
  File _fileFoto;
  
  void _pickFromCamera() async {
    var foto = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _fileFoto = foto;
    });
  }

  void _pickFromGallery() async {
    var foto = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _fileFoto = foto;
    });
  }

  void _uploadFoto(File file) async {
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var url = Uri.parse("$myurl/columbus/uploadfotouser.php");

    var request = http.MultipartRequest("POST", url);
    var multipartFile = http.MultipartFile("fotoprofil", stream, length, filename: basename(file.path));

    request.fields["idUser"] = widget.idUser;
    request.files.add(multipartFile);

    var response = await request.send();

    if(response.statusCode == 200){
      Fluttertoast.showToast(
        msg: "Foto profil berhasil diupload",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT
      );
    }else{
      Fluttertoast.showToast(
          msg: "Foto profil gagal diupload",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Foto Profil"),
      ),body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            _fileFoto == null
            ? Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Center(child: Text("Pilih foto..."),),
    ) :  Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Image.file(_fileFoto),
    ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(icon: Icon(Icons.image), onPressed: () => _pickFromGallery()),
                IconButton(icon: Icon(Icons.camera), onPressed: () => _pickFromCamera()),
              ],
            ),
            SizedBox(height: 20,),
            Card(
              elevation: 4,
              color: Colors.red,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: InkWell(
                  splashColor: Colors.white,
                  child: Center(child: Text("Upload", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  onTap: () => _uploadFoto(_fileFoto),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
