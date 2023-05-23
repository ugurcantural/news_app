import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/settings/settings_cubit.dart';
import '../localization/localization.dart';
import '../screens/account_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/tickets_screen.dart';

class drawerWidget extends StatefulWidget {
  const drawerWidget({
    super.key,
    required this.widget,
  });

  final HomePage widget;

  @override
  State<drawerWidget> createState() => _drawerWidgetState();
}

class _drawerWidgetState extends State<drawerWidget> {
  late final SettingsCubit settings;

  @override
  void initState() {
    super.initState();
    settings = context.read<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      backgroundColor: settings.state.darkMode ? Colors.black : Theme.of(context).primaryColor,
      child: SafeArea(
        child: SingleChildScrollView(
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
                widget.widget.user.name ?? "No name!",
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
                          return AccountPage(user: widget.widget.user);
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
                              AppLocalizations.of(context).getTranslate('account'),
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
                              AppLocalizations.of(context).getTranslate('messages'),
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
                              content: Text(
                                "${AppLocalizations.of(context).getTranslate('logout')}?",
                                textAlign: TextAlign.center),
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
                              AppLocalizations.of(context).getTranslate('logout'),
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
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            settings.changeLanguage("tr");
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: settings.state.language == "tr" ? Colors.white : Colors.transparent,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("TR", style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: settings.state.language == "tr" ? Theme.of(context).primaryColor : Colors.white,
                            ),),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            settings.changeLanguage("en");
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: settings.state.language == "en" ? Colors.white : Colors.transparent,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("EN", style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: settings.state.language == "en" ? Theme.of(context).primaryColor : Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        settings.state.darkMode == true ? settings.changeDarkMode(false) : settings.changeDarkMode(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}