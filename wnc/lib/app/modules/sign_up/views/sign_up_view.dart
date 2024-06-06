import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  SignUpView({Key? key}) : super(key: key);

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            TextField(
              autocorrect: false,
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => TextField(
                autocorrect: false,
                controller: passC,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.isHidden.toggle();
                    },
                    icon: Icon(controller.isHidden.isFalse
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> hasil = await authC.signup(emailC.text,
                        passC.text); //Tangkap mappingan method login
                    controller.isLoading(false);

                    if (hasil["error"] == true) {
                      Get.snackbar("Error", hasil["message"]);
                    } else {
                      Get.offAllNamed(Routes.home);
                    }
                  } else {
                    Get.snackbar("Error", "Email dan Password wajib diisi");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  )),
              child: Obx(() => Text(
                  controller.isLoading.isFalse ? "Sign Up" : "Loading...")),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun?"),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.login);
                  },
                  child: const Text("Masuk disini"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
