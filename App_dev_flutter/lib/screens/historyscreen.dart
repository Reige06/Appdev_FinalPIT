import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> readings = [];

  @override
  void initState() {
    super.initState();
    fetchReadings();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchReadings();
    });
  }

  Future<void> fetchReadings() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://app-dev-backend.onrender.com/data');
      final data = response.data;

      setState(() {
        readings = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print('Failed to fetch energy data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data History'),
        backgroundColor: const Color.fromARGB(255, 24, 147, 255),
      ),
      backgroundColor: const Color.fromRGBO(227, 242, 253, 1),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 12,
                dataRowMinHeight: 32,
                dataRowMaxHeight: 38,
                headingRowHeight: 38,
                columns: const [
                  DataColumn(
                    label: Text('ID', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Voltage', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Current', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Power', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('kWh', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Timestamp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: readings.map((item) {
                  final timestampRaw = item['timestamp'];
                  final timestamp = timestampRaw != null
                      ? DateTime.tryParse(timestampRaw)?.toLocal()
                      : null;
                  final formattedTimestamp = timestamp != null
                      ? '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
                          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}'
                      : 'N/A';

                  return DataRow(
                    cells: [
                      DataCell(Text(item['id']?.toString() ?? 'N/A', style: const TextStyle(fontSize: 11))),
                      DataCell(Text(item['voltage']?.toStringAsFixed(2) ?? 'N/A', style: const TextStyle(fontSize: 11))),
                      DataCell(Text(item['current']?.toStringAsFixed(2) ?? 'N/A', style: const TextStyle(fontSize: 11))),
                      DataCell(Text(item['power']?.toStringAsFixed(2) ?? 'N/A', style: const TextStyle(fontSize: 11))),
                      DataCell(Text(item['kwh']?.toStringAsFixed(4) ?? 'N/A', style: const TextStyle(fontSize: 11))),
                      DataCell(Text(formattedTimestamp, style: const TextStyle(fontSize: 11))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
