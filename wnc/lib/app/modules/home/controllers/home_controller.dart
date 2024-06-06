import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/models/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  void downloadCatalog() async {
    final pdf = pw.Document();

    var getData = await firestore.collection("product").get();

    allProducts([]);

    // reset all product -> untuk mengatasi duplikat
    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData = List.generate(
            allProducts.length,
            (index) {
              ProductModel product = allProducts[index];
              return pw.TableRow(
                children: [
                  pw.Padding(
                      child: pw.Text(
                        "${index + 1}",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(20)),
                  pw.Padding(
                      child: pw.Text(
                        product.code,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(20)),
                  pw.Padding(
                      child: pw.Text(
                        product.name,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(20)),
                  pw.Padding(
                      child: pw.Text(
                        "${product.qty}",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(20)),
                  pw.Padding(
                      child: pw.BarcodeWidget(
                        color: PdfColor.fromHex("#000000"),
                        barcode: pw.Barcode.qrCode(),
                        data: product.code,
                        height: 50,
                        width: 50,
                      ),
                      padding: const pw.EdgeInsets.all(20)),
                ],
              );
            },
          );
          return [
            pw.Center(
              child: pw.Text("Catalog Product",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 24)),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                        child: pw.Text(
                          "No",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(20)),
                    pw.Padding(
                        child: pw.Text(
                          "Product Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(20)),
                    pw.Padding(
                        child: pw.Text(
                          "Product Name",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(20)),
                    pw.Padding(
                        child: pw.Text(
                          "Quantity",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(20)),
                    pw.Padding(
                        child: pw.Text(
                          "QR",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(20)),
                  ],
                ),
                ...allData,
              ],
            )
          ];
        },
      ),
    );

    //simpan
    Uint8List bytes = await pdf.save();

    //mendapatkan direktori
    final dir = await getApplicationDocumentsDirectory();

    //membuat file kosong
    final file = File('${dir.path}/myDocument.pdf');

    //memasukkan bytes ke data kosong
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getProductById(String productCode) async {
    try {
      var hasil = await firestore
          .collection("product")
          .where("code", isEqualTo: productCode)
          .get();

      if (hasil.docs.isEmpty) {
        return {"error": true, "message": "Produk ini tidak ada di database"};
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail produk dari QR Code ini",
        "data": ProductModel.fromJson(data),
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak mendapatkan detail produk dari QR Code ini"
      };
    }
  }
}
