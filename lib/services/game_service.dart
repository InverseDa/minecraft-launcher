import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  final String _gameDir = path.join(Directory.current.path, 'minecraft');
  final String _versionsUrl = 'https://launchermeta.mojang.com/mc/game/version_manifest.json';
  
  // 添加Java相关变量
  String _selectedJavaPath = '';
  String _jvmArgs = '-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1';
  int _maxMemory = 2048; // 默认最大内存MB
  List<String> _savedJavaInstallations = [];
  
  // SharedPreferences键
  static const String _keySelectedJavaPath = 'selectedJavaPath';
  static const String _keyJvmArgs = 'jvmArgs';
  static const String _keyMaxMemory = 'maxMemory';
  static const String _keySavedJavaInstallations = 'savedJavaInstallations';
  
  final Map<String, String> _javaDownloadUrls = {
    'Java 8': 'https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u392-b08/OpenJDK8U-jdk_x64_windows_hotspot_8u392b08.zip',
    'Java 11': 'https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.22%2B7/OpenJDK11U-jdk_x64_windows_hotspot_11.0.22_7.zip',
    'Java 17': 'https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.10_7.zip',
    'Java 21': 'https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_x64_windows_hotspot_21.0.2_13.zip'
  };

  // 获取和设置Java路径
  String get selectedJavaPath => _selectedJavaPath;
  set selectedJavaPath(String path) {
    _selectedJavaPath = path;
    _saveSettings();
  }
  
  // 获取和设置JVM参数
  String get jvmArgs => _jvmArgs;
  set jvmArgs(String args) {
    _jvmArgs = args;
    _saveSettings();
  }
  
  // 获取和设置最大内存
  int get maxMemory => _maxMemory;
  set maxMemory(int memory) {
    _maxMemory = memory;
    _saveSettings();
  }
  
  // 获取保存的Java安装列表
  List<String> get savedJavaInstallations => _savedJavaInstallations;
  
  // 添加Java安装到保存列表
  void addJavaInstallation(String javaPath) {
    if (!_savedJavaInstallations.contains(javaPath)) {
      _savedJavaInstallations.add(javaPath);
      _saveSettings();
    }
  }
  
  // 加载设置
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _selectedJavaPath = prefs.getString(_keySelectedJavaPath) ?? '';
      _jvmArgs = prefs.getString(_keyJvmArgs) ?? _jvmArgs;
      _maxMemory = prefs.getInt(_keyMaxMemory) ?? _maxMemory;
      
      final savedInstallations = prefs.getStringList(_keySavedJavaInstallations);
      if (savedInstallations != null) {
        _savedJavaInstallations = savedInstallations;
      }
    } catch (e) {
      print('加载设置出错: $e');
    }
  }
  
  // 保存设置
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_keySelectedJavaPath, _selectedJavaPath);
      await prefs.setString(_keyJvmArgs, _jvmArgs);
      await prefs.setInt(_keyMaxMemory, _maxMemory);
      await prefs.setStringList(_keySavedJavaInstallations, _savedJavaInstallations);
    } catch (e) {
      print('保存设置出错: $e');
    }
  }

  // 检查Java安装
  Future<bool> checkJavaInstallation() async {
    try {
      if (_selectedJavaPath.isNotEmpty) {
        // 使用选定的Java路径
        final File javaExe = File(_selectedJavaPath);
        if (await javaExe.exists()) {
          ProcessResult result = await Process.run(_selectedJavaPath, ['-version']);
          return result.exitCode == 0;
        }
        return false;
      } else {
        // 尝试使用系统Java
        ProcessResult result = await Process.run('java', ['-version']);
        if (result.exitCode == 0) {
          return true;
        }
        return false;
      }
    } catch (e) {
      print('Java检测出错: $e');
      return false;
    }
  }
  
  // 查找所有可能的Java安装位置
  Future<List<String>> findJavaInstallations() async {
    List<String> javaInstallations = [];
    
    // 首先添加已保存的安装
    javaInstallations.addAll(_savedJavaInstallations.where((path) {
      final file = File(path);
      return file.existsSync();
    }));
    
    // 检查常见Java安装位置
    List<String> possibleLocations = [
      'C:\\Program Files\\Java',
      'C:\\Program Files (x86)\\Java',
      'C:\\Program Files\\Eclipse Adoptium',
      'C:\\Program Files\\BellSoft\\LibericaJDK',
      'C:\\Program Files\\Microsoft\\jdk',
    ];
    
    // 添加我们自己安装的Java位置
    final appDir = await getApplicationDocumentsDirectory();
    possibleLocations.add('${appDir.path}\\jdks');
    
    // 如果有自定义下载位置，也检查那里
    for (var savedPath in _savedJavaInstallations) {
      final dir = path.dirname(path.dirname(savedPath)); // 获取java.exe所在目录的父目录
      if (!possibleLocations.contains(dir)) {
        possibleLocations.add(dir);
      }
    }
    
    for (var location in possibleLocations) {
      Directory directory = Directory(location);
      if (await directory.exists()) {
        try {
          await for (var entity in directory.list(recursive: true)) {
            if (entity is File && path.basename(entity.path) == 'java.exe') {
              final javaPath = entity.path;
              if (!javaInstallations.contains(javaPath)) {
                javaInstallations.add(javaPath);
                
                // 将这个路径添加到保存的安装列表中
                addJavaInstallation(javaPath);
              }
            }
          }
        } catch (e) {
          print('搜索Java安装位置时出错: $e');
        }
      }
    }
    
    // 检查环境变量中的Java
    String? javaBin = Platform.environment['JAVA_HOME'];
    if (javaBin != null && javaBin.isNotEmpty) {
      String javaExe = path.join(javaBin, 'bin', 'java.exe');
      File file = File(javaExe);
      if (await file.exists() && !javaInstallations.contains(javaExe)) {
        javaInstallations.add(javaExe);
        addJavaInstallation(javaExe);
      }
    }
    
    return javaInstallations;
  }

  // 下载Java
  Future<String> downloadJava(String javaVersion, Function(double progress, String message) onProgress, {String? customDownloadPath}) async {
    try {
      final downloadUrl = _javaDownloadUrls[javaVersion];
      if (downloadUrl == null) {
        throw Exception('不支持的Java版本');
      }

      // 创建临时文件夹和Java安装目录
      final appDir = await getApplicationDocumentsDirectory();
      final tempDir = Directory('${appDir.path}\\temp');
      
      // 使用自定义下载路径或默认路径
      final jdksDir = customDownloadPath != null 
          ? Directory(customDownloadPath) 
          : Directory('${appDir.path}\\jdks');
      
      if (!await tempDir.exists()) {
        await tempDir.create(recursive: true);
      }
      
      if (!await jdksDir.exists()) {
        await jdksDir.create(recursive: true);
      }
      
      // 下载文件路径
      final zipFilePath = '${tempDir.path}\\${javaVersion.replaceAll(' ', '_')}.zip';
      
      // 下载Java
      onProgress(0.1, '正在下载 $javaVersion...');
      
      // 创建HTTP客户端
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await client.send(request);
      
      if (response.statusCode != 200) {
        throw Exception('下载失败，HTTP状态码: ${response.statusCode}');
      }
      
      // 获取文件大小
      final contentLength = response.contentLength ?? 0;
      int received = 0;
      
      // 创建文件并写入
      final file = File(zipFilePath);
      final sink = file.openWrite();
      
      await response.stream.listen((chunk) {
        sink.add(chunk);
        received += chunk.length;
        final progress = contentLength > 0 ? received / contentLength : 0;
        onProgress(0.1 + progress * 0.7, '下载中: ${(progress * 100).toStringAsFixed(1)}%');
      }).asFuture();
      
      await sink.flush();
      await sink.close();
      
      // 解压缩文件
      onProgress(0.8, '正在解压缩...');
      
      // 读取zip文件
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // 创建目标文件夹
      final extractDir = '${jdksDir.path}\\${javaVersion.replaceAll(' ', '_')}';
      final extractDirEntity = Directory(extractDir);
      if (await extractDirEntity.exists()) {
        await extractDirEntity.delete(recursive: true);
      }
      await extractDirEntity.create(recursive: true);
      
      // 解压缩文件
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$extractDir\\$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('$extractDir\\$filename').createSync(recursive: true);
        }
      }
      
      // 查找java.exe
      onProgress(0.9, '配置Java环境...');
      final javaExePath = await _findJavaExecutable(extractDir);
      
      if (javaExePath == null) {
        throw Exception('无法找到Java可执行文件');
      }
      
      // 删除临时文件
      onProgress(0.95, '清理临时文件...');
      await file.delete();
      
      // 设置为当前Java路径
      _selectedJavaPath = javaExePath;
      
      // 添加到已保存的安装列表
      addJavaInstallation(javaExePath);
      
      onProgress(1.0, '安装完成！');
      return javaExePath;
    } catch (e) {
      print('下载Java出错: $e');
      onProgress(0, '下载失败: $e');
      rethrow;
    }
  }
  
  // 在安装目录中查找java.exe
  Future<String?> _findJavaExecutable(String directory) async {
    try {
      final dir = Directory(directory);
      await for (var entity in dir.list(recursive: true)) {
        if (entity is File && path.basename(entity.path) == 'java.exe') {
          return entity.path;
        }
      }
      return null;
    } catch (e) {
      print('查找Java可执行文件出错: $e');
      return null;
    }
  }

  Future<List<String>> getAvailableVersions() async {
    try {
      final response = await http.get(Uri.parse(_versionsUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final versions = (data['versions'] as List)
            .where((v) => v['type'] == 'release')
            .map((v) => v['id'] as String)
            .toList();
        return versions;
      }
      return [];
    } catch (e) {
      print('Error fetching versions: $e');
      return [];
    }
  }

  Future<bool> downloadVersion(String version) async {
    try {
      // Create version directory
      final versionDir = Directory(path.join(_gameDir, 'versions', version));
      await versionDir.create(recursive: true);

      // TODO: Implement actual version download logic
      // This would involve:
      // 1. Downloading version.json
      // 2. Downloading client.jar
      // 3. Downloading required libraries
      // 4. Downloading assets

      return true;
    } catch (e) {
      print('Error downloading version: $e');
      return false;
    }
  }

  Future<bool> launchGame(String version, String username) async {
    if (!await checkJavaInstallation()) {
      throw Exception('Java is not installed');
    }

    final versionDir = path.join(_gameDir, 'versions', version);
    if (!await Directory(versionDir).exists()) {
      await downloadVersion(version);
    }

    try {
      // Basic launch command - this is a simplified version
      // In a real implementation, you'd need to:
      // 1. Build the correct classpath with all required libraries
      // 2. Add proper JVM arguments
      // 3. Add game arguments from version.json
      // 4. Handle authentication
      final process = await Process.start(
        'java',
        [
          '-Xmx${_maxMemory}M',
          _jvmArgs,
          '-jar',
          path.join(versionDir, 'client.jar'),
          '--username',
          username,
          '--version',
          version,
          '--gameDir',
          _gameDir,
          '--assetsDir',
          path.join(_gameDir, 'assets'),
        ],
        runInShell: true,
      );

      // Handle process output
      process.stdout.transform(utf8.decoder).listen((data) {
        print('Game output: $data');
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        print('Game error: $data');
      });

      return true;
    } catch (e) {
      print('Error launching game: $e');
      return false;
    }
  }
}
