// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_print, use_build_context_synchronously, unused_import

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_mo/user.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  Future<bool> authentifierUser(String email, String password) async {
    var url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/auth/connexion');
    var body = jsonEncode({'email': email, 'password': password});

    try {
      final respone = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      final data = jsonDecode(respone.body);
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (respone.statusCode == 200 || respone.statusCode == 201) {
        await preferences.setString('name', data['user']['nom']);
        await preferences.setString('email', data['user']['email']);
        await preferences.setString('password', data['user']['password']);
        await preferences.setString('accessToken', data['accessToken']);
        print('stockage 200');
        return true;
      } else {
        print(respone.statusCode);
        return false;
      }
    } catch (error) {
      print('$error');
      return false;
    }
  }

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200),
          Text(
            'Connection',
            style: GoogleFonts.playfairDisplay(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: const Color(0xffba7264)),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xffba7264),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xffba7264),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xffba7264),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 3) {
                        return 'Le mot de passe doit contenir au moins 3 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool success = await authentifierUser(
                                emailController.text, passwordController.text);
                            if (success) {
                              context.go('/homePage');
                            }
                          }
                        },
                        child: Text(
                          'Connexion',
                          style:
                              TextStyle(color: Color(0xffffffff), fontSize: 30),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 2),
                            backgroundColor: Color(0xffba7264),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                context.go('/signup');
              },
              child: Text(
                'Vous n\'avez pas de compte, cliquez ici!',
                style: TextStyle(color: Color(0xff351e1a), fontSize: 15),
              )),
        ],
      ),
    );
  }
}
