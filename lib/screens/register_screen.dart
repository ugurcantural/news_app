import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/class.dart';
import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool loading = false;

  register({required String name, required String email, required String password, required String conpassword}) async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      String url = "https://api.qline.app/api/register";
      dio.options.headers["Content-Type"] = "application/json";
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "confirm_password": conpassword,
      };
      Response response = await dio.post(url, data: data);
      if (response.data["success"] == true) {
        User user = User(
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
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage(user: user);
        }));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Giriş yapılamadı! ${response.data["msg"]}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Beklenmeyen bir hata oluştu! $e")));
    }
    setState(() {
      loading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _conpasswordController = TextEditingController();

  bool obsurepass = true;
  bool obsureconpass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                loading ? CircularProgressIndicator() : SizedBox(),
                SizedBox(height: 10),
                Text(
                  "Kayıt Ol",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Lütfen devam etmek için kayıt olun.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _nameController,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) => TextFieldValidator.nameControl(value),
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        color: Colors.black,
                        Icons.account_circle_outlined,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "NAME",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _emailController,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) => TextFieldValidator.mailControl(value),
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        color: Colors.black,
                        Icons.mail_outlined,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "EMAIL",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) => TextFieldValidator.passControl(value),
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        color: Colors.black,
                        Icons.vpn_key_outlined,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "PAROLA",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Icon(obsurepass ? Icons.remove_red_eye_outlined : Icons.remove_red_eye, size: 32),
                            onTap: () {
                              setState(() {
                                obsurepass =! obsurepass;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    obscureText: obsurepass,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _conpasswordController,
                    // onChanged: (value) {
                    //   _formKey.currentState!.validate();
                    // },
                    validator: (value) => TextFieldValidator.passControl(value),
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        color: Colors.black,
                        Icons.vpn_key_outlined,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "PAROLA TEKRAR",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Icon(obsureconpass ? Icons.remove_red_eye_outlined : Icons.remove_red_eye, size: 32),
                            onTap: () {
                              setState(() {
                                obsureconpass =! obsureconpass;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    obscureText: obsureconpass,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordController.text != _conpasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2), content: Text("Parola eşleşme hatası!")));
                              }
                              else {
                                register(name: _nameController.text, email: _emailController.text, password: _passwordController.text, conpassword: _conpasswordController.text);
                              }
                            }
                          },
                          child: Text("Kayıt ol"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}