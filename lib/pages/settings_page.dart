import 'package:flutter/material.dart';
import '../widgets/java_settings_tab.dart';
import '../widgets/game_settings_tab.dart';
import '../widgets/launcher_settings_tab.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  
  final List<Widget> _tabContents = [
    const JavaSettingsTab(),
    const GameSettingsTab(),
    const LauncherSettingsTab(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧菜单 (竖向排列)
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 2,
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '设置',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMenuItem(0, 'Java设置', Icons.coffee),
                        _buildMenuItem(1, '游戏设置', Icons.games),
                        _buildMenuItem(2, '启动器设置', Icons.settings),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 右侧内容区域
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _tabContents[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(int index, String title, IconData icon) {
    final isSelected = index == _selectedIndex;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
