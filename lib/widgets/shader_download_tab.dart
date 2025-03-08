import 'package:flutter/material.dart';

class ShaderDownloadTab extends StatefulWidget {
  const ShaderDownloadTab({super.key});

  @override
  State<ShaderDownloadTab> createState() => _ShaderDownloadTabState();
}

class _ShaderDownloadTabState extends State<ShaderDownloadTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedVersion = "1.20.4";
  final List<String> _gameVersions = ["1.20.4", "1.19.4", "1.18.2", "1.16.5", "1.12.2"];
  String _selectedPerformance = "全部";
  final List<String> _performances = ["全部", "低配", "中配", "高配", "顶配"];
  
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
              '光影包下载',
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
                      labelText: '搜索光影包',
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
                      labelText: '性能要求',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPerformance,
                    items: _performances.map((String performance) {
                      return DropdownMenuItem<String>(
                        value: performance,
                        child: Text(performance),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedPerformance = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 效果特性选项
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('体积光'),
                _buildFeatureChip('水面反射'),
                _buildFeatureChip('阴影'),
                _buildFeatureChip('光束'),
                _buildFeatureChip('动态光照'),
                _buildFeatureChip('抗锯齿'),
                _buildFeatureChip('PBR材质支持'),
                _buildFeatureChip('大气效果'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 光影包列表 (示例框架)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 9, // 示例数量
                itemBuilder: (context, index) {
                  return _buildShaderCard(
                    "光影包示例 ${index + 1}",
                    "这是一个光影包的示例说明，包含特性和效果描述。",
                    "1.20.4",
                    index % 3 == 0 ? "低配" : (index % 3 == 1 ? "中配" : "高配"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: false,
      onSelected: (bool selected) {
        // 实现特性过滤逻辑
      },
    );
  }
  
  Widget _buildShaderCard(String name, String description, String version, String performance) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 光影包预览图
          Container(
            height: 120,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.image,
                size: 48,
                color: Colors.grey[600],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        version,
                        style: const TextStyle(fontSize: 10),
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    Chip(
                      label: Text(
                        performance,
                        style: const TextStyle(fontSize: 10),
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      '下载',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
