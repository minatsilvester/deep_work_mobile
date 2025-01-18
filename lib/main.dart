import 'package:deep_work_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';
import './screens/register.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const DeepWork(),
    ),
  );
}

class DeepWork extends StatelessWidget {
  const DeepWork({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/sign_up': (context) => const Register(),
      },
    );
  }
}
