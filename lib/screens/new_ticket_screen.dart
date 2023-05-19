import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/tickets_screen.dart';
import 'package:news_app/utils/class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTicketPage extends StatefulWidget {
  const NewTicketPage({super.key});

  @override
  State<NewTicketPage> createState() => _NewTicketPageState();
}

class _NewTicketPageState extends State<NewTicketPage> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String _selectedItem = 'Haber İçerik';
  List<String> _dropdownItems = ['Haber İçerik', 'Haber Konusu', 'Haber Destek', 'Haber Diğer', 'Öneri ve Şikayet'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Ticket"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              loading ? CircularProgressIndicator() : SizedBox(),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    alignment: Alignment.center,
                    items: _dropdownItems.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item),
                        ],
                      ),
                    )).toList(),
                    value: _selectedItem,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _titleController,
                  validator: (value) => TextFieldValidator.ticketControl(value, 10),
                  maxLength: 20,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      color: Colors.black,
                      Icons.title_outlined,
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
                    labelText: "Konu Başlığı",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _messageController,
                  validator: (value) => TextFieldValidator.ticketControl(value, 20),
                  maxLines: 5,
                  maxLength: 140,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      color: Colors.black,
                      Icons.message_outlined,
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
                    labelText: "Mesajınız",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Text("Mesaj gönderilsin mi?", textAlign: TextAlign.center),
                          contentTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                          actions: [
                             TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child: Text("Vazgeç"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  Dio dio = Dio();
                                  String url = "https://api.eskanist.com/public/api/tickets";
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String? token = prefs.getString("token");
                                  dio.options.headers.addAll({
                                    "authorization": "Bearer $token",
                                    "Content-Type": "application/json",
                                  });
                                  Map<String, dynamic> data = {
                                    "title": _titleController.text,
                                    "message": _messageController.text,
                                    "topic": _selectedItem,
                                  };
                                  Response response = await dio.post(url, data: data);
                                  if (response.data["success"] == true) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                     return TicketPage(); 
                                    }));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj başarıyla gönderildi!")));
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj gönderilirken bir hata oluştu! ${response.data["msg"]}")));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj gönderilirken bir hata oluştu! $e")));
                                }
                                setState(() {
                                  loading = false;
                                });
                              }, 
                              child: Text("Gönder"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text("Gönder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}