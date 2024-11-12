// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_mo/user.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  Future<User> getShared() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String nom = preferences.getString('name') ?? '';
    String email = preferences.getString('email') ?? '';
    String password = preferences.getString('password') ?? '';
    String accessToken = preferences.getString('accessToken') ?? '';
    print('AccessToken récupéré: $accessToken');
    return User(nom, email, password, accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff643f38),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 450,
              ),
              const Text(
                'Bienvenue Dans ton Compte!',
                style: TextStyle(fontSize: 25, color: Color(0xffd3a096)),
              ),
              ElevatedButton(
                  onPressed: () {
                    context.go("/homePage");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffd3a096),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text(
                    "Retourner",
                    style: TextStyle(color: Color(0xffffffff), fontSize: 20),
                  ))
            ],
          ),
        ));
  }
}
