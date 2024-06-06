import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passC = TextEditingController(text: "admin123");

  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      //   title: const Text('Login'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  "Login",
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
                style: const TextStyle(
                  color: Color(0xFFFEF9FF),
                ),
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
                    Map<String, dynamic> hasil =
                        await authC.login(emailC.text, passC.text);
                    Get.snackbar("Pemberitahuan",
                        "Login berhasil"); //Tangkap mappingan method login
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
                ),
              ),
              child: Obx(() =>
                  Text(controller.isLoading.isFalse ? "Login" : "Loading...")),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Belum punya akun?",
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.signUp);
                  },
                  child: const Text("Daftar disini"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
