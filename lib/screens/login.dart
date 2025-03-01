import 'package:deep_work_mobile/providers/auth_provider.dart';
import 'package:deep_work_mobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// import 'dart:developer';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String? _email, _password;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final email = TextFormField(
        decoration: const InputDecoration(
            hintText: 'Enter your email',
            border: OutlineInputBorder(),
            labelText: 'Email *'),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Please enter your email" : null,
        onSaved: (value) => _email = value);

    final password = TextFormField(
        decoration: const InputDecoration(
            hintText: 'Enter your Password',
            border: OutlineInputBorder(),
            labelText: 'Password *'),
        validator: (value) => (value == null || value.isEmpty)
            ? "Please enter your password"
            : null,
        obscureText: true,
        onSaved: (value) => _password = value);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),
                  email,
                  const SizedBox(height: 16),
                  password,
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            auth.login(_email!, _password!).then((response) => {
                                  if (response['status'])
                                    {
                                      userProvider.setUser(response['user']),
                                      if (context.mounted)
                                        {context.push('/focus_sessions')}
                                    }
                                  else
                                    _errorMessage = response['body']['message']
                                });
                          }
                        },
                        child: const Text('Sign In')),
                  )
                ]))));
  }
}
