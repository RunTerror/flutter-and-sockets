import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_project/locator.dart';
import 'package:new_project/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Gap(100),
            customfield(_email, 'Enter email', (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              bool isValid = EmailValidator.validate(value);
              if (!isValid) {
                return 'Please enter a valid email';
              }
              return null;
            }),
            const Gap(20),
            customfield(_password, 'Enter password', (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            }),
            const Gap(20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final result = await api.login(
                      _email.text.trim(), _password.text.trim());
                  if (result != null) {
                    log('here');
                    Navigator.pushNamed(context, '/home');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Create an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Register'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget customfield(TextEditingController controller, String hintText,
      String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          errorStyle: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
