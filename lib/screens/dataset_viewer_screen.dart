import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/services/dataset_service.dart';

class DatasetViewerScreen extends StatefulWidget {
  const DatasetViewerScreen({super.key});

  @override
  State<DatasetViewerScreen> createState() => _DatasetViewerScreenState();
}

class _DatasetViewerScreenState extends State<DatasetViewerScreen> {
  List<Map<String, dynamic>>? _dataset;
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataset();
  }

  Future<void> _loadDataset() async {
    try {
      final db = await DatasetService.database;
      // Use the public getter instead of the private variable
      final data = await db.query(DatasetService.tableName, limit: 100);
      final stats = await DatasetService.getDatasetStats();

      setState(() {
        _dataset = data;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dataset: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Dataset'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
      ),
      backgroundColor: AppTheme.darkBackground,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.oliveGreen),
              ),
            )
          : Column(
              children: [
                _buildStatsCard(),
                const SizedBox(height: 16),
                Expanded(child: _buildDataTable()),
              ],
            ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      color: AppTheme.cardBackground,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dataset Statistics',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_stats != null) ...[
              Text(
                'Total Records: ${_stats!['totalRecords']}',
                style: const TextStyle(color: AppTheme.textLight),
              ),
              const SizedBox(height: 8),
              const Text(
                'Claim Status Distribution:',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...(_stats!['claimStatusDistribution'] as List).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text(
                    '${item['claim_status']}: ${item['count']}',
                    style: const TextStyle(color: AppTheme.textDark),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    if (_dataset == null || _dataset!.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppTheme.textDark),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _dataset![0].keys.map((key) {
          return DataColumn(
            label: Text(
              key,
              style: const TextStyle(
                color: AppTheme.lightOlive,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
        rows: _dataset!.map((row) {
          return DataRow(
            cells: row.values.map((value) {
              return DataCell(
                Text(
                  value?.toString() ?? '',
                  style: const TextStyle(color: AppTheme.textLight),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
