import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Deep Work"), centerTitle: true),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_up');
                },
                child: const Text('Go to Registration'))));
  }
}
