import 'package:go_router/go_router.dart';
import 'package:todo_list_mo/connection.dart';
import 'package:todo_list_mo/home_page.dart';
import 'package:todo_list_mo/parametre.dart';
import 'package:todo_list_mo/signup.dart';
import 'package:todo_list_mo/welcome.dart';

class Route {
  final GoRouter router = GoRouter(routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome(),
    ),
    GoRoute(
      path: '/connection',
      builder: (context, state) => const Connection(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const Signup(),
    ),
    GoRoute(
      path: '/parametre',
      builder: (context, state) => const Parametre(),
    ),
    GoRoute(
      path: '/home_page',
      builder: (context, state) => const HomePage(),
    )
  ]);
}
