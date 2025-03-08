import 'package:flutter/material.dart';
import '../services/game_service.dart';

class VersionDownloadTab extends StatefulWidget {
  const VersionDownloadTab({super.key});

  @override
  State<VersionDownloadTab> createState() => _VersionDownloadTabState();
}

class _VersionDownloadTabState extends State<VersionDownloadTab> {
  final GameService _gameService = GameService();
  List<String> versions = [];
  String? selectedVersion;
  bool isLoading = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? currentDownloadFile;

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });
    
    try {
      final availableVersions = await _gameService.getAvailableVersions();
      
      if (!mounted) return;
      
      setState(() {
        versions = availableVersions;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载版本失败: $e')),
      );
    }
  }

  Future<void> _downloadVersion() async {
    if (selectedVersion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择一个版本')),
      );
      return;
    }

    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      await _gameService.downloadVersion(selectedVersion!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('版本 $selectedVersion 下载完成')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下载失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
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
              '游戏版本下载',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // 版本筛选选项
            Row(
              children: [
                const Text('筛选:'),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('正式版'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('快照'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('远古版本'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 版本列表
            Expanded(
              child: isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: versions.length,
                    itemBuilder: (context, index) {
                      final version = versions[index];
                      return ListTile(
                        title: Text(version),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: isDownloading ? null : () {
                            setState(() {
                              selectedVersion = version;
                            });
                            _downloadVersion();
                          },
                        ),
                        selected: selectedVersion == version,
                        onTap: () {
                          setState(() {
                            selectedVersion = version;
                          });
                        },
                      );
                    },
                  ),
            ),
            
            // 下载进度
            if (isDownloading) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: downloadProgress > 0 ? downloadProgress : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(downloadProgress > 0 
                    ? '${(downloadProgress * 100).toStringAsFixed(1)}%' 
                    : '准备中...'
                  ),
                ],
              ),
              if (currentDownloadFile != null) ...[
                const SizedBox(height: 8),
                Text('下载: $currentDownloadFile'),
              ],
            ],
            
            const SizedBox(height: 16),
            
            // 下载按钮
            if (selectedVersion != null && !isDownloading)
              ElevatedButton.icon(
                onPressed: _downloadVersion,
                icon: const Icon(Icons.download),
                label: Text('下载 $selectedVersion'),
              ),
          ],
        ),
      ),
    );
  }
}
