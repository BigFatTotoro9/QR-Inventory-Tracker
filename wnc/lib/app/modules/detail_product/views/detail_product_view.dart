import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);

  final ProductModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFFFEF9FF)),
                child: QrImage(
                  data: product.code,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              labelText: "Product Code",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              labelText: "Product Name",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              labelText: "Quantity",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoadingUpdate.isFalse) {
                if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                  controller.isLoadingUpdate(true);
                  Map<String, dynamic> hasil = await controller.editProduct({
                    "id": product.productId,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoadingUpdate(false);

                  Get.snackbar(
                    hasil["error"] == true ? "Error" : "Berhasil",
                    hasil["message"],
                    duration: const Duration(seconds: 2),
                  );
                }
              } else {
                Get.snackbar("Error", "Semua data wajib diisi",
                    duration: const Duration(seconds: 2));
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: Obx(() => Text(controller.isLoadingUpdate.isFalse
                ? "Update Product"
                : "Loading...")),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Delete Product",
                middleText: "Are you sure to delete this product?",
                middleTextStyle: const TextStyle(color: Colors.black),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFFFEF9FF),
                      backgroundColor: const Color.fromARGB(255, 24, 126, 181),
                    ),
                    onPressed: () async {
                      controller.isLoadingDelete(true);
                      Map<String, dynamic> hasil =
                          await controller.deleteProduct(product.productId);
                      controller.isLoadingDelete(false);
                      Get.back(); // untuk tutup dialog
                      Get.back(); // untuk back ke product
                      Get.snackbar(
                        hasil["error"] == true ? "Error" : "Berhasil",
                        hasil["message"],
                      );
                    },
                    child: Obx(
                      () => controller.isLoadingDelete.isFalse
                          ? const Text("Delete")
                          : Container(
                              padding: const EdgeInsets.all(2),
                              height: 15,
                              width: 15,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text("Delete Product"),
          )
        ],
      ),
    );
  }
}
