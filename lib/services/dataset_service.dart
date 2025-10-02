import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DatasetService {
  static Database? _database;
  static const String _datasetPath = 'assets/data/insurance_dataset.csv';
  static const String _tableName = 'insurance_data';
  static const String _datasetFileName = 'insurance_dataset.csv';

  // Public getter for table name
  static String get tableName => _tableName;

  // Initialize the database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database from CSV
  static Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, 'insurance_dataset.db');

    // Check if database already exists
    final exists = await databaseExists(dbPath);

    if (!exists) {
      // Create the database from CSV
      final db = await openDatabase(dbPath, version: 1);
      await _createTableFromCSV(db);
      return db;
    } else {
      // Open existing database
      return await openDatabase(dbPath, version: 1);
    }
  }

  // Create table and populate with CSV data
  static Future<void> _createTableFromCSV(Database db) async {
    // Read CSV from assets
    final csvData = await rootBundle.loadString(_datasetPath);
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(
      csvData,
    );

    // Get headers (column names)
    final headers = rowsAsListOfValues[0];

    // Create table with dynamic columns
    final columnDefinitions = headers
        .map((header) => '$header TEXT')
        .join(', ');
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDefinitions
      )
    ''');

    // Insert data
    final batch = db.batch();
    for (int i = 1; i < rowsAsListOfValues.length; i++) {
      final row = rowsAsListOfValues[i];
      final placeholders = List.filled(row.length, '?').join(', ');
      batch.execute(
        'INSERT INTO $_tableName (${headers.join(', ')}) VALUES ($placeholders)',
        row,
      );
    }
    await batch.commit();
  }

  // Get dataset records
  static Future<List<Map<String, dynamic>>> getDatasetRecords({
    int limit = 100,
  }) async {
    final db = await database;
    return await db.query(_tableName, limit: limit);
  }

  // Search the dataset for relevant records
  static Future<List<Map<String, dynamic>>> searchDataset(
    String query, {
    int limit = 5,
  }) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: '''
        policy_id LIKE ? OR 
        subscription_length LIKE ? OR 
        vehicle_age LIKE ? OR 
        customer_age LIKE ? OR 
        region_code LIKE ? OR 
        region_density LIKE ? OR 
        segment LIKE ? OR 
        model LIKE ? OR 
        fuel_type LIKE ? OR 
        claim_status LIKE ?
      ''',
      whereArgs: List.filled(10, '%$query%'),
      limit: limit,
    );
    return results;
  }

  // NEW: Get specific record by policy_id
  static Future<Map<String, dynamic>?> getRecordByPolicyId(
    String policyId,
  ) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'policy_id = ?',
      whereArgs: [policyId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // NEW: Get records by claim status
  static Future<List<Map<String, dynamic>>> getRecordsByClaimStatus(
    String claimStatus,
  ) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: 'claim_status = ?',
      whereArgs: [claimStatus],
    );
  }

  // NEW: Get records by vehicle age range
  static Future<List<Map<String, dynamic>>> getRecordsByVehicleAgeRange(
    int minAge,
    int maxAge,
  ) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: 'CAST(vehicle_age AS INTEGER) BETWEEN ? AND ?',
      whereArgs: [minAge, maxAge],
    );
  }

  // Get dataset statistics
  static Future<Map<String, dynamic>> getDatasetStats() async {
    final db = await database;
    final totalRecords = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableName'),
    );

    final claimStatusCounts = await db.rawQuery('''
      SELECT claim_status, COUNT(*) as count 
      FROM $_tableName
      GROUP BY claim_status
    ''');

    return {
      'totalRecords': totalRecords,
      'claimStatusDistribution': claimStatusCounts,
    };
  }

  // Close the database
  static Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
