import 'package:go_router/go_router.dart';
import 'package:todolist_app/pages/page1.dart';
import 'package:todolist_app/pages/page2.dart';
import 'package:todolist_app/pages/page3.dart';
import 'package:todolist_app/welcome.dart';

class AppRouter {
  final GoRouter router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome(),
    ),
    GoRoute(
      path: '/connexion',
      builder: (context, state) => const Page1(),
    ),
    GoRoute(
      path: '/enregistrement',
      builder: (context, state) => const Page2(),
    ),
    GoRoute(path: '/home_page', builder: (context, state) => const Page3()),
  ]);
}
