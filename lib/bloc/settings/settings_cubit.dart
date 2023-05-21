import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState>{
  SettingsCubit(super.initialState);
  
  changeLanguage(String lang) async {
    final newState = SettingsState(
      language: lang,
      darkMode: state.darkMode,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", lang);
    prefs.setBool("darkMode", state.darkMode);
    emit(newState);
  }

  changeDarkMode(bool darkMode) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: darkMode,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", state.language);
    prefs.setBool("darkMode", darkMode);
    emit(newState);
  }

}