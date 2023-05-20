// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/class.dart';
import 'tickets_screen.dart';

class TicketDetailPage extends StatefulWidget {
  int id;
  TicketDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  TextEditingController _messageController = TextEditingController();
  String messageStatus = ""; 
  bool loading = false;
  late int index;

  getTicketsById() async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      String url = "https://api.qline.app/api/tickets/messages?id=${widget.id}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["authorization"] = "Bearer $token";
      var response = await dio.get(url);
      messageStatus = response.data["ticket"]["status"];
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          String messagesString = response.data["ticket"]["messages"];
          List<dynamic> messagesJson = jsonDecode(messagesString);
          index = tickets.indexWhere((e) => e.id == widget.id);
          tickets[index].user_id = response.data["ticket"]["user_id"];
          tickets[index].messages = messagesJson.map((e) {
            return Message(
              user: e["user"],
              message: e["message"],
              time: e["time"],
            );
          }).toList();
          // print(tickets[index].messages![0].message);
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ticket yüklenemedi! ${response.data["msg"]}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Beklenmeyen bir hata oluştu! $e")));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTicketsById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.support_agent_outlined)
            ),
            SizedBox(width: 10),
            Text("Api Bot"),
          ],
        ),
        actions: [
          messageStatus == "user_closed" ? SizedBox() :
          PopupMenuButton<int>(
            onSelected: (value) async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Text("Konuşma kalıcı olarak kapatılacaktır?", textAlign: TextAlign.center),
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
                            String url = "https://api.qline.app/api/tickets/close";
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String? token = prefs.getString("token");
                            dio.options.headers.addAll({
                              "authorization": "Bearer $token",
                              "Content-Type": "application/json",
                            });
                            Map<String, dynamic> data = {
                              "id": widget.id,
                            };
                            Response response = await dio.post(url, data: data);
                            if (response.data["success"] == true) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return TicketPage(); 
                              }));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj başarıyla kapatıldı!")));
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj kapatılırken bir hata oluştu! ${response.data["msg"]}")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj kapatılırken bir hata oluştu! $e")));
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
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Konuşmayı sonlandır')),
            ],
          ),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            tickets[index].topic ?? "",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          SizedBox(height: 5),
                          Text(
                            tickets[index].title ?? "",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          SizedBox(height: 5),
                          Text(
                            tickets[index].status ?? "",
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: tickets[index].messages!.map((e) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 10,
                          left: tickets[index].messages![tickets[index].messages!.indexOf(e)].user == true ? 50 : 10,
                          right: tickets[index].messages![tickets[index].messages!.indexOf(e)].user == true ? 10 : 50,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tickets[index].messages![tickets[index].messages!.indexOf(e)].user == true ? Colors.blue[100] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                e.message ?? "",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(height: 5),
                              Text(
                                e.time ?? "",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),           
          messageStatus == "user_closed" ? Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Kapalı konuya mesaj gönderilmez!"),
          ) :
          Container(
            padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
            height: 60,
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Mesajınızı yazınız..",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                            loading = true;
                          });
                          try {
                            Dio dio = Dio();
                            String url = "https://api.qline.app/api/tickets/respond";
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String? token = prefs.getString("token");
                            dio.options.headers.addAll({
                              "authorization": "Bearer $token",
                              "Content-Type": "application/json",
                            });
                            Map<String, dynamic> data = {
                              "id": widget.id,
                              "message": _messageController.text,
                            };
                            Response response = await dio.post(url, data: data);
                            if (response.data["success"] == true) {
                              getTicketsById();
                              _messageController.clear();
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj kapatılırken bir hata oluştu! ${response.data["msg"]}")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mesaj kapatılırken bir hata oluştu! $e")));
                          }
                          setState(() {
                            loading = false;
                          });
                    }
                  },
                  child: Icon(Icons.send,color: Colors.white,size: 18,),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
                SizedBox(width: 5)
              ],
            ),
          ),
        ],
      ),
    );
  }
}