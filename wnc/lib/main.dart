import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wnc/app/controllers/auth_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/loading_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapAuth) {
          if (snapAuth.connectionState == ConnectionState.waiting)
            return const LoadingScreen();
          return GetMaterialApp(
            theme: ThemeData(
              textTheme: const TextTheme(
                titleMedium: TextStyle(
                  color: Color(0xFFFEF9FF),
                ),
                bodyMedium: TextStyle(
                  color: Color(0xFFFEF9FF),
                ),
              ),
              scaffoldBackgroundColor: const Color(0xFF0c6291),
              appBarTheme: const AppBarTheme(
                foregroundColor: Color(0xFFFEF9FF),
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                // text: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFEF9FF),
                  ),
                ),
                suffixIconColor: Color(0xFFFEF9FF),
                labelStyle: TextStyle(
                  color: Color(0xFFFEF9FF),
                ),
                helperStyle: TextStyle(
                  color: Color(0xFFFEF9FF),
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFFEF9FF),
                foregroundColor: Color(0xFF0c6291),
              ),
              elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Color(0xFFFEF9FF)),
                  foregroundColor:
                      MaterialStatePropertyAll<Color>(Color(0xFF0c6291)),
                  elevation: MaterialStatePropertyAll(5),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            title: "QR Code",
            initialRoute: snapAuth.hasData ? Routes.home : Routes.login,
            getPages: AppPages.routes,
          );
        });
  }
}
