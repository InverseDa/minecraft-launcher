import 'package:flutter/material.dart';
import '../services/game_service.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final GameService _gameService = GameService();
  String username = "";
  String selectedVersion = "";
  List<String> versions = [];
  bool isJavaInstalled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkJava();
    _loadVersions();
  }

  Future<void> _checkJava() async {
    final installed = await _gameService.checkJavaInstallation();
    setState(() {
      isJavaInstalled = installed;
    });
  }

  Future<void> _loadVersions() async {
    setState(() {
      isLoading = true;
    });
    
    final availableVersions = await _gameService.getAvailableVersions();
    
    setState(() {
      versions = availableVersions;
      if (versions.isNotEmpty) {
        selectedVersion = versions[0];
      }
      isLoading = false;
    });
  }

  Future<void> _launchGame() async {
    if (!isJavaInstalled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Java需要被安装才能启动游戏')),
      );
      return;
    }
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入用户名')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _gameService.launchGame(selectedVersion, username);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('游戏启动成功！')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('启动失败: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧用户信息和版本选择区域
          Expanded(
            flex: 1,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户信息区域
                    Text(
                      '用户信息',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        helperText: '输入您的游戏用户名',
                      ),
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // 版本选择区域
                    Text(
                      '版本选择',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    isLoading ? 
                      const Center(child: CircularProgressIndicator()) :
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: '游戏版本',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.games),
                        ),
                        value: versions.contains(selectedVersion) ? selectedVersion : null,
                        items: versions.map((String version) {
                          return DropdownMenuItem<String>(
                            value: version,
                            child: Text(version),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedVersion = newValue;
                            });
                          }
                        },
                      ),
                    const SizedBox(height: 16),
                    
                    // Java状态
                    Row(
                      children: [
                        Icon(
                          isJavaInstalled ? Icons.check_circle : Icons.error,
                          color: isJavaInstalled ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isJavaInstalled ? 'Java已安装' : 'Java未安装',
                          style: TextStyle(
                            color: isJavaInstalled ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // 启动按钮
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _launchGame,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('启动游戏'),
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
          ),
          
          // 右侧公告区域
          Expanded(
            flex: 2,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '游戏公告',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // 这里未来可以显示Markdown格式的公告
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '暂无公告内容，未来可以显示Markdown格式的公告。',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
