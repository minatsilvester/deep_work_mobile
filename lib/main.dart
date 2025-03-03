import 'package:deep_work_mobile/providers/auth_provider.dart';
import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:deep_work_mobile/providers/user_provider.dart';
import 'package:deep_work_mobile/screens/focus_session.dart/list.dart';
import 'package:deep_work_mobile/screens/focus_session.dart/show.dart';
import 'package:deep_work_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
import './screens/register.dart';
import './theme/default_theme.dart';
import 'package:go_router/go_router.dart';

// final GoRouter _router = GoRouter(initialLocation: '/', routes: [
//   GoRoute(path: '/', builder: (context, state) => const Home()),
//   GoRoute(path: '/sign_up', builder: (context, state) => const Register()),
//   GoRoute(path: '/sign_in', builder: (context, state) => const Login()),
//   GoRoute(
//       path: '/focus_sessions',
//       builder: (context, state) => const FocusSessionList()),

//   // 2️⃣ Dynamic route for focus session details
//   GoRoute(
//     path: '/focus_sessions/:id',
//     builder: (context, state) {
//       final id = state.pathParameters['id']!; // Extract id from URL
//       return ShowFocusSession(id: id);
//     },
//   ),
// ]);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                FocusSessionProvider()..listFocusSessions(date: DateTime.now()))
      ],
      child: const DeepWork(),
    ),
  );
}

class DeepWork extends StatelessWidget {
  const DeepWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return MaterialApp.router(
          theme: defaultTheme,
          routerConfig: GoRouter(
            initialLocation: auth.loginStatus == Status.loggedIn
                ? '/focus_sessions' // Start at focus_sessions if logged in
                : '/',
            routes: [
              GoRoute(path: '/', builder: (context, state) => const Home()),
              GoRoute(
                  path: '/sign_up',
                  builder: (context, state) => const Register()),
              GoRoute(
                  path: '/sign_in', builder: (context, state) => const Login()),
              GoRoute(
                  path: '/focus_sessions',
                  builder: (context, state) => const FocusSessionList(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return ShowFocusSession(id: id);
                      },
                    ),
                  ]),
            ],
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
