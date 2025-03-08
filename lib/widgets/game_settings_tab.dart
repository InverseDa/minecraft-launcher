import 'package:flutter/material.dart';

class GameSettingsTab extends StatefulWidget {
  const GameSettingsTab({super.key});

  @override
  State<GameSettingsTab> createState() => _GameSettingsTabState();
}

class _GameSettingsTabState extends State<GameSettingsTab> {
  double _memorySliderValue = 2.0;
  bool _fullscreen = false;
  String _selectedResolution = "自动 (根据窗口大小)";
  final List<String> _resolutions = [
    "自动 (根据窗口大小)",
    "1920x1080",
    "1600x900",
    "1366x768",
    "1280x720",
    "800x600"
  ];
  
  String _gameDirectory = "默认";
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '游戏设置',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // 内存分配
              _buildSectionTitle('内存分配'),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '最大内存: ${_memorySliderValue.toInt()} GB',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _memorySliderValue,
                    min: 1.0,
                    max: 16.0,
                    divisions: 15,
                    label: '${_memorySliderValue.toInt()} GB',
                    onChanged: (value) {
                      setState(() {
                        _memorySliderValue = value;
                      });
                    },
                  ),
                  Text(
                    '为Minecraft分配更多内存可以提高游戏性能，但分配过多可能会导致其他程序运行缓慢。',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),
              
              // 游戏目录
              _buildSectionTitle('游戏目录'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: '游戏存档目录',
                        border: const OutlineInputBorder(),
                        hintText: _gameDirectory,
                        prefixIcon: const Icon(Icons.folder),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      // 实现选择游戏目录的逻辑
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('浏览'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _gameDirectory = "默认";
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('重置为默认目录'),
              ),
              
              const Divider(height: 32),
              
              // 显示设置
              _buildSectionTitle('显示设置'),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('全屏模式'),
                subtitle: const Text('以全屏模式启动游戏'),
                value: _fullscreen,
                onChanged: (value) {
                  setState(() {
                    _fullscreen = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '游戏分辨率',
                  border: OutlineInputBorder(),
                  helperText: '选择游戏窗口分辨率',
                ),
                value: _selectedResolution,
                items: _resolutions.map((String resolution) {
                  return DropdownMenuItem<String>(
                    value: resolution,
                    child: Text(resolution),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedResolution = newValue;
                    });
                  }
                },
              ),
              
              const Divider(height: 32),
              
              // 高级游戏选项
              _buildSectionTitle('高级选项'),
              const SizedBox(height: 8),
              ExpansionTile(
                title: const Text('游戏启动参数'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: '自定义游戏参数',
                        border: OutlineInputBorder(),
                        helperText: '添加自定义的游戏启动参数',
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              
              ExpansionTile(
                title: const Text('JVM参数'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: '自定义JVM参数',
                        border: OutlineInputBorder(),
                        helperText: '添加自定义的JVM启动参数',
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 保存按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 保存设置逻辑
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('设置已保存')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('保存设置'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
