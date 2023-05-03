import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prak_auth_test/access_screens.dart';
import 'package:prak_auth_test/access_services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccessServices>(
          create: (_) => AccessServices(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AccessScreen(),
      ),
    );
  }
}
