import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 仅在桌面平台(Windows、macOS、Linux)上初始化window_manager
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 650),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // 隐藏标题栏
      windowButtonVisibility: false, // 隐藏窗口按钮
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  
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
      home: const BorderlessWindow(
        child: HomePage(),
      ),
    );
  }
}

// 自定义无边框窗口组件
class BorderlessWindow extends StatelessWidget {
  final Widget child;
  
  const BorderlessWindow({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 在非桌面平台上直接返回子组件
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return child;
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // 主体内容
          child,
          
          // 右上角窗口控制按钮
          Positioned(
            top: 0,
            right: 0,
            child: WindowButtons(),
          ),
        ],
      ),
    );
  }
}

// 窗口控制按钮
class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          icon: Icons.remove,
          onPressed: () => windowManager.minimize(),
          hoverColor: Colors.black12,
        ),
        _buildButton(
          icon: Icons.crop_square,
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
          hoverColor: Colors.black12,
        ),
        _buildButton(
          icon: Icons.close,
          onPressed: () => windowManager.close(),
          hoverColor: Colors.red.withOpacity(0.8),
          iconColor: Colors.red,
          hoverIconColor: Colors.white,
        ),
      ],
    );
  }
  
  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color hoverColor,
    Color? iconColor,
    Color? hoverIconColor,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          hoverColor: hoverColor,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: 46,
            height: 32,
            child: Icon(
              icon, 
              size: 16,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
