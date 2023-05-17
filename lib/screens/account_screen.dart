import 'package:flutter/material.dart';
import '../utils/class.dart';

class AccountPage extends StatefulWidget {
  final User user;
  const AccountPage({super.key, required this.user});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesabım"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              iconColor: Colors.black,
              leading: Container(height: double.infinity, child: Icon(Icons.account_circle_outlined, size: 28)),
              title: const Text('Kullanıcı adı'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${widget.user.name ?? "Belirtilmedi"}'),
              ),
            ),
            ListTile(
              iconColor: Colors.black,
              leading: Container(height: double.infinity, child: Icon(Icons.mail_outline_rounded, size: 28)),
              title: const Text('E-Mail'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${widget.user.email ?? "Belirtilmedi"}'),
              ),
            ),
            ListTile(
              iconColor: Colors.black,
              leading: Container(height: double.infinity, child: Icon(Icons.account_circle_outlined, size: 28)),
              title: const Text('Telefon'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${widget.user.phone ?? "Belirtilmedi"}'),
              ),
            ),
            ListTile(
              iconColor: Colors.black,
              leading: Container(height: double.infinity, child: Icon(Icons.location_on_outlined, size: 28)),
              title: const Text('Adres'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${widget.user.adress ?? "Belirtilmedi"}'),
              ),
            ),
            ListTile(
              iconColor: Colors.black,
              leading: Container(height: double.infinity, child: Icon(Icons.date_range_outlined, size: 28)),
              title: const Text('Hesap oluşturma tarihi'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${DateTime.tryParse(widget.user.create!) ?? "Belirtilmedi"}'),
              ),
            ),
            ListTile(
              iconColor: Colors.black,
              leading: Container(height: double.infinity, child: Icon(Icons.update_outlined, size: 28)),
              title: const Text('Hesap güncelleme tarihi'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${DateTime.tryParse(widget.user.update!) ?? "Belirtilmedi"}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}