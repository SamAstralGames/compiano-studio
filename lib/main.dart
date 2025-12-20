import 'package:flutter/material.dart';
import 'core/bridge.dart';
import 'dart:ffi';

void main() {
  // Initialisation du bridge FFI
  try {
    MXMLBridge.initialize();
    print('MXMLBridge initialized successfully');
  } catch (e) {
    print('Failed to initialize MXMLBridge: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mXMLConverter Boilerplate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'mXMLConverter Boilerplate Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Not initialized';
  Pointer<MXMLHandle>? _handle;

  void _createContext() {
    setState(() {
      try {
        _handle = MXMLBridge().create();
        _status = 'Context created: $_handle';
      } catch (e) {
        _status = 'Error creating context: $e';
      }
    });
  }

  void _destroyContext() {
    if (_handle != null) {
      MXMLBridge().destroy(_handle!);
      setState(() {
        _handle = null;
        _status = 'Context destroyed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'mXMLConverter Status:',
            ),
            Text(
              _status,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _handle == null ? _createContext : null,
                  child: const Text('Create Context'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _handle != null ? _destroyContext : null,
                  child: const Text('Destroy Context'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
