import 'package:deep_work_mobile/providers/auth_provider.dart';
import 'package:deep_work_mobile/providers/focus_session_provider.dart';
import 'package:deep_work_mobile/providers/user_provider.dart';
import 'package:deep_work_mobile/screens/focus_session.dart/list.dart';
import 'package:deep_work_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
import './screens/register.dart';
import './theme/default_theme.dart';

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
    final auth = Provider.of<AuthProvider>(context);

    final initialRoute =
        auth.loginStatus == Status.loggedIn ? '/focus_sessions' : '/';

    return MaterialApp(
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const Home(),
        '/sign_up': (context) => const Register(),
        '/focus_sessions': (context) => const FocusSessionList(),
        '/sign_in': (context) => const Login()
      },
    );
  }
}
