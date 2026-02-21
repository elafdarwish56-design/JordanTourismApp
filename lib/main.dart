import 'package:flutter/material.dart';
import 'src/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  bool isArabic = true;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onToggleTheme: toggleTheme,
        onToggleLanguage: toggleLanguage, //
        isArabic: isArabic, //
      ),
    );
  }
}
