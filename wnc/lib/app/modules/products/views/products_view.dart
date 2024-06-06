import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              title: const Text('Product'),
              centerTitle: true,
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProduct(),
          builder: (context, snapProduct) {
            if (snapProduct.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapProduct.data!.docs.isEmpty) {
              return const Center(
                child: Text("No products has been added yet"),
              );
            }

            List<ProductModel> allProducts = [];

            for (var element in snapProduct.data!.docs) {
              allProducts.add(ProductModel.fromJson(element.data()));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                ProductModel product = allProducts[index];
                return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.detailProduct, arguments: product);
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.code,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text(product.name,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  Text("Jumlah : ${product.qty}",
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: QrImage(
                                data: product.code,
                                size: 250,
                                version: QrVersions.auto,
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              },
            );
          }),
    );
  }
}
