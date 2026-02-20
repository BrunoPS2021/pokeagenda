import 'dart:async';

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

  final int concorrencia = 8;

  Future<String> sincronizar({
    int limit = 151,
    Function(double progresso)? onProgress,
  }) async {
    try {
      final listaAPI = await service.fetchPokemonList(limit: limit);

      /// ==========================================
      /// FASE 1 — BAIXA TODOS OS DETALHES
      /// ==========================================

      final List<Map<String, dynamic>> detalhes = [];

      for (int i = 0; i < listaAPI.length; i += concorrencia) {
        final bloco = listaAPI.skip(i).take(concorrencia);

        final results = await Future.wait(
          bloco.map((p) => service.fetchPokemonDetail(p['url'])),
        );

        detalhes.addAll(results);

        onProgress?.call(detalhes.length / listaAPI.length);
      }

      /// ==========================================
      /// FASE 2 — INSERE TODOS OS POKEMON
      /// ==========================================

      final Map<String, Pokemon> cachePokemon = {};
      final Set<String> chains = {};

      for (final detail in detalhes) {
        final pokemon = Pokemon(
          id: detail['id'],
          name: detail['name'],
          url: '',
          height: detail['height'],
          weight: detail['weight'],
        );

        await pokemonRepo.insertPokemon(pokemon);

        cachePokemon[pokemon.name] = pokemon;

        final pokemonId = pokemon.id;

        /// TIPOS
        for (final t in detail['types']) {
          final tipoId = await tipoRepo.insertTipo(t['type']['name']);
          await tipoRepo.insertPokemonTipo(pokemonId, tipoId, t['slot']);
        }

        /// HABILIDADES
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

        /// STATS
        for (final s in detail['stats']) {
          final statId = await statRepo.insertStat(s['stat']['name']);

          await statRepo.insertPokemonStat(
            pokemonId,
            statId,
            s['base_stat'],
            s['effort'],
          );
        }

        /// SPRITE
        final sprites = detail['sprites'];
        if (sprites['front_default'] != null) {
          await spriteRepo.insertSprite(
            pokemonId,
            sprites['front_default'],
            'front_default',
          );
        }

        /// CHAIN
        final species = await service.fetchSpecies(detail['species']['url']);
        chains.add(species['evolution_chain']['url']);
      }

      /// ==========================================
      /// FASE 3 — AGORA SALVA EVOLUÇÕES
      /// ==========================================

      for (final url in chains) {
        final chainData = await service.fetchEvolutionChain(url);
        await _salvarChain(chainData['chain'], cachePokemon);
      }

      await historicoRepo.insertHistorico(
        HistoricoAtualizacao(
          countPokemons: cachePokemon.length,
          dataUltimaAtualizacao: DateTime.now().toIso8601String(),
          sucesso: true,
        ),
      );

      return "SYNC OK — ${cachePokemon.length} pokémons";
    } catch (e) {
      return "Erro sincronizando: $e";
    }
  }

  Future<void> _salvarChain(
    Map chain,
    Map<String, Pokemon> cachePokemon,
  ) async {
    final atual = cachePokemon[chain['species']['name']];
    if (atual == null) return;

    for (final evo in chain['evolves_to']) {
      final prox = cachePokemon[evo['species']['name']];
      if (prox == null) continue;

      int? nivel;

      if (evo['evolution_details'] != null &&
          evo['evolution_details'].isNotEmpty) {
        nivel = evo['evolution_details'][0]['min_level'];
      }

      await evolucaoRepo.insertEvolucao(atual.id, prox.id, 'level', nivel);

      await _salvarChain(evo, cachePokemon);
    }
  }
}
