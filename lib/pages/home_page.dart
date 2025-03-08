import 'package:flutter/material.dart';
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

  final List<String> _titles = ['启动', '下载', '设置', '更多'];
  final List<IconData> _icons = [
    Icons.play_arrow,
    Icons.download,
    Icons.settings,
    Icons.more_horiz,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 顶部导航栏 (在大屏幕上显示为侧边栏)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: List.generate(
              _titles.length,
              (index) => NavigationRailDestination(
                icon: Icon(_icons[index]),
                label: Text(_titles[index]),
              ),
            ),
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
              items: List.generate(
                _titles.length,
                (index) => BottomNavigationBarItem(
                  icon: Icon(_icons[index]),
                  label: _titles[index],
                ),
              ),
            )
          : null,
    );
  }
}
