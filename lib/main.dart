import 'package:flutter/material.dart';
import 'pages/main_layout.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}
