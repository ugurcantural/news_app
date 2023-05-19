import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/account_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/tickets_screen.dart';

class drawerWidget extends StatelessWidget {
  const drawerWidget({
    super.key,
    required this.widget,
  });

  final HomePage widget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            CircleAvatar(
              radius: 64,
              backgroundColor: Colors.cyan[100],
              child: Icon(Icons.account_circle_outlined, size: 50),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white, endIndent: 20, indent: 20, thickness: 2),
            Text(
              widget.user.name ?? "No name!",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            Divider(color: Colors.white, endIndent: 20, indent: 20, thickness: 2),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AccountPage(user: widget.user);
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_circle_outlined, size: 32, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Hesabım",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return TicketPage();
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Mesajlar",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.message_outlined, size: 32, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text("Çıkış yapılsın mı?", textAlign: TextAlign.center),
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
                                  try {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.clear();
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                      return LoginPage(); 
                                    }));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Çıkış yapılırken bir hata oluştu!")));
                                  }
                                }, 
                                child: Text("Çıkış Yap"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_outlined, size: 32, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Çıkış Yap",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}