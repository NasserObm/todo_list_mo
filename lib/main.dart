import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_mo/connection.dart';
import 'package:todo_list_mo/home_page.dart';
import 'package:todo_list_mo/parametre.dart';
import 'package:todo_list_mo/signup.dart';
import 'package:todo_list_mo/welcome.dart';

void main() => runApp(const MyToDoApp());
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Welcome();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'connection',
          builder: (BuildContext context, GoRouterState state) {
            return const Connection();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const Signup();
          },
        ),
        GoRoute(
          path: 'homePage',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: 'parametre',
          builder: (BuildContext context, GoRouterState state) {
            return const Parametre();
          },
        ),
      ],
    ),
  ],
);

class MyToDoApp extends StatelessWidget {
  const MyToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
