import 'package:flutter/material.dart';
import 'package:lionair_2/providers/user_provider.dart';
import 'package:lionair_2/screens/home_screen.dart';
import 'package:lionair_2/screens/input_laporan.dart';
import 'package:lionair_2/screens/login_screen.dart';
import 'package:lionair_2/screens/notification.dart';
import 'package:lionair_2/screens/reservasi_mess.dart';
import 'package:lionair_2/screens/register.dart';
import 'package:provider/provider.dart';
import 'screens/laporan.dart';
import 'screens/lihat_reservasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initialize();
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
        title: 'Lion Reservation',
        routes: {
          'login': (_) => const LoginScreen(),
          // ignore: prefer_const_constructors
          'reservasi_mess': (_) => ReservasiMess(
                data: '',
                data1: '',
                data2: '',
              ),
          'lihat_reservasi': (_) => LihatDataEmployee(
                data: '',
                data1: '',
                data2: '',
                data3: '',
              ),
          'input_laporan': (_) => InputLaporan(
                data: '',
                data1: '',
                data2: '',
                data3: '',
                data4: '',
                vidx4: '',
                bookin3: '',
                bookout3: '',
              ),
          'laporan': (_) => Lihatlaporan(
                data: '',
                data1: '',
                data2: '',
                data3: '',
                data4: '',
                vidx4: '',
                bookin3: '',
                bookout3: '',
              ),
          'home': (_) => HomeScreen(
                data: '',
                data1: '',
                data2: '',
              ),
          'register': (_) => const RegisterScreen(),
        },
        initialRoute: 'login',
      ),
    );
  }
}
