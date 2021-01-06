import 'dart:convert';

import 'package:columbus_shop/admin/tambahadmin.dart';
import 'package:columbus_shop/helperurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataAdmin extends StatefulWidget {
  @override
  _DataAdminState createState() => _DataAdminState();
}

class _DataAdminState extends State<DataAdmin> {
  String url = MyUrl().getUrlDevice();
  List dataAdmin = List();

  void ambilDataAdmin() async {
    var result = await http.get("$url/columbus/admin/ambildataadmin.php");

    var listDataAdmin = json.decode(result.body);

    setState(() {
      dataAdmin = listDataAdmin;
    });
  }

  @override
  void initState() {
    ambilDataAdmin();
    super.initState();
  }

  SingleChildScrollView _tableAdmin(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("Nama Admin")),
            DataColumn(label: Text("No HP")),
            DataColumn(label: Text("Alamat")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Edit")),
            DataColumn(label: Text("Hapus")),
          ], 
          rows: dataAdmin.map((item) => DataRow(cells: <DataCell>[
            DataCell(Text(item["nama_lengkap"])),
            DataCell(Text(item["no_hp"])),
            DataCell(Text(item["alamat"])),
            DataCell(Text(item["status"])),
            DataCell(
              OutlineButton(
                child: Icon(Icons.edit),
                onPressed: (){},
              )
            ),
            DataCell(OutlineButton(
                child: Icon(Icons.delete),
                onPressed: (){},
              )),
          ])).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Admin"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: _tableAdmin(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TambahAdmin())
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}