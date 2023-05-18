// ignore_for_file: public_member_api_docs, sort_constructors_first
List<dynamic> news = [];

class User {
  String? token;
  String? name;
  String? email;
  String? phone;
  String? adress;
  String? create;
  String? update;

  User({
    required this.token,
    required this.name,
    required this.email,
    required this.phone,
    required this.adress,
    required this.create,
    required this.update,
  });
}

class Message {
  bool? user;
  String? message;
  String? time;
  Message({
    this.user,
    this.message,
    this.time,
  });
}

class Ticket {
  int? id;
  int? user_id;
  List<Message>? messages;
  String? title;
  String? status;
  String? topic;
  String? created_time;
  String? updated_time;
  Ticket({
    this.id,
    this.user_id,
    this.messages,
    this.title,
    this.status,
    this.topic,
    this.created_time,
    this.updated_time,
  });
}

List<Ticket> tickets = [];

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

  static String? ticketControl(String? value, int? length) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz.';
    }
    if (value.length < length!) {
      return 'Bu alan en az $length karakterden oluşmalıdır.';
    }
    return null;
  }
}