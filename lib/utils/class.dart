List<dynamic> news = [];

class User {
  final String? name;
  final String? email;
  final String? phone;
  final String? adress;
  final String? create;
  final String? update;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.adress,
    required this.create,
    required this.update,
  });
}

class TextFieldValidator {
  static String? mailControl(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi boş olamaz.';
    }
    if (!value.contains('@') || !value.contains('com')) {
      return 'Geçerli bir e-posta adresi girin.';
    }
    return null;
  }

  static String? passControl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş olamaz.';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    return null;
  }

  static String? nameControl(String? value) {
    if (value == null || value.isEmpty) {
      return 'İsim boş olamaz.';
    }
    if (value.length < 4) {
      return 'İsim en az 4 karakter olmalıdır.';
    }
    return null;
  }
}