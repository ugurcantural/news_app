import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/class.dart';
import 'new_ticket_screen.dart';
import 'tickets_detail_screen.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  bool loading = false;

  getTicket() async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      String url = "https://api.eskanist.com/public/api/tickets";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      dio.options.headers["authorization"] = "Bearer $token";
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          tickets = List<Ticket>.from(response.data.map((e) {
            return Ticket(
              id: e["id"],
              title: e["title"],
              status: e["status"],
              topic: e["topic"],
              created_time: e["created_at"],
              updated_time: e["updated_at"],
            );
          }));
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
    getTicket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewTicketPage();  
              }));
            },
            icon: Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: tickets.length != 0 ? Column(
          children: tickets.map((e) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                top: 10,
                right: tickets.indexOf(e) % 2 == 0 ? 40 : 10,
                left: tickets.indexOf(e) % 2 == 0 ? 10 : 40,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TicketDetailPage(id: e.id!);
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: tickets.indexOf(e) % 2 == 0 ? Colors.blue[50] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          child: Icon(Icons.support_agent_outlined)
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              e.title ?? "",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              e.status ?? "",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ): Center(child: Text("Ticket Bulunamadı!")),
      ),
    );
  }
}