import 'package:flutter/material.dart';
import 'package:roundrobin/telasimulador.dart';

void main() {
  runApp(const SimuladorEscalonamentoApp());
}

class SimuladorEscalonamentoApp extends StatelessWidget {
  const SimuladorEscalonamentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TelaSimulador(),
    );
  }
}
