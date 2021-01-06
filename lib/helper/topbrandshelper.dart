// ini adalah class yang berfungsi untuk mengkonversi data array dari php ke data array flutter
// kemudian, setelah dari data array flutter dipecah ke data string biasa

class Topbrandshelper {

  // set variable untuk menampung element data dari array
  int id;
  String _kodeproduk;
  String _namaproduk;
  String _kategori;
  String _noproduk;
  String _harga;
  String _foto;

  // ini adalah konstruktor untuk set data variable yang dibuat diatas
  Topbrandshelper(this._kodeproduk, this._namaproduk, this._kategori, this._noproduk, this._harga, this._foto);

  // memecah data array ke dalam masing2 variable
  Topbrandshelper.fromJson(dynamic obj){
    this._kodeproduk = obj["kode_produk"];
    this._namaproduk = obj["nama_produk"];
    this._kategori = obj["kategori"];
    this._noproduk = obj["no_produk"];
    this._foto = obj["harga"];
    this._foto = obj["foto"];
  }

  // mengakses variable
  String get kodeproduk => _kodeproduk;
  String get namaproduk => _namaproduk;
  String get kategori => _kategori;
  String get noproduk => _noproduk;
  String get harga => _harga;
  String get foto => _foto;

  // setting id data
  void setId(int id){
    this.id = id;
  }
}