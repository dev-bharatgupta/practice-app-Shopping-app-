import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final String userid;
  final String token;
  final DateTime expirydate;

  Auth({this.userid, this.token, this.expirydate});
}

class AuthProvider extends ChangeNotifier {
  bool isauthenticate = false;

  String idtoken;
  String userid;
  Timer timer;

  void signup(String id, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCe3o2QYZuIhRAFP9gRFLwc3qKEkloS_bE";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": id,
            "password": password,
            "returnSecureToken": true,
          }));
      if (response.statusCode > 200) {
        throw json.decode(response.body)["error"]["message"];
      }
    } catch (error) {
      throw error;
    }
  }

  void signin(String id, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCe3o2QYZuIhRAFP9gRFLwc3qKEkloS_bE";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": id,
            "password": password,
            "returnSecureToken": true,
          }));
      if (response.statusCode > 200) {
        //  print(json.decode(response.body));
        throw json.decode(response.body)["error"]["message"];
      }
      // print("132");

      final object = Auth(
        userid: json.decode(response.body)["localId"],
        expirydate: DateTime.now().add(
          Duration(
            seconds: int.parse(json.decode(response.body)["expiresIn"]),
          ),
        ),
        token: json.decode(response.body)["idToken"],
      );

      if (object.expirydate != null &&
          object.expirydate.isAfter(DateTime.now()) &&
          object.token != null) {
        isauthenticate = true;
        idtoken = object.token;
        userid = object.userid;
        if (timer != null) timer.cancel();
        timer = Timer(
            Duration(
                seconds: object.expirydate
                    .difference(DateTime.now())
                    .inSeconds), () {
          logout();
        });
      }

      notifyListeners();

//    final prefs = await SharedPreferences.getInstance();
//
//      prefs.setString(
//          "userdata",
//          json.encode({
//            "token": object.token,
//            "userid": object.userid,
//            "expirydate": object.expirydate.toIso8601String()
//          }));
//      final decodeddata =
//          json.decode(prefs.getString("userdata")) as Map<String, Object>;
//      print(decodeddata);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> getdata() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userdata")) return false;
    final decodeddata =
        json.decode(prefs.getString("userdata")) as Map<String, Object>;
    print(decodeddata);
    if (DateTime.parse(decodeddata["expirydate"]).isBefore(DateTime.now()))
      return false;

    final object = Auth(
        userid: decodeddata["userid"],
        expirydate: DateTime.parse(decodeddata["expirydate"]),
        token: decodeddata["token"]);
    if (object.expirydate != null &&
        object.expirydate.isAfter(DateTime.now()) &&
        object.token != null) {
      isauthenticate = true;
      idtoken = object.token;
      userid = object.userid;
      notifyListeners();
      return true;
    }
  }

  Future<void> logout() async {
    idtoken = null;
    isauthenticate = false;
    if (timer != null) timer.cancel();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
