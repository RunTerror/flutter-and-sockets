import 'package:flutter/material.dart';
import 'package:new_project/screens/find_page.dart';
import 'package:new_project/screens/home_screen.dart';
import 'package:new_project/screens/login_screen.dart';
import 'package:new_project/screens/message_box.dart';
import 'package:new_project/screens/register_screen.dart';
import 'package:new_project/screens/splash_screen.dart'; // Import your screens

class AppRouter {
  static const String splashRoute = '/'; // Route names
  static const String loginRouter = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String findUserRoute = '/finduser';
  static const String chatUserRoute = '/message';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case loginRouter:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case findUserRoute:
        return MaterialPageRoute(builder: (_) => const FindPage());
      case chatUserRoute:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => MessageBox(
                  reciever: arguments['reciever'],
                  conversationId: arguments['conversationId'],
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void replaceWith(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
