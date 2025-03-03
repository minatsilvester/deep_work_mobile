import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:async';

class UserPreferences {
  void saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("firstName", user.firstName!);
    prefs.setString("lastName", user.lastName!);
    prefs.setString("email", user.email!);
    prefs.setString("timeZone", user.timeZone!);
  }

  void saveToken(token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? firstName = prefs.getString("firstName");
    String? lastName = prefs.getString("lastName");
    String? email = prefs.getString("email");
    String? timeZone = prefs.getString("timeZone");

    return User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        timeZone: timeZone);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("firstName");
    prefs.remove("lastName");
    prefs.remove("email");
    prefs.remove("timeZone");
  }

  void removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("token");
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    return token!;
  }
}
