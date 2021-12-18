import 'dart:developer';

import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String? _currentName;
  String? _currentSugar = '0';
  int? _currentStrength = 100;

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserModel?>(context);

    return StreamBuilder<UserData>(
        stream: user == null ? null : DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          log(snapshot.toString());
          log(user.toString());
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Update your brew settings.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                    initialValue: userData!.name,
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    value: _currentSugar ?? userData.sugars,
                    decoration: textInputDecoration,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugar(s)'),
                      );
                    }).toList(),
                    onChanged: (String? val) =>
                        setState(() => _currentSugar = val),
                  ),
                  const SizedBox(height: 20.0),
                  Slider(
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) {
                      setState(() {
                        _currentStrength = val.round();
                      });
                    },
                    value: (_currentStrength ?? userData.strength!).toDouble(),
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength!],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength!],
                  ),
                  const SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user!.uid).updateUserData(
                              _currentSugar ?? userData.sugars!,
                              _currentName ?? userData.name!,
                              _currentStrength ?? userData.strength!);
                        }
                      }),
                ],
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
