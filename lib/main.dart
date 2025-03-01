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

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Home()),
    GoRoute(path: '/sign_up', builder: (context, state) => const Register()),
    GoRoute(path: '/sign_in', builder: (context, state) => const Login()),
    GoRoute(
        path: '/focus_sessions',
        builder: (context, state) => const FocusSessionList()),

    // 2️⃣ Dynamic route for focus session details
    GoRoute(
      path: '/focus_sessions/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!; // Extract id from URL
        return ShowFocusSession(id: id);
      },
    ),
  ],
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) => FocusSessionProvider()..listFocusSessions())
      ],
      child: const DeepWork(),
    ),
  );
}

class DeepWork extends StatelessWidget {
  const DeepWork({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);

    // final initialRoute =
    // auth.loginStatus == Status.loggedIn ? '/focus_sessions' : '/';

    return MaterialApp.router(
      theme: defaultTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      // initialRoute: initialRoute,
      // routes: {
      //   '/': (context) => const Home(),
      //   '/sign_up': (context) => const Register(),
      //   '/sign_in': (context) => const Login(),
      //   '/focus_sessions': (context) => const FocusSessionList(),
      //   // '/focus_sessions/:id': (context) => const ShowFocusSession(id: id)
      // },
    );
  }
}
