import 'package:flutter/material.dart';

class ResourcePackTab extends StatefulWidget {
  const ResourcePackTab({super.key});

  @override
  State<ResourcePackTab> createState() => _ResourcePackTabState();
}

class _ResourcePackTabState extends State<ResourcePackTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedVersion = "1.20.4";
  final List<String> _gameVersions = ["1.20.4", "1.19.4", "1.18.2", "1.16.5", "1.12.2", "1.7.10"];
  String _selectedResolution = "全部";
  final List<String> _resolutions = ["全部", "16x", "32x", "64x", "128x", "256x", "512x"];
  
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
              '材质包下载',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // 搜索和筛选选项
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: '搜索材质包',
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
                    items: _gameVersions.map((String version) {
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
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '材质分辨率',
                      border: OutlineInputBorder(),
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
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 常用分类
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryChip('全部'),
                _buildCategoryChip('写实'),
                _buildCategoryChip('卡通'),
                _buildCategoryChip('像素'),
                _buildCategoryChip('PBR'),
                _buildCategoryChip('中世纪'),
                _buildCategoryChip('梦幻'),
                _buildCategoryChip('简约'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 材质包列表 (示例框架)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '这里将显示材质包列表',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '您可以在此实现材质包列表和下载功能',
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
