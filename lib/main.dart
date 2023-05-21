import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/settings/settings_state.dart';
import 'localization/localization.dart';
import 'screens/error_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/class.dart';

User? user;
bool? isloggin;
loadApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? language = prefs.getString("language");
  bool? darkMode = prefs.getBool("darkMode");
  if (language == null) {
    if (kIsWeb) {
      language = "tr";
    }
    else {
      final String defaultLocale = Platform.localeName;
      var liste = defaultLocale.split('_');
      var isSupported = AppLocalizations.delegate.isSupported(Locale(liste[0], ""));
      if (isSupported) {
        language = liste[0];
      }
      else {
        language = "tr";
      }
    }
    await prefs.setString("language", language);
  }

  if (darkMode == null) {
    if (ThemeMode.system == ThemeMode.dark) {
      darkMode = true;
    }
    else {
      darkMode = false;
    }
    await prefs.setBool("darkMode", darkMode);
  }

  String? savedList = prefs.getString('myList');
  if (savedList != null) {
    favoritedList = json.decode(savedList).cast<String>();
  }
  String? email = prefs.getString("email");
  String? password = prefs.getString("password");
  String? token = prefs.getString("token");
  if (email != null && password != null && token != null) {
    try {
      Dio dio = Dio();
      String url = "https://api.qline.app/api/login";
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
      print(language);
      print(darkMode);
    }
  }
  else {
    isloggin = false;
  }
  return SettingsState(
    darkMode: darkMode,
    language: language,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadApp().then((value) => runApp(MyApp(st: value)));
}

class MyApp extends StatelessWidget {
  final SettingsState st;
  const MyApp({
    Key? key,
    required this.st,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(st),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'ListeList',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLanguages.map((e) => Locale(e, "")).toList(),
            locale: Locale(state.language, ""),
            themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: FlexThemeData.light(scheme: FlexScheme.hippieBlue).copyWith(
              appBarTheme: AppBarTheme(
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.white,
                ),
              ),
            ),
            darkTheme: FlexThemeData.dark(primary: Colors.grey[700]).copyWith(
              appBarTheme: AppBarTheme(
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.black,
                ),
              ),
            ),
            home: isloggin == true ? HomePage(user: user!) : (isloggin == false ? LoginPage() : ErrorPage()),
          );
        }
      ),
    );
  }
}
