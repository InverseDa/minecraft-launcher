import 'package:flutter/material.dart';

class LauncherSettingsTab extends StatefulWidget {
  const LauncherSettingsTab({super.key});

  @override
  State<LauncherSettingsTab> createState() => _LauncherSettingsTabState();
}

class _LauncherSettingsTabState extends State<LauncherSettingsTab> {
  String _selectedTheme = "系统默认";
  final List<String> _themes = ["系统默认", "浅色", "深色", "高对比度"];
  
  String _selectedLanguage = "简体中文";
  final List<String> _languages = ["简体中文", "English", "日本語", "Español", "Français", "Deutsch"];
  
  bool _autoCheckUpdates = true;
  bool _showExperimentalVersions = false;
  bool _closeWhenGameLaunches = true;
  
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
                '启动器设置',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // 界面设置
              _buildSectionTitle('界面设置'),
              const SizedBox(height: 16),
              
              // 主题设置
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '主题',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.color_lens),
                ),
                value: _selectedTheme,
                items: _themes.map((String theme) {
                  return DropdownMenuItem<String>(
                    value: theme,
                    child: Text(theme),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTheme = newValue;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // 语言设置
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '语言',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                ),
                value: _selectedLanguage,
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
              ),
              
              const Divider(height: 32),
              
              // 行为设置
              _buildSectionTitle('启动器行为'),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('自动检查更新'),
                subtitle: const Text('启动器启动时自动检查新版本'),
                value: _autoCheckUpdates,
                onChanged: (value) {
                  setState(() {
                    _autoCheckUpdates = value;
                  });
                },
              ),
              
              SwitchListTile(
                title: const Text('显示实验性版本'),
                subtitle: const Text('在版本列表中显示快照和预发布版本'),
                value: _showExperimentalVersions,
                onChanged: (value) {
                  setState(() {
                    _showExperimentalVersions = value;
                  });
                },
              ),
              
              SwitchListTile(
                title: const Text('游戏启动后关闭启动器'),
                subtitle: const Text('启动游戏后自动关闭或最小化启动器'),
                value: _closeWhenGameLaunches,
                onChanged: (value) {
                  setState(() {
                    _closeWhenGameLaunches = value;
                  });
                },
              ),
              
              const Divider(height: 32),
              
              // 高级设置
              _buildSectionTitle('高级设置'),
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {
                  // 实现缓存清理逻辑
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('清理缓存'),
                        content: const Text('确定要清理启动器缓存吗？这不会影响您的游戏存档和配置。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('缓存已清理')),
                              );
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.cleaning_services),
                label: const Text('清理启动器缓存'),
              ),
              
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {
                  // 实现重置设置逻辑
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('重置设置'),
                        content: const Text('确定要将所有设置重置为默认值吗？此操作不可撤销。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _selectedTheme = "系统默认";
                                _selectedLanguage = "简体中文";
                                _autoCheckUpdates = true;
                                _showExperimentalVersions = false;
                                _closeWhenGameLaunches = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('所有设置已重置为默认值')),
                              );
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.restore),
                label: const Text('重置所有设置'),
              ),
              
              const Divider(height: 32),
              
              // 关于启动器
              _buildSectionTitle('关于启动器'),
              const SizedBox(height: 16),
              
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('版本信息'),
                subtitle: const Text('Minecraft启动器 v1.0.0'),
                onTap: () {
                  // 显示更详细的版本信息
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('检查更新'),
                subtitle: const Text('当前已是最新版本'),
                onTap: () {
                  // 实现检查更新逻辑
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('正在检查更新...')),
                  );
                },
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
