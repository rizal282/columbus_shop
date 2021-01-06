import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FormEditProduk extends StatefulWidget {
  final List listEditProduk;

  FormEditProduk({this.listEditProduk});
  @override
  _FormEditProdukState createState() => _FormEditProdukState();
}

class _FormEditProdukState extends State<FormEditProduk> {
  GlobalKey<FormState> _formEditProduk = GlobalKey<FormState>();
  String url = MyUrl().getUrlDevice();
  String _itemSelected ;
  final _kodeProduk = new TextEditingController();
  final _namaProduk = new TextEditingController();
  final _noProduk = new TextEditingController();
  final _hargaProduk = new TextEditingController();
  final _deskProduk = new TextEditingController();

  static const menuItems = <String>[
    "Furniture",
    "Elektronik",
  ];

  final List<DropdownMenuItem<String>> _dropdowMenuItems = menuItems
      .map((String val) => DropdownMenuItem<String>(
    value: val,
    child: Text(val),
  ))
      .toList();

  void _setValForm() {
    _kodeProduk.text = widget.listEditProduk[0]["kode_produk"];
    _namaProduk.text = widget.listEditProduk[0]["nama_produk"];
    _itemSelected = widget.listEditProduk[0]["kategori"];
    _noProduk.text = widget.listEditProduk[0]["no_produk"];
    _hargaProduk.text = widget.listEditProduk[0]["harga"];
    _deskProduk.text = widget.listEditProduk[0]["deskripsi"];
  }

  void _prosesEditProduk() async {
    var res = await http.post("$url/columbus/admin/proseseditproduk.php", body: {
      "idproduk" : widget.listEditProduk[0]["id_produk"],
      "kodeproduk" : _kodeProduk.text,
      "namaproduk" : _namaProduk.text,
      "kategori" : _itemSelected,
      "noproduk" : _noProduk.text,
      "hargaproduk" : _hargaProduk.text,
      "deskproduk" : _deskProduk.text
    });

    Fluttertoast.showToast(
      msg: "Data Produk sudah diupdate",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM
    );

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _setValForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formEditProduk,
        child: Column(
          children: <Widget>[
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
              controller: _namaProduk,
              validator: (String val) {
                if (val.isEmpty) {
                  return "Nama Produk kosong";
                }

                return null;
              },
              decoration: InputDecoration(
                  labelText: "Nama Produk", hintText: "Masukan nama produk"),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Kategori"),
                DropdownButton(
                  value: _itemSelected,
                  items: _dropdowMenuItems,
                  hint: Text("Pilih"),
                  onChanged: ((String newVal) {
                    setState(() {
                      _itemSelected = newVal;
                    });
                  }),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _noProduk,
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
              controller: _hargaProduk,
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

            OutlineButton(
              child: Text("Simpan"),
              onPressed: () => _prosesEditProduk(),
            )
          ],
        ),
      ),
    );
  }
}
