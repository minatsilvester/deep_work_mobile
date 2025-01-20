import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
// import '../models/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String? _firstName, _lastName, _email, _timeZone, _password;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final firstName = TextFormField(
        decoration: const InputDecoration(
            hintText: 'Enter your first name',
            border: OutlineInputBorder(),
            labelText: 'First Name *'),
        validator: (value) => (value == null || value.isEmpty)
            ? "Please enter your First name"
            : null,
        onSaved: (value) => _firstName = value);

    final lastName = TextFormField(
        decoration: const InputDecoration(
            hintText: 'Enter your last name',
            border: OutlineInputBorder(),
            labelText: 'Last Name *'),
        validator: (value) => (value == null || value.isEmpty)
            ? "Please enter your last name"
            : null,
        onSaved: (value) => _lastName = value);

    final email = TextFormField(
        decoration: const InputDecoration(
            hintText: 'Enter your email',
            border: OutlineInputBorder(),
            labelText: 'Email *'),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Please enter your email" : null,
        onSaved: (value) => _email = value);

    final timeZone = TextFormField(
        decoration: const InputDecoration(
            hintText: 'Enter your time zone',
            border: OutlineInputBorder(),
            labelText: 'Time Zone *'),
        validator: (value) => (value == null || value.isEmpty)
            ? "Please enter your time zone"
            : null,
        onSaved: (value) => _timeZone = value);

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
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  firstName,
                  const SizedBox(height: 16),
                  lastName,
                  const SizedBox(height: 16),
                  email,
                  const SizedBox(height: 16),
                  password,
                  const SizedBox(height: 16),
                  timeZone,
                  const SizedBox(height: 16),
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final userParams = {
                          'first_name': _firstName,
                          'last_name': _lastName,
                          'email': _email,
                          'time_zone': _timeZone,
                          'password': _password
                        };
                        auth.register(userParams).then((response) =>
                            {if (response['status']) log("Success")});
                      } else {
                        log("Failed");
                      }
                    },
                    child: const Text('Sign Up'),
                  ))
                ]))));
  }
}
