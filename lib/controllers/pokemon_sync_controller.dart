import '../models/historico_atualizacao.dart';
import '../repositories/pokemon_repository.dart';
import '../repositories/tipo_repository.dart';
import '../repositories/habilidade_repository.dart';
import '../repositories/stat_repository.dart';
import '../repositories/sprite_repository.dart';
import '../repositories/evolucao_repository.dart';
import '../repositories/historico_repository.dart';
import '../services/pokemon_service.dart';
import '../models/pokemon.dart';

class PokemonSyncController {
  final PokemonService service = PokemonService();

  final PokemonRepository pokemonRepo = PokemonRepository();
  final TipoRepository tipoRepo = TipoRepository();
  final HabilidadeRepository habilidadeRepo = HabilidadeRepository();
  final StatRepository statRepo = StatRepository();
  final SpriteRepository spriteRepo = SpriteRepository();
  final EvolucaoRepository evolucaoRepo = EvolucaoRepository();
  final HistoricoRepository historicoRepo = HistoricoRepository();

  Future<String> sincronizar({
    int limit = 200,
    Function(double progresso)? onProgress,
  }) async {
    try {
      final listaAPI = await service.fetchPokemonList(limit: limit);

      int inseridos = 0;

      /// ⭐ GUARDA TODAS AS CHAINS PARA PROCESSAR DEPOIS
      final Set<String> todasChains = {};

      /// ======================================================
      /// PRIMEIRO: BAIXA TODOS POKEMONS
      /// ======================================================

      for (final p in listaAPI) {
        final detail = await service.fetchPokemonDetail(p['url']);

        final pokemon = Pokemon(
          id: detail['id'],
          name: detail['name'],
          url: p['url'],
          height: detail['height'],
          weight: detail['weight'],
        );

        await pokemonRepo.insertPokemon(pokemon);
        final pokemonId = pokemon.id;

        /// ================= TIPOS
        for (final t in detail['types']) {
          final tipoId = await tipoRepo.insertTipo(t['type']['name']);
          await tipoRepo.insertPokemonTipo(pokemonId, tipoId, t['slot']);
        }

        /// ================= HABILIDADES
        for (final h in detail['abilities']) {
          final habId = await habilidadeRepo.insertHabilidade(
            h['ability']['name'],
          );

          await habilidadeRepo.insertPokemonHabilidade(
            pokemonId,
            habId,
            h['is_hidden'] ?? false,
            h['slot'],
          );
        }

        /// ================= STATS
        for (final s in detail['stats']) {
          final statId = await statRepo.insertStat(s['stat']['name']);

          await statRepo.insertPokemonStat(
            pokemonId,
            statId,
            s['base_stat'],
            s['effort'],
          );
        }

        /// ================= SPRITE
        final sprites = detail['sprites'];

        if (sprites['front_default'] != null) {
          await spriteRepo.insertSprite(
            pokemonId,
            sprites['front_default'],
            'front_default',
          );
        }

        /// ================= GUARDA CHAIN PRA DEPOIS
        final speciesUrl = detail['species']['url'];
        final species = await service.fetchSpecies(speciesUrl);

        final chainUrl = species['evolution_chain']['url'];

        todasChains.add(chainUrl);

        inseridos++;

        onProgress?.call(inseridos / listaAPI.length);
      }

      /// ======================================================
      /// SEGUNDO: AGORA SIM SALVA EVOLUÇÕES
      /// ======================================================

      for (final chainUrl in todasChains) {
        final chainData = await service.fetchEvolutionChain(chainUrl);

        await _salvarChain(chainData['chain']);
      }

      /// ======================================================

      await historicoRepo.insertHistorico(
        HistoricoAtualizacao(
          countPokemons: inseridos,
          dataUltimaAtualizacao: DateTime.now().toIso8601String(),
          sucesso: true,
        ),
      );

      return "Sincronização OK — $inseridos pokémons";
    } catch (e) {
      return "Erro sincronizando: $e";
    }
  }

  /// ======================================================
  /// SALVA EVOLUÇÃO RECURSIVA
  /// ======================================================

  Future<void> _salvarChain(Map chain) async {
    final atualNome = chain['species']['name'];

    final atual = await pokemonRepo.getPokemonByName(atualNome);

    if (atual == null) {
      return;
    }

    final atualId = atual.id;

    for (final evo in chain['evolves_to']) {
      final proxNome = evo['species']['name'];

      final prox = await pokemonRepo.getPokemonByName(proxNome);

      if (prox == null) {
        continue;
      }

      final proxId = prox.id;

      int? nivel;

      if (evo['evolution_details'] != null &&
          evo['evolution_details'].isNotEmpty) {
        nivel = evo['evolution_details'][0]['min_level'];
      }

      await evolucaoRepo.insertEvolucao(atualId, proxId, 'level', nivel);

      /// recursivo
      await _salvarChain(evo);
    }
  }
}
