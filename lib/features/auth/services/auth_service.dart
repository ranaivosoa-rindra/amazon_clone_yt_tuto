// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:amazon_clone_tuto/constants/error_handling.dart';
import 'package:amazon_clone_tuto/constants/global_variables.dart';
import 'package:amazon_clone_tuto/constants/utils.dart';
import 'package:amazon_clone_tuto/features/home/screens/home_screen.dart';
import 'package:amazon_clone_tuto/models/user.dart';
import 'package:amazon_clone_tuto/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign up user
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
          id: "",
          name: name,
          password: password,
          address: "",
          type: "",
          token: "",
          email: email);

      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, "Account created! Login with the same credential");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            // we need to save the token to our device
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final UserProvider user =
                Provider.of<UserProvider>(context, listen: false);
            // print(jsonDecode(res.body));
            user.setUser(res.body);
            // listen: false => we are outside of bell function: we dont need to be notified

            // set the data
            await prefs.setString(
                "x-auth-token", jsonDecode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
