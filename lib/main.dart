import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/error_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/class.dart';

User? user;
bool? isloggin;
loadApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString("email");
  String? password = prefs.getString("password");
  String? token = prefs.getString("token");
  if (email != null && password != null && token != null) {
    try {
      Dio dio = Dio();
      String url = "https://api.eskanist.com/public/api/login";
      dio.options.headers["Content-Type"] = "application/json";
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };
      Response response = await dio.post(url, data: data);
      if (response.data["success"] == true) {
        user = User(
          token: response.data["token"],
          name: response.data["name"], 
          email: response.data["email"], 
          phone: response.data["phone"], 
          adress: response.data["adress"], 
          create: response.data["created_at"], 
          update: response.data["updated_at"],
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        await prefs.setString("password", password);
        await prefs.setString("token", response.data["token"]);
        isloggin = true;
      }
      else {
        isloggin = false;
      }
    } catch (e) {
      print("Beklenmeyen bir hata oluştu");
    }
  }
  else {
    isloggin = false;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadApp().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light().copyWith(primary: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
          ),
        ),
      ),
      home: isloggin == true ? HomePage(user: user!) : (isloggin == false ? LoginPage() : ErrorPage()),
    );
  }
}