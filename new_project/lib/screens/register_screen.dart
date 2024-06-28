import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_project/api/remote_api.dart';
import 'package:new_project/router.dart';
import 'package:new_project/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _registerFormKey,
        child: ListView(
          children: [
            const Gap(100),
            customfield(_name, 'Enter name', (value) {
              if (value == null || value.isEmpty) {
                return 'Name can\'t be empty';
              }
              return null;
            }),
            const Gap(20),
            customfield(_email, 'Enter email', (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              }
              return null;
            }),
            const Gap(20),
            customfield(_password, 'Enter password', (value) {
              if (value == null || value.isEmpty) {
                return 'Password can\'t be null';
              }
              if (value.length < 8) {
                return 'Password length must be 8 digits';
              }
              return null;
            }),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: ElevatedButton(
                onPressed: () async {
                  if (_registerFormKey.currentState!.validate()) {
                    final _api = Api();
                    final result = await _api.register(
                        _name.text, _email.text, _password.text);
                    if (result == null) {
                      // showing snackabar
                    } else {
                      AppRouter.replaceWith(context, '/home');
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
                child: const Text('Register'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Login'))
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
