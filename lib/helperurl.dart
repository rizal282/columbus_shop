class MyUrl {
  // url device jika dijalankan di smartphone android
 // String _urlDevice = "http://192.168.43.171";

  // url device jika dijalankan di emulator android
//  String _urlDevice = "http://10.0.2.2";

  // ip address wifi
  String _urlDevice = "http://192.168.1.4";

  String getUrlDevice(){
    return this._urlDevice;
  }

}