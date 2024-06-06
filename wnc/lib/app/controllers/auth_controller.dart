import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  String? uid; // untuk cek autentikasi adakah user login atau tidak
  // kalau null berarti tidak ada user sedang login
  // kalau ada data user berarti ada user sedang login

  late FirebaseAuth auth;

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);

      return {"error": false, "message": "Berhasil daftar"};
    } on FirebaseException catch (e) {
      return {
        "error": true,
        "message": "${e.message}",
      }; // error bawaan firebase
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat daftar",
      }; // catch error general
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      return {"error": false, "message": "Berhasil login"};
    } on FirebaseException catch (e) {
      return {
        "error": true,
        "message": "${e.message}",
      }; // error bawaan firebase
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat login",
      }; // catch error general
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await auth.signOut();

      return {
        "error": false,
        "message": "Berhasil logout",
      };
    } on FirebaseException catch (e) {
      return {
        "error": true,
        "message": "${e.message}",
      }; // error bawaan firebase
    } catch (e) {
      return {
        "error": true,
        "message": "tidak dapat logout",
      }; // catch error general
    }
  }

  @override
  void onInit() {
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });

    super.onInit();
  }
}
