import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deep Work"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/sign_up');
              },
              child: const Text('Go to Registration'),
            ),
            const SizedBox(height: 16), // Adds spacing between the buttons
            ElevatedButton(
              onPressed: () {
                context.go('/sign_in');
              },
              child: const Text('Go to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
