import 'package:flutter/material.dart';
import '../services/game_service.dart';

class JavaSettingsTab extends StatefulWidget {
  const JavaSettingsTab({super.key});

  @override
  State<JavaSettingsTab> createState() => _JavaSettingsTabState();
}

class _JavaSettingsTabState extends State<JavaSettingsTab> {
  final GameService _gameService = GameService();
  bool isJavaInstalled = false;
  final List<String> javaVersions = ['Java 8', 'Java 11', 'Java 17', 'Java 21'];
  String selectedJavaVersion = 'Java 17';
  bool isDownloading = false;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkJavaInstallation();
  }

  Future<void> _checkJavaInstallation() async {
    final installed = await _gameService.checkJavaInstallation();
    setState(() {
      isJavaInstalled = installed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Java 设置',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Java 安装状态
            Row(
              children: [
                Icon(
                  isJavaInstalled ? Icons.check_circle : Icons.error,
                  color: isJavaInstalled ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isJavaInstalled ? 'Java已安装' : 'Java未安装',
                  style: TextStyle(
                    fontSize: 16,
                    color: isJavaInstalled ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _checkJavaInstallation,
                  icon: const Icon(Icons.refresh),
                  label: const Text('检测'),
                ),
              ],
            ),
            
            const Divider(height: 32),
            
            // Java版本管理
            Text(
              'Java版本管理',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Java版本选择器
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Java 版本',
                      border: OutlineInputBorder(),
                      helperText: '选择Minecraft兼容的Java版本',
                    ),
                    value: selectedJavaVersion,
                    items: javaVersions.map((String version) {
                      return DropdownMenuItem<String>(
                        value: version,
                        child: Text(version),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedJavaVersion = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: isDownloading ? null : () {
                    // 这里实现Java下载功能
                    setState(() {
                      isDownloading = true;
                      downloadProgress = 0.0;
                    });
                    
                    // 模拟下载进度
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        downloadProgress = 0.3;
                      });
                      
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          downloadProgress = 0.7;
                        });
                        
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            downloadProgress = 1.0;
                            
                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                isDownloading = false;
                                isJavaInstalled = true;
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$selectedJavaVersion 下载并安装成功')),
                              );
                            });
                          });
                        });
                      });
                    });
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('下载安装'),
                ),
              ],
            ),
            
            if (isDownloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: downloadProgress),
              const SizedBox(height: 8),
              Text('下载中: ${(downloadProgress * 100).toStringAsFixed(0)}%'),
            ],
            
            const Divider(height: 32),
            
            // Java路径设置
            Text(
              'Java路径设置',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Java路径',
                      border: OutlineInputBorder(),
                      helperText: '自定义Java可执行文件路径',
                      prefixIcon: Icon(Icons.folder_open),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // 打开文件选择器
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text('浏览'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 高级Java选项
            ExpansionTile(
              title: const Text('高级Java选项'),
              children: [
                ListTile(
                  title: const Text('JVM参数'),
                  subtitle: const Text('自定义JVM启动参数'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    // 打开JVM参数编辑器
                  },
                ),
                SwitchListTile(
                  title: const Text('自动管理Java版本'),
                  subtitle: const Text('根据Minecraft版本自动选择最佳Java版本'),
                  value: true,
                  onChanged: (value) {
                    // 实现自动管理Java版本逻辑
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
