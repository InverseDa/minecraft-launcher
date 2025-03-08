import 'package:flutter/material.dart';

class ModDownloadTab extends StatefulWidget {
  const ModDownloadTab({super.key});

  @override
  State<ModDownloadTab> createState() => _ModDownloadTabState();
}

class _ModDownloadTabState extends State<ModDownloadTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedVersion = "1.20.4";
  final List<String> _modVersions = ["1.20.4", "1.19.4", "1.18.2", "1.16.5", "1.12.2", "1.7.10"];
  
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
              'MOD下载中心',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // 搜索栏和版本选择
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: '搜索MOD',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '游戏版本',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedVersion,
                    items: _modVersions.map((String version) {
                      return DropdownMenuItem<String>(
                        value: version,
                        child: Text(version),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedVersion = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 常用MOD分类
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryChip('全部'),
                _buildCategoryChip('实用工具'),
                _buildCategoryChip('世界生成'),
                _buildCategoryChip('科技'),
                _buildCategoryChip('魔法'),
                _buildCategoryChip('冒险'),
                _buildCategoryChip('装饰'),
                _buildCategoryChip('优化'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // MOD列表 (示例框架)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.extension,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '这里将显示MOD列表',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '您可以在此实现MOD列表和下载功能',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('开始搜索'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: false,
      onSelected: (bool selected) {
        // 实现分类过滤逻辑
      },
    );
  }
}
