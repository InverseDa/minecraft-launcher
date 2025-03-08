import 'package:flutter/material.dart';
import '../widgets/version_download_tab.dart';
import '../widgets/mod_download_tab.dart';
import '../widgets/resource_pack_tab.dart';
import '../widgets/shader_download_tab.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  int _selectedIndex = 0;
  
  final List<Widget> _tabContents = [
    const VersionDownloadTab(),
    const ModDownloadTab(),
    const ResourcePackTab(),
    const ShaderDownloadTab(),
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
                      '下载中心',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMenuItem(0, '游戏版本', Icons.games),
                        _buildMenuItem(1, 'MOD下载', Icons.extension),
                        _buildMenuItem(2, '材质包', Icons.image),
                        _buildMenuItem(3, '光影包', Icons.lightbulb),
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
