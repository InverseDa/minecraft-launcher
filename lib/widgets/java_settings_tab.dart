import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
  String downloadMessage = '';
  
  // Java路径
  final TextEditingController javaPathController = TextEditingController();
  String selectedJavaPath = '';
  List<String> detectedJavaInstallations = [];
  String? customDownloadPath;
  
  // JVM参数
  final TextEditingController jvmArgsController = TextEditingController();
  
  // 内存设置
  double maxMemorySlider = 2048;

  @override
  void initState() {
    super.initState();
    _initialize();
  }
  
  // 初始化函数，确保按顺序进行初始化
  Future<void> _initialize() async {
    // 首先加载游戏服务设置
    await _gameService.loadSettings();
    
    // 再加载UI设置
    await _loadSettings();
    
    // 最后检查Java安装
    await _checkJavaInstallation();
  }
  
  @override
  void dispose() {
    javaPathController.dispose();
    jvmArgsController.dispose();
    super.dispose();
  }
  
  // 加载设置
  Future<void> _loadSettings() async {
    // 加载Java路径
    selectedJavaPath = _gameService.selectedJavaPath;
    if (selectedJavaPath.isNotEmpty) {
      setState(() {
        javaPathController.text = selectedJavaPath;
      });
    }
    
    // 加载已检测到的Java安装
    await _findJavaInstallations();
    
    // 如果没有选择的Java路径但有检测到的安装，自动选择第一个
    if (selectedJavaPath.isEmpty && detectedJavaInstallations.isNotEmpty) {
      setState(() {
        selectedJavaPath = detectedJavaInstallations.first;
        javaPathController.text = selectedJavaPath;
        _gameService.selectedJavaPath = selectedJavaPath;
      });
    }
    
    // 加载JVM参数
    setState(() {
      jvmArgsController.text = _gameService.jvmArgs;
      maxMemorySlider = _gameService.maxMemory.toDouble();
    });
  }
  
  // 刷新Java检测
  Future<void> _refreshJavaDetection() async {
    await _findJavaInstallations();
    await _checkJavaInstallation();
    
    setState(() {});
  }
  
  // 检查Java安装
  Future<void> _checkJavaInstallation() async {
    setState(() {
      isJavaInstalled = false;
    });
    
    final installed = await _gameService.checkJavaInstallation();
    setState(() {
      isJavaInstalled = installed;
    });
    
    if (!installed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('未检测到Java，请安装Java或选择自定义Java路径'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  // 查找Java安装
  Future<void> _findJavaInstallations() async {
    final installations = await _gameService.findJavaInstallations();
    setState(() {
      detectedJavaInstallations = installations;
    });
  }
  
  // 选择Java路径
  Future<void> _selectJavaPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe'],
      dialogTitle: '选择Java可执行文件 (java.exe)',
    );
    
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      if (path.endsWith('java.exe')) {
        setState(() {
          selectedJavaPath = path;
          javaPathController.text = path;
        });
        
        // 保存选择的Java路径
        _gameService.selectedJavaPath = path;
        
        // 检查选择的Java是否可用
        _checkJavaInstallation();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请选择有效的java.exe文件'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }
  
  // 选择检测到的Java
  void _selectDetectedJava(String javaPath) {
    setState(() {
      selectedJavaPath = javaPath;
      javaPathController.text = javaPath;
    });
    
    // 保存选择的Java路径
    _gameService.selectedJavaPath = javaPath;
    
    // 检查Java是否可用
    _checkJavaInstallation();
  }
  
  // 选择Java下载位置
  Future<void> _selectDownloadPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '选择Java安装位置',
    );
    
    if (selectedDirectory != null) {
      setState(() {
        customDownloadPath = selectedDirectory;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已选择下载位置: $selectedDirectory'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  // 下载和安装Java
  Future<void> _downloadJava() async {
    // 先让用户选择下载位置
    if (customDownloadPath == null) {
      bool shouldContinue = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('选择下载位置'),
            content: const Text('请先选择Java安装的位置'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  await _selectDownloadPath();
                },
                child: const Text('选择位置'),
              ),
            ],
          );
        },
      ) ?? false;
      
      if (!shouldContinue || customDownloadPath == null) {
        return;
      }
    }
    
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
      downloadMessage = '准备下载...';
    });
    
    try {
      await _gameService.downloadJava(
        selectedJavaVersion,
        (progress, message) {
          setState(() {
            downloadProgress = progress;
            downloadMessage = message;
          });
        },
        customDownloadPath: customDownloadPath,
      );
      
      // 下载完成后更新Java路径和检测状态
      setState(() {
        isDownloading = false;
        selectedJavaPath = _gameService.selectedJavaPath;
        javaPathController.text = selectedJavaPath;
        isJavaInstalled = true;
      });
      
      // 更新检测到的Java列表
      await _findJavaInstallations();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$selectedJavaVersion 安装成功'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('安装失败: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
  
  // 打开JVM参数编辑对话框
  void _openJvmArgsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('JVM参数设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: jvmArgsController,
                decoration: const InputDecoration(
                  labelText: 'JVM参数',
                  border: OutlineInputBorder(),
                  helperText: '高级用户使用，请谨慎修改',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Text('最大内存分配: ${maxMemorySlider.toInt()} MB'),
              Slider(
                value: maxMemorySlider,
                min: 1024,
                max: 8192,
                divisions: 14,
                label: '${maxMemorySlider.toInt()} MB',
                onChanged: (value) {
                  setState(() {
                    maxMemorySlider = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                // 保存JVM参数
                _gameService.jvmArgs = jvmArgsController.text;
                _gameService.maxMemory = maxMemorySlider.toInt();
                Navigator.of(context).pop();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('JVM参数已保存'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

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
                    onPressed: _refreshJavaDetection,
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
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: isDownloading ? null : _selectDownloadPath,
                    icon: const Icon(Icons.folder),
                    label: const Text('选择位置'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: isDownloading ? null : _downloadJava,
                    icon: const Icon(Icons.download),
                    label: const Text('下载安装'),
                  ),
                ],
              ),
              
              if (customDownloadPath != null) ...[
                const SizedBox(height: 8),
                Text(
                  '下载位置: $customDownloadPath',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ],
              
              if (isDownloading) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(value: downloadProgress),
                const SizedBox(height: 8),
                Text(downloadMessage),
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
                      controller: javaPathController,
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
                    onPressed: _selectJavaPath,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('浏览'),
                  ),
                ],
              ),
              
              // 检测到的Java安装列表
              if (detectedJavaInstallations.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '检测到的Java安装:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    itemCount: detectedJavaInstallations.length,
                    itemBuilder: (context, index) {
                      final javaPath = detectedJavaInstallations[index];
                      final isSelected = selectedJavaPath == javaPath;
                      
                      return ListTile(
                        title: Text(
                          javaPath,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        leading: Icon(
                          Icons.flutter_dash,
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                        ),
                        selected: isSelected,
                        onTap: () => _selectDetectedJava(javaPath),
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // 高级Java选项
              ExpansionTile(
                title: const Text('高级Java选项'),
                children: [
                  ListTile(
                    title: const Text('JVM参数'),
                    subtitle: Text(
                      jvmArgsController.text.isEmpty
                        ? '未设置自定义JVM参数'
                        : '最大内存: ${maxMemorySlider.toInt()} MB',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: _openJvmArgsDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
