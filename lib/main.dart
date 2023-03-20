import 'package:flutter/material.dart';
import 'package:lionair_2/providers/user_provider.dart';
import 'package:lionair_2/screens/home_screen.dart';
import 'package:lionair_2/screens/login_screen.dart';
import 'package:lionair_2/screens/register.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material Aps',
        routes: {
          'login': (_) => LoginScreen(),
          'home': (_) => HomeScreen(),
          'register': (_) => RegisterScreen(),
        },
        initialRoute: 'login',
      ),
    );
  }
}
