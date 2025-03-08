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
        // 使用系统默认字体（在中文Windows上是微软雅黑）
        fontFamily: 'Microsoft YaHei',
        // 统一所有文本样式
        textTheme: const TextTheme(
          // 大标题
          headlineLarge: TextStyle(fontWeight: FontWeight.w500),
          headlineMedium: TextStyle(fontWeight: FontWeight.w500),
          headlineSmall: TextStyle(fontWeight: FontWeight.w500),
          // 标题
          titleLarge: TextStyle(fontWeight: FontWeight.w500),
          titleMedium: TextStyle(fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontWeight: FontWeight.w500),
          // 正文
          bodyLarge: TextStyle(fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontWeight: FontWeight.w400),
          // 标签（如按钮文字）
          labelLarge: TextStyle(fontWeight: FontWeight.w500),
          labelMedium: TextStyle(fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontWeight: FontWeight.w500),
        ),
        // 确保按钮文字也使用相同粗细
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
