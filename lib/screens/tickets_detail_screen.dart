// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/class.dart';

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
  bool loading = false;
  late int index;

  getTicketsById() async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      String url = "https://api.eskanist.com/public/api/tickets/messages?id=${widget.id}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["authorization"] = "Bearer $token";
      var response = await dio.get(url);
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
        title: Text("Konuşma Geçmişi"),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey[400],
                        child: Icon(Icons.support_agent_outlined)
                      ),
                      SizedBox(height: 5),
                      Text(tickets[index].topic ?? ""),
                      SizedBox(height: 5),
                      Text(tickets[index].title ?? ""),
                      SizedBox(height: 5),
                      Text(tickets[index].status ?? "")
                    ],
                  ),
                ),
              ),
              Column(
                children: tickets[index].messages!.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(e.message ?? ""),
                          SizedBox(height: 5),
                          Text(e.time ?? ""),
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
    );
  }
}