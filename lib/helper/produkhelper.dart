class Produkhelper {
  String id;
  String _kodeProduk;
  String _namaProduk;
  String _noProduk;
  String _harga;
  String _foto;

  Produkhelper(this._kodeProduk, this._namaProduk, this._noProduk, this._harga, this._foto);

  Produkhelper.fromMap(dynamic obj){
    this._kodeProduk = obj["kode_produk"];
    this._namaProduk = obj["nama_produk"];
    this._noProduk = obj["no_produk"];
    this._harga = obj["harga"];
    this._foto = obj["foto"];
  }

  String get kodeProduk => _kodeProduk;
  String get namaProduk => _namaProduk;
  String get noProduk => _noProduk;
  String get harga => _harga;
  String get foto => _foto;

  Map<String, dynamic> toMap() {
    var mapProduk = Map<String, dynamic>();

    mapProduk["kode_produk"] = _kodeProduk;
    mapProduk["nama_produk"] = _namaProduk;
    mapProduk["no_produk"] = _noProduk;
    mapProduk["harga"] = _harga;
    mapProduk["foto"] = _foto;

    return mapProduk;
  }

  void setIdProduk(String id){
    this.id = id;
  }
}