import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameService {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  final String _gameDir = path.join(Directory.current.path, 'minecraft');
  final String _versionsUrl = 'https://launchermeta.mojang.com/mc/game/version_manifest.json';

  Future<bool> checkJavaInstallation() async {
    try {
      ProcessResult result = await Process.run('java', ['-version']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
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
          '-Xmx2G',
          '-XX:+UnlockExperimentalVMOptions',
          '-XX:+UseG1GC',
          '-XX:G1NewSizePercent=20',
          '-XX:G1ReservePercent=20',
          '-XX:MaxGCPauseMillis=50',
          '-XX:G1HeapRegionSize=32M',
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
