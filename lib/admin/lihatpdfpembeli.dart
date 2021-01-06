import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

// untuk melihat isi file pdf data pembeli
class LihatPdfPembeli extends StatelessWidget {
  final String path;

  const LihatPdfPembeli({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
    );
  }
}
