import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../models/focus_session.dart';
import '../presistence/user_preferences.dart';
import 'dart:convert';
// import 'dart:io';

class FocusSessionProvider extends ChangeNotifier {
  final String baseUri = 'http://10.0.2.2:4000/api/focus_sessions';
  final userPreferences = UserPreferences();
  String? _errorMessage;
  bool _isFailed = false;
  bool _isLoading = false;
  List<FocusSession> _focusSessions = [];
  DateTime _selectedDate = DateTime.now();

  List<FocusSession> get focusSessions => _focusSessions;
  String? get errorMessage => _errorMessage;
  bool get isFailed => _isFailed;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;

  Future<void> listFocusSessions({DateTime? date}) async {
    _setLoading(true);
    final String token = await userPreferences.getToken();

    String formattedDate =
        date != null ? date.toIso8601String().split('T').first : '';

    Response response =
        await get(Uri.parse('$baseUri?date=$formattedDate'), headers: {
      'authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _focusSessions = (responseData['data'] as List<dynamic>)
          .map((item) => FocusSession.fromJson(item as Map<String, dynamic>))
          .toList();
      // notifyListeners();
      _setLoading(false);
    } else {
      _isFailed = true;
      _errorMessage = 'Error fetching data, please try again later';
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addFocusSession(focusSessionParams) async {
    // _setLoading(true);

    final String token = await userPreferences.getToken();

    try {
      Response response = await post(Uri.parse(baseUri),
          body: json.encode({'focus_sessions': focusSessionParams}),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          });

      if (response.statusCode == 201) {
        final decodedResponse = json.decode(response.body);

        final focusSession = FocusSession.fromJson(decodedResponse['data']);

        _appendFocusSession(focusSession);

        return {
          'status': true,
          'message': 'Successfully Created Focus Session',
          'data': focusSession
        };
      } else {
        return {
          'status': false,
          'message': 'Something went wrong',
          'data': null
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Something went wrong', 'data': null};
    }
  }

  FocusSession? getFocusSession(String id) {
    int? focusSessionId = int.tryParse(id);
    if (focusSessionId == null) return null;
    return _focusSessions
        .firstWhere((focusSession) => focusSession.id == focusSessionId);
  }

  Future<Map<String, dynamic>> stopFocusSession(
      String id, String status) async {
    int? focusSessionId = int.tryParse(id);

    if (focusSessionId != null) {
      int index =
          _focusSessions.indexWhere((session) => session.id == focusSessionId);
      final focusSession = _focusSessions[index];
      final String token = await userPreferences.getToken();

      try {
        Response response = await put(
            Uri.parse('$baseUri/${focusSession.id}/stop'),
            body: json.encode({
              'focus_sessions': {'status': status}
            }),
            headers: {
              'Content-Type': 'application/json',
              'authorization': 'Bearer $token'
            });

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);

          final updatedFocusSession =
              FocusSession.fromJson(decodedResponse['data']);

          _focusSessions[index] = updatedFocusSession;
          notifyListeners();

          return {
            'status': true,
            'message': 'Focus Session Stopped',
            'data': focusSession
          };
        } else {
          return {
            'status': false,
            'message': 'Something went wrong',
            'data': null
          };
        }
      } catch (e) {
        return {
          'status': false,
          'message': 'Something went wrong',
          'data': null
        };
      }
    } else {
      return {'status': false, 'message': 'Something went wrong', 'data': null};
    }
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void _setLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void _appendFocusSession(focusSession) {
    _focusSessions.add(focusSession);
    // _setLoading(false);
    notifyListeners();
  }
}
