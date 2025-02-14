// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/focus_session_provider.dart';
import 'package:flutter/services.dart';

// import '../../providers/auth_provider.dart';

class NewFocusSessionForm extends StatefulWidget {
  const NewFocusSessionForm({super.key});

  @override
  NewFocusSessionFormState createState() => NewFocusSessionFormState();
}

class NewFocusSessionFormState extends State<NewFocusSessionForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _expectedLength;

  @override
  Widget build(BuildContext context) {
    final focusSessionProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);

    final name = TextFormField(
      decoration: const InputDecoration(
        hintText: "Enter a Name",
        border: OutlineInputBorder(),
        labelText: "Name",
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Please Enter a name" : null,
      onSaved: (value) => _name = value,
    );

    final expectedLength = TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
            hintText: "How may minutes ?",
            border: OutlineInputBorder(),
            labelText: "Expected Length"),
        validator: (value) => (value == null || value.isEmpty)
            ? "Please enter the minutes"
            : null,
        onSaved: (value) => _expectedLength =
            (value == null || value.isEmpty) ? null : int.parse(value));

    return Scaffold(
        appBar: AppBar(title: const Text('New Focus Session')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(children: [
                name,
                const SizedBox(height: 16),
                expectedLength,
                const SizedBox(height: 16),
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final focusSessionParams = {
                        'name': _name,
                        'expected_length': _expectedLength
                      };

                      focusSessionProvider
                          .addFocusSession(focusSessionParams)
                          .then((response) => {
                                if (response['status'])
                                  {
                                    if (context.mounted)
                                      {
                                        // Navigator.pushReplacementNamed(context,
                                        //     "/focus_sessions/$response['data']['id']")
                                        Navigator.of(context).pop()
                                      }
                                  }
                              });
                    }
                  },
                  child: const Text("Start Focus Session"),
                ))
              ])),
        ));
  }
}
