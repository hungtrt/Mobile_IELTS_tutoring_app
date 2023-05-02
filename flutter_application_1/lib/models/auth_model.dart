import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; // user details
  Map<String, dynamic> appointment = {}; // upcoming appointment
  List<Map<String, dynamic>> favDoc = []; // latest favorite doctor
  List<dynamic> _fav = []; // all favorite doctor
  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

  // update latest favorite list and notify all widgets
  void setFavList(List<dynamic> list)
  {
    _fav = list;
    notifyListeners();
  }

  void clearAppointment()
  {
    appointment = {};
    notifyListeners();
  }

  // return latest favorite doctor list
  List<Map<String, dynamic>> get getFavDoc {
    favDoc.clear();
    for (var num in _fav)
      {
        for (var doc in user['doctor'])
          {
            if (num == doc['doc_id'])
              {
                favDoc.add(doc);
              }
          }
      }
    return favDoc;
  }
  void loginSuccess(Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;
    user = userData;
    appointment = appointmentInfo;
    if (user['details']['fav'] != null)
      {
        _fav = json.decode(user['details']['fav']);
      }
    notifyListeners();
  }
}