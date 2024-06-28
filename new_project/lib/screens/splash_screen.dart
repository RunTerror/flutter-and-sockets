import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/api/local_api.dart';
import 'package:new_project/locator.dart';
import 'package:new_project/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    load();
    super.initState();
  }

  Future<void> load() async {
    await localApi.init();
    final token = await localApi.getKey('token');

    if (token != null) {
      final resp = await api.getUser();
      if (context.mounted) {
        Navigator.pushReplacementNamed(
            context, resp == null ? '/login' : '/home');
      }
      return;
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Loading screen'),
      ),
    );
  }
}
