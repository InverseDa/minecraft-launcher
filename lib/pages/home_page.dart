import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'launch_page.dart';
import 'download_page.dart';
import 'settings_page.dart';
import 'more_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const LaunchPage(),
    const DownloadPage(),
    const SettingsPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 添加窗口拖动功能
      onPanStart: (details) {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          windowManager.startDragging();
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            // 侧边导航栏
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              leading: _buildLogo(),
              destinations: const [
                // 启动
                NavigationRailDestination(
                  icon: Icon(Icons.play_arrow),
                  label: Text('启动'),
                ),
                // 下载
                NavigationRailDestination(
                  icon: Icon(Icons.download),
                  label: Text('下载'),
                ),
                // 设置
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('设置'),
                ),
                // 更多
                NavigationRailDestination(
                  icon: Icon(Icons.more_horiz),
                  label: Text('更多'),
                ),
              ],
            ),
            // 主内容区域
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
        // 在移动设备上显示底部导航栏
        bottomNavigationBar: MediaQuery.of(context).size.width < 600
            ? BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.play_arrow),
                    label: '启动',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.download),
                    label: '下载',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: '设置',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz),
                    label: '更多',
                  ),
                ],
              )
            : null,
      ),
    );
  }
  
  // 创建Minecraft Logo
  Widget _buildLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF41a02c),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.terrain,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Minecraft',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            '启动器',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
