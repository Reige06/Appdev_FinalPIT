import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'historyscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double power = 0.0;
  double current = 0.0;
  double voltage = 0.0;
  double energy = 0.0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchLatestReadings();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      fetchLatestReadings();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchLatestReadings() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://app-dev-backend.onrender.com/data');
      final data = response.data;

      if (data.isNotEmpty) {
        final latestReading = data.last;
        setState(() {
          power = double.tryParse(latestReading['power'].toString()) ?? 0.0;
          current = double.tryParse(latestReading['current'].toString()) ?? 0.0;
          voltage = double.tryParse(latestReading['voltage'].toString()) ?? 0.0;
          energy = double.tryParse(latestReading['kwh'].toString()) ?? 0.0;
        });
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('EnergyTrack'),
      backgroundColor: const Color.fromARGB(255, 24, 147, 255),
    ),
    backgroundColor: const Color.fromRGBO(227, 242, 253, 1),
    body: Center( 
      child: SingleChildScrollView( 
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBox('Power', '${power.toStringAsFixed(2)} W', Colors.blue[100],
                logoPath: 'assets/blue-thunder.png'),
            _buildBox('Current', '${current.toStringAsFixed(2)} A',
                const Color.fromARGB(255, 255, 236, 178),
                logoPath: 'assets/current.png'),
            _buildBox('Voltage', '${voltage.toStringAsFixed(2)} V',
                const Color.fromARGB(132, 255, 186, 250),
                logoPath: 'assets/voltage.png'),
            _buildBox('Energy', '${energy.toStringAsFixed(2)} kWh',
                const Color.fromARGB(176, 193, 255, 189),
                logoPath: 'assets/energy.png'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Check Data History'),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildBox(String label, String value, Color? color,
    {String? logoPath}) {
  return Container(
    height: 140.0,
    width: 200.0,
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (logoPath != null)
              Image.asset(
                logoPath,
                width: 24.0,
                height: 24.0,
              ),
            if (logoPath != null) const SizedBox(width: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
      ],
    ),
  );
}
}
