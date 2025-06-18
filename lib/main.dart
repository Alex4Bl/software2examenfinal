import 'package:flutter/material.dart';
import 'package:proyectofinalsoftware/views/authenticacion.dart';
import 'package:proyectofinalsoftware/views/cliente/menuelecciones.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lihnfjxwxgvdgbmbywge.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpaG5manh3eGd2ZGdibWJ5d2dlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5MjQ2NzQsImV4cCI6MjA2MzUwMDY3NH0.p2MZhx5Op8V_waDf5mtUGJUu1inKIp0XCftupJIoe5I',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Votación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
