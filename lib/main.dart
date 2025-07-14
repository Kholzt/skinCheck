import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:skin_chek/screens/auth/forgot-password/forgot.dart';
import 'package:skin_chek/screens/auth/login/login.dart';
import 'package:skin_chek/screens/chat/Chat.dart';
import 'package:skin_chek/splash.dart';
import 'package:skin_chek/utils/theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ✅ Global notifier untuk semua widget
final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>>
  _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();

    _connectionSubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      final connected = results.any((r) => r != ConnectivityResult.none);
      isOnlineNotifier.value = connected;
      _showConnectionStatus(connected);
    });
  }

  void _showConnectionStatus(bool connected) {
    final snackBar = SnackBar(
      content: Text(
        connected ? "Terhubung ke Internet" : "Tidak ada koneksi internet",
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: connected ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        left: 50,
        right: 50,
      ),
      duration: const Duration(seconds: 3),
    );

    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'Skin Check',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: "/",
      routes: {
        "/login": (context) => const Login(),
        "/chat": (context) => const Chat(),
        "/forgot-password": (context) => const ForgotPassword(),
        "/": (context) => const Splash(),
      },
    );
  }
}
