import 'package:deep_work_mobile/models/user.dart';
import 'package:deep_work_mobile/presistence/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthProvider extends ChangeNotifier {
  final loginUri = Uri.parse("http://10.0.2.2:4000/api/sign_in");
  final registerUri = Uri.parse("http://10.0.2.2:4000/api/sign_up");

  Status _registeredStatus = Status.notRegistered;
  Status _loginStatus = Status.notLoggedIn;

  Status get registeredStatus => _registeredStatus;
  Status get loginStatus => _loginStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    _loginStatus = Status.authenticating;
    notifyListeners();

    try {
      Response response = await post(loginUri,
          body: json.encode({
            'user': {'email': email, 'password': password}
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        final userData = body['data'];

        User user = User.fromJson(userData);

        UserPreferences().saveUser(user);
        UserPreferences().saveToken(userData['token']);

        _loginStatus = Status.loggedIn;
        notifyListeners();

        return {'status': true, 'message': 'Login Successfull', 'user': user};
      } else {
        return {
          'status': false,
          'message': 'Login Not Successfull',
          'body': json.decode(response.body)
        };
      }
    } catch (e) {
      return {
        'status': false,
        'messsage': 'Something went Wrong, please try again later',
        'user': null
      };
    }
  }

  Future<Map<String, dynamic>> register(userParams) async {
    _registeredStatus = Status.registering;
    notifyListeners();

    try {
      Response response = await post(registerUri,
          body: json.encode({'user': userParams}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 201) {
        final userData = json.decode(response.body);

        User user = User.fromJson(userData['data']);

        _registeredStatus = Status.registered;
        notifyListeners();

        return {
          'status': true,
          'messsage': 'Successfully Registered User',
          'user': user
        };
      } else {
        return {
          'status': false,
          'message': 'Registration failed',
          'data': response
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Registration failed', 'data': null};
    }
  }
}
