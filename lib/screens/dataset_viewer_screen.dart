// screens/dataset_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/services/dataset_service.dart';
import 'package:insurance_claim_agent/screens/home_screen.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatasetViewerScreen extends StatefulWidget {
  const DatasetViewerScreen({super.key});

  @override
  State<DatasetViewerScreen> createState() => _DatasetViewerScreenState();
}

class _DatasetViewerScreenState extends State<DatasetViewerScreen> {
  List<Map<String, dynamic>>? _dataset;
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDataset();
  }

  Future<void> _loadDataset() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check if the database exists
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDirectory.path, 'insurance_dataset.db');
      final exists = await databaseExists(dbPath);
      
      if (!exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Database does not exist. Please make sure the CSV file is in the assets folder and try again.';
        });
        return;
      }

      // Check if the CSV file is accessible - Fixed: Remove this method call
      // final csvAccessible = await DatasetService.isCsvFileAccessible();
      // if (!csvAccessible) {
      //   setState(() {
      //     _isLoading = false;
      //     _errorMessage = 'CSV file is not accessible. Please make sure it\'s in the assets folder.';
      //   });
      //   return;
      // }

      // Use the new method
      final data = await DatasetService.getDatasetRecords(limit: 100);
      final stats = await DatasetService.getDatasetStats();
      
      setState(() {
        _dataset = data;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading dataset: ${e.toString()}';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dataset: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Dataset'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDataset,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      backgroundColor: AppTheme.darkBackground,
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Fixed: Use context parameter correctly
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.question_answer),
        tooltip: 'Ask about this data',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.oliveGreen),
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load dataset',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: AppTheme.textDark,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDataset,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        _buildStatsCard(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildDataTable(),
        ),
      ],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.data_array,
              color: AppTheme.textDark,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No data available',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The dataset might be empty or not loaded properly',
              style: TextStyle(
                color: AppTheme.textDark,
                fontSize: 14,
              ),
            ),
          ],
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