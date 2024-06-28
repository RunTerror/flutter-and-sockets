import 'package:flutter/material.dart';
import 'package:new_project/locator.dart';
import 'package:new_project/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // initialising shared prefrence
  await localApi.initSp();
  // initialising hive
  await localApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
