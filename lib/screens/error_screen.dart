import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hata"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Beklenmeyen bir hata oluştu!"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {},
              child: Text("Favori ekle"),
            ),
          ],
        ),
      ),
    );
  }
}