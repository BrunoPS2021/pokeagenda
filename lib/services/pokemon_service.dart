import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Map<String, dynamic>>> fetchPokemonList({
    int limit = 10000,
  }) async {
    final res = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));

    final data = jsonDecode(res.body);

    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<Map<String, dynamic>> fetchPokemonDetail(String url) async {
    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);

    return data;
  }

  /// ⭐ SPECIES (OBRIGATÓRIO PRA EVOLUÇÃO)

  Future<Map<String, dynamic>> fetchSpecies(String url) async {
    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);

    return data;
  }

  /// ⭐ EVOLUTION CHAIN

  Future<Map<String, dynamic>> fetchEvolutionChain(String url) async {
    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);

    return data;
  }
}
