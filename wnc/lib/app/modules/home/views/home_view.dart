import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:wnc/app/controllers/auth_controller.dart';
import 'package:wnc/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Color(0xFF0c6291),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              title: const Text(
                'Home',
                // style: TextStyle(color: Color(0xFFFEF9FF)),
              ),
              centerTitle: true,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
            itemCount: 4,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              late String title;
              late IconData icon;
              late VoidCallback onTap;

              switch (index) {
                case 0:
                  title = "Add Product";
                  icon = Icons.post_add_rounded;
                  onTap = () => Get.toNamed(Routes.addProduct);
                  break;
                case 1:
                  title = "Products";
                  icon = Icons.list_alt_outlined;
                  onTap = () => Get.toNamed(Routes.products);
                  break;
                case 2:
                  title = "QR Code";
                  icon = Icons.qr_code;
                  onTap = () async {
                    String barcode = await FlutterBarcodeScanner.scanBarcode(
                      "#000000",
                      "Cancel",
                      true,
                      ScanMode.QR,
                    );

                    Map<String, dynamic> hasil =
                        await controller.getProductById(barcode);
                    if (hasil["error"] == false) {
                      Get.toNamed(Routes.detailProduct,
                          arguments: hasil["data"]);
                    } else {
                      Get.snackbar(
                        "Error",
                        hasil["message"],
                        duration: const Duration(seconds: 2),
                      );
                    }
                  };
                  break;
                case 3:
                  title = "Catalog";
                  icon = Icons.document_scanner_outlined;
                  onTap = () {
                    controller.downloadCatalog();
                  };
                  break;
              }

              return Material(
                color: const Color(0xFFFEF9FF),
                borderRadius: BorderRadius.circular(9),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(
                          icon,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await authC.logout();
          if (hasil["error"] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar("Error", hasil["message"]);
          }
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
