import '../models/pokemon.dart';
import '../repositories/pokemon_repository.dart';
import '../repositories/tipo_repository.dart';
import '../repositories/habilidade_repository.dart';
import '../repositories/stat_repository.dart';
import '../repositories/evolucao_repository.dart';
import 'pokemon_sync_controller.dart';

class PokemonController {
  final PokemonRepository pokemonRepo = PokemonRepository();
  final TipoRepository tipoRepo = TipoRepository();
  final HabilidadeRepository habilidadeRepo = HabilidadeRepository();
  final StatRepository statRepo = StatRepository();
  final EvolucaoRepository evolucaoRepo = EvolucaoRepository();

  final PokemonSyncController sync = PokemonSyncController();

  /// 🔄 atualiza banco
  Future<String> atualizar({Function(double)? onProgress}) async {
    return await sync.sincronizar(onProgress: onProgress);
  }

  /// 📋 lista pokemons
  Future<List<Pokemon>> listar() async {
    return await pokemonRepo.getAllPokemons();
  }

  /// ====== PARA TEXTO NARRADOR ======

  Future<List<String>> getTipos(int pokemonId) async {
    return await tipoRepo.getTiposDoPokemon(pokemonId);
  }

  Future<List<String>> getHabilidades(int pokemonId) async {
    return await habilidadeRepo.getHabilidadesDoPokemon(pokemonId);
  }

  Future<List<String>> getStats(int pokemonId) async {
    return await statRepo.getStatsDoPokemon(pokemonId);
  }

  Future<String?> getEvolucao(int pokemonId) async {
    return await evolucaoRepo.getEvolucaoNome(pokemonId);
  }
}
