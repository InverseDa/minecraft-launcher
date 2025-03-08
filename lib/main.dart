import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MinecraftLauncher());
}

class MinecraftLauncher extends StatelessWidget {
  const MinecraftLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minecraft Launcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: const Color(0xFF41a02c),
          secondary: const Color(0xFF2e73b8),
        ),
        useMaterial3: true,
        // 确保字体样式一致
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
