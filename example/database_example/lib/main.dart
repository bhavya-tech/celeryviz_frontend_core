import 'package:celeryviz_frontend_core/celeryviz_frontend_core.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class DatabaseDataSource extends StatelessWidget {
  final BackendQueriableDataSource _dataSource;

  DatabaseDataSource({
    super.key,
    required double initialTimestamp,
    required String endpoint,
  }) : _dataSource = BackendQueriableDataSource(
         endpoint: endpoint,
         initialTimestamp: initialTimestamp,
       );

  @override
  Widget build(BuildContext context) {
    return CeleryMonitoringCore(dataSource: _dataSource);
  }
}

// A simple screen to input a double value and navigate to another screen
// displaying that value.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _doubleController = TextEditingController();
  final TextEditingController _hostController = TextEditingController(
    text: 'http://localhost:9095/data/clickhouse/',
  );

  String? _doubleError;

  void _submit() {
    final double? value = double.tryParse(_doubleController.text.trim());

    if (value == null) {
      setState(() {
        _doubleError = 'Please enter a valid double value';
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DatabaseDataSource(
          initialTimestamp: value,
          endpoint: _hostController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _doubleController.dispose();
    _hostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Configuration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Hostname input
                TextField(
                  controller: _hostController,
                  decoration: const InputDecoration(
                    labelText: 'Hostname',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Double input
                TextField(
                  controller: _doubleController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Double value',
                    errorText: _doubleError,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
