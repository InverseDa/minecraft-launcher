import 'package:flutter/material.dart';
import '../services/game_service.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String selectedVersion = "1.20.4";
  String username = "";
  bool isJavaInstalled = false;
  bool isLoading = false;
  
  final GameService _gameService = GameService();
  List<String> versions = [];

  @override
  void initState() {
    super.initState();
    checkJavaInstallation();
    loadVersions();
  }

  Future<void> checkJavaInstallation() async {
    final installed = await _gameService.checkJavaInstallation();
    setState(() {
      isJavaInstalled = installed;
    });
  }

  Future<void> loadVersions() async {
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

  Future<void> launchGame() async {
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minecraft启动器',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: '游戏版本',
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 20),
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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : launchGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('启动游戏'),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
