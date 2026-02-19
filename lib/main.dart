import 'package:flutter/material.dart';
import 'database/db_helper.dart'; // ⭐ IMPORT NECESSÁRIO
import 'views/screens/pokedex_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.deleteDB(); // ⭐ APAGA BANCO (usar só 1 vez)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PokedexScreen());
  }
}
