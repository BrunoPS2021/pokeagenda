import 'package:flutter/material.dart';
import 'database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco e cria as tabelas
  await DBHelper.database;

  runApp(const PokeAgendaApp());
}

class PokeAgendaApp extends StatelessWidget {
  const PokeAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeAgenda',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('PokeAgenda')),
        body: const Center(
          child: Text(
            'Banco criado com sucesso!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
