
import 'package:go_router/go_router.dart';
import 'package:notebook_study/auth_gate.dart';
import 'package:notebook_study/screens/research_project/category_list_screen.dart';
import 'package:notebook_study/screens/research_project/category_screen.dart';

import '../home.dart';

final GoRouter routes = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/category',
        
        builder: (context, state) => const CategoryScreenForm(),
      ),

      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoryListScreen(),
      ),
    ],
  );