import 'package:flutter/material.dart';
import '../../controllers/pokemon_controller.dart';
import '../../models/pokemon.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final controller = PokemonController();

  List<Pokemon> lista = [];
  Pokemon? selecionado;

  bool loading = true;
  double progresso = 0;
  String mensagem = "";

  int indexSelecionado = 0;

  final focusNode = FocusNode();

  /// 👇 CONTROLLER PARA SCROLL AUTOMÁTICO
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() {
      loading = true;
      progresso = 0;
    });

    mensagem = await controller.atualizar(
      onProgress: (p) {
        setState(() => progresso = p);
      },
    );

    lista = await controller.listar();

    if (lista.isNotEmpty) {
      selecionado = lista.first;
      indexSelecionado = 0;
    }

    setState(() => loading = false);

    focusNode.requestFocus();
  }

  String img(Pokemon p) =>
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${p.id}.png";

  /// TEXTO POKEDEX
  Future<String> narracao(Pokemon p) async {
    final tipos = await controller.getTipos(p.id);
    final tiposStr = tipos.isNotEmpty ? tipos.join(', ') : "desconhecido";

    final habilidades = await controller.getHabilidades(p.id);
    final habilidadesStr = habilidades.isNotEmpty
        ? habilidades.join(', ')
        : "sem ataques";

    final evolucao = await controller.getEvolucao(p.id);

    final evolucaoStr = evolucao != null
        ? "sua evolução é $evolucao"
        : "ele já está em sua evolução máxima";

    return "${p.name.toUpperCase()}, o ${p.name.toUpperCase()} é do tipo $tiposStr, "
        "seus ataques incluem $habilidadesStr, "
        "$evolucaoStr.";
  }

  /// MOVER NA LISTA
  void mover(int delta) {
    if (lista.isEmpty) return;

    indexSelecionado += delta;

    if (indexSelecionado < 0) indexSelecionado = 0;
    if (indexSelecionado >= lista.length) indexSelecionado = lista.length - 1;

    selecionado = lista[indexSelecionado];

    /// 👇 FAZ A LISTA ROLAR AUTOMATICAMENTE
    scrollController.animateTo(
      indexSelecionado * 56,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(value: progresso),
                const SizedBox(height: 20),
                Text("${(progresso * 100).toInt()}%"),
                const SizedBox(height: 10),
                const Text("Atualizando Pokédex..."),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ULTRA POKEDEX"),
        actions: [
          Tooltip(
            message: mensagem,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),

      body: RawKeyboardListener(
        focusNode: focusNode,
        autofocus: true,

        onKey: (event) {
          if (event.logicalKey.keyLabel == "Arrow Down") mover(1);
          if (event.logicalKey.keyLabel == "Arrow Up") mover(-1);
        },

        child: Row(
          children: [
            /// =======================
            /// LISTA + SETA CIMA + SETA BAIXO
            /// =======================
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  /// SETA CIMA
                  IconButton(
                    iconSize: 40,
                    onPressed: () => mover(-1),
                    icon: const Icon(Icons.keyboard_arrow_up),
                  ),

                  /// LISTA
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: lista.length,
                      itemBuilder: (_, i) {
                        final p = lista[i];

                        return ListTile(
                          title: Text(p.name.toUpperCase()),
                          selected: selecionado?.id == p.id,
                          onTap: () {
                            indexSelecionado = i;
                            selecionado = p;
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),

                  /// SETA BAIXO
                  IconButton(
                    iconSize: 40,
                    onPressed: () => mover(1),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            /// =======================
            /// IMAGEM + TEXTO
            /// =======================
            Expanded(
              flex: 3,
              child: selecionado == null
                  ? const Center(child: Text("Selecione um Pokémon"))
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(img(selecionado!), height: 280),

                          const SizedBox(height: 30),

                          FutureBuilder<String>(
                            future: narracao(selecionado!),
                            builder: (_, snap) {
                              if (!snap.hasData) {
                                return const CircularProgressIndicator();
                              }

                              return Text(
                                snap.data!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.5,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
