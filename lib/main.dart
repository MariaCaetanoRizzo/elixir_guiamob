import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Guarda as informações de um personagem lidas do arquivo do elenco.
/// A tela usa este modelo para mostrar nome, descrição e imagem sem acessar o JSON diretamente.
class Personagem {
  const Personagem({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.descricaoDetalhada,
    required this.principal,
    required this.imagem,
  });

  final int id; // Número que diferencia este personagem dos demais.
  final String nome; // Nome mostrado no carrossel e na lista do elenco.
  final String descricao; // Texto que explica quem é o personagem.
  final String descricaoDetalhada; // Texto completo exibido em "Saber mais".
  final bool principal; // Informa se ele faz parte do grupo principal.
  final String imagem; // Caminho de uma imagem do app ou endereço da internet.

  /// Lê os campos de um personagem no JSON e cria um objeto Personagem.
  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      descricaoDetalhada:
          json['descricaoDetalhada'] as String? ?? json['descricao'] as String,
      principal: json['principal'] as bool,
      imagem: json['imagem'] as String? ?? '',
    );
  }
}

// Guarda a leitura do elenco para que as telas compartilhem o mesmo resultado.
Future<List<Personagem>>? _personagensEmCarregamento;

/// Lê o arquivo do elenco, transforma os registros em Personagem e usa até 16.
/// A leitura fica guardada para não abrir o mesmo arquivo várias vezes.
Future<List<Personagem>> carregarPersonagens() {
  return _personagensEmCarregamento ??= rootBundle
      .loadString('json/arquivo.json')
      .then((conteudo) {
        // O JSON chega como dados genéricos; aqui cada registro vira um Personagem.
        final dados = jsonDecode(conteudo) as List<dynamic>;
        return dados
            .map((item) => Personagem.fromJson(item as Map<String, dynamic>))
            .take(16)
            .toList();
      });
}

const Map<int, String> _spritesPersonagens = {
  1: 'img/personagens/carlos.jpeg',
  2: 'img/personagens/ryta.jpeg',
  3: 'img/personagens/olga.png',
  4: 'img/personagens/rafael.png',
  5: 'img/personagens/Neuza.png',
  6: 'img/personagens/fortunato.PNG',
  8: 'img/personagens/iris.png',
  10: 'img/personagens/caio.PNG',
  11: 'img/personagens/clarice.PNG',
  12: 'img/personagens/Enzo.PNG',
  13: 'img/personagens/slvya.PNG',
  15: 'img/personagens/michael.PNG',
  16: 'img/personagens/CharlotteN.PNG',
};

const Map<int, String> _rendersPersonagens = {
  1: 'img/rendersEucaliptos/CarlosRender.png',
  2: 'img/rendersEucaliptos/RitaRender.png',
  6: 'img/rendersEucaliptos/FortunadoRender.png',
  8: 'img/rendersEucaliptos/IrisRender.png',
  9: 'img/rendersEucaliptos/LeticiaRender.png',
  10: 'img/rendersEucaliptos/CaioRender.png',
  11: 'img/rendersEucaliptos/ClariceRender.png',
  12: 'img/rendersEucaliptos/EnzoRender.png',
  13: 'img/rendersEucaliptos/SilviaRender.png',
  16: 'img/rendersEucaliptos/CharlotteRender.png',
};

String imagemSpritePersonagem(Personagem personagem) =>
    _spritesPersonagens[personagem.id] ??
    _rendersPersonagens[personagem.id] ??
    personagem.imagem;

String imagemRenderPersonagem(Personagem personagem) =>
    _rendersPersonagens[personagem.id] ?? personagem.imagem;

/// Reúne os textos e a imagem que uma página precisa para ser montada.
class ConteudoPagina {
  const ConteudoPagina({
    required this.titulo,
    required this.imagem,
    required this.paragrafos,
    required this.itens,
    this.figuras = const [],
    this.imagemComplementar,
    this.descricaoComplementar,
  });

  final String titulo; // Texto que aparece no topo e no conteúdo da página.
  final String imagem; // Imagem principal mostrada antes do texto.
  final String? imagemComplementar;
  final String? descricaoComplementar;
  final List<String>
  paragrafos; // Partes do texto, separadas para facilitar a leitura.
  final List<String> itens; // Lista opcional de destaques abaixo do texto.
  final List<FiguraConteudo>
  figuras; // Imagens identificadas por legenda e fonte.

  // Junta os parágrafos com uma linha em branco entre eles.
  String get texto => paragrafos.join('\n\n');

  /// Lê a seção de uma página no JSON e cria os dados que a tela vai exibir.
  factory ConteudoPagina.fromJson(Map<String, dynamic> json) {
    return ConteudoPagina(
      titulo: json['titulo'] as String,
      imagem: json['imagem'] as String,
      paragrafos: List<String>.from(json['paragrafos'] as List<dynamic>),
      itens: List<String>.from(json['itens'] as List<dynamic>? ?? const []),
      figuras: (json['figuras'] as List<dynamic>? ?? const [])
          .map((item) => FiguraConteudo.fromJson(item as Map<String, dynamic>))
          .toList(),
      imagemComplementar: json['imagemComplementar'] as String?,
      descricaoComplementar: json['descricaoComplementar'] as String?,
    );
  }
}

/// Representa uma imagem de apoio com identificação e fonte para a página.
class FiguraConteudo {
  const FiguraConteudo({
    required this.titulo,
    required this.imagem,
    required this.fonte,
    this.aposParagrafo = -1,
  });

  final String titulo;
  final String imagem;
  final String fonte;
  final int aposParagrafo;

  factory FiguraConteudo.fromJson(Map<String, dynamic> json) {
    return FiguraConteudo(
      titulo: json['titulo'] as String,
      imagem: json['imagem'] as String,
      fonte: json['fonte'] as String,
      aposParagrafo: json['aposParagrafo'] as int? ?? -1,
    );
  }
}

/// Agrupa os dados das duas páginas que usam conteúdo do arquivo projeto.json.
class ConteudoApp {
  const ConteudoApp({required this.historia, required this.projeto});

  final ConteudoPagina historia;
  final ConteudoPagina projeto;

  /// Cria cada página a partir da seção com o mesmo nome no JSON.
  factory ConteudoApp.fromJson(Map<String, dynamic> json) {
    return ConteudoApp(
      historia: ConteudoPagina.fromJson(
        json['historia'] as Map<String, dynamic>,
      ),
      projeto: ConteudoPagina.fromJson(json['projeto'] as Map<String, dynamic>),
    );
  }
}

// Mantém uma única leitura de projeto.json para História e Projeto.
Future<ConteudoApp>? _conteudoEmCarregamento;

/// Abre projeto.json e converte os dados para o modelo usado pelas telas.
/// O Future guardado permite que as três páginas reutilizem a mesma leitura.
Future<ConteudoApp> carregarConteudo() {
  return _conteudoEmCarregamento ??= rootBundle
      .loadString('json/projeto.json')
      .then((conteudo) {
        final dados = jsonDecode(conteudo) as Map<String, dynamic>;
        return ConteudoApp.fromJson(dados);
      });
}

// O Flutter começa por aqui e mostra MainApp como widget principal.
void main() {
  runApp(const MainApp());
}

// Cores reaproveitadas nas telas para manter o visual do app consistente.
const roxoElixir = Color(0xFF6A1B9A);
const roxoBotao = Color(0xFF9B59B6);
const roxoEscuro = Color(0xFF35104F);
const roxoClaro = Color(0xFFF3E8FA);

/// Cria a página inicial e permite abrir as outras páginas do app.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // O primeiro controller move a página para cima e para baixo.
  final ScrollController _scrollController = ScrollController();
  // O segundo controller muda o personagem mostrado no carrossel.
  final PageController _pageController = PageController();
  // Permite abrir as outras páginas sem perder a pilha de navegação do app.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // Mantém a mesma leitura do elenco enquanto a tela inicial estiver aberta.
  final Future<List<Personagem>> _personagensFuture = carregarPersonagens();
  // Guarda o número da página selecionada para atualizar o contador.
  int _indicePersonagemAtual = 0;

  // Marcam as seções da página inicial para que possam ser localizadas.
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // O botão da direita avança uma página; no final, volta ao primeiro personagem.
  Future<void> _proximoPersonagem() async {
    // Espera o JSON terminar de carregar antes de conferir quantos personagens há.
    final personagens = await _personagensFuture;
    if (_indicePersonagemAtual < personagens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // O botão da esquerda volta uma página; no começo, vai ao último personagem.
  Future<void> _personagemAnterior() async {
    final personagens = await _personagensFuture;
    if (_indicePersonagemAtual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        personagens.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // Adiciona a página escolhida à navegação para que o usuário possa voltar depois.
  void _navegarParaPagina(Widget pagina) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

  Widget _construirItemNavegacao(String titulo, IconData icone, Widget pagina) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _navegarParaPagina(pagina),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirTituloSecao(
    String titulo,
    String subtitulo,
    IconData icone,
  ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: roxoClaro,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icone, color: roxoElixir, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontFamily: 'Redact',
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: roxoEscuro,
                ),
              ),
              Text(
                subtitulo,
                style: TextStyle(
                  fontSize: 12,
                  color: roxoEscuro.withValues(alpha: 0.58),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirCardImagemSecao(
    String titulo,
    String subtitulo,
    String imagem,
    IconData icone,
    Widget pagina,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: roxoElixir.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: roxoEscuro.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: _construirTituloSecao(titulo, subtitulo, icone),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  titulo == 'História'
                      ? Container(
                          width: double.infinity,
                          height: 190,
                          color: const Color(0xFFF7F5F9),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    'img/logoelixir.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Container(
                                width: 3,
                                height: 150,
                                color: roxoElixir,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    'img/driverlogo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.asset(
                          imagem,
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                          alignment: imagem == 'img/grupoFormal.jpeg'
                              ? Alignment.topCenter
                              : Alignment.center,
                        ),
                  Container(
                    height: 190,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xAA35104F)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: ElevatedButton.icon(
                      onPressed: () => _navegarParaPagina(pagina),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text('Explorar $titulo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: roxoEscuro,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Monta o carrossel e mostra uma mensagem adequada enquanto os dados chegam.
  Widget _construirCarrosselPersonagens() {
    // FutureBuilder redesenha esta parte quando a leitura do elenco termina.
    return FutureBuilder<List<Personagem>>(
      future: _personagensFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // A leitura falhou: mostra uma mensagem no lugar do carrossel.
          return const Text('Não foi possível carregar os personagens.');
        }
        if (!snapshot.hasData) {
          // A leitura ainda está em andamento: mostra um indicador de espera.
          return const Center(child: CircularProgressIndicator());
        }

        // A partir daqui os personagens estão prontos para aparecer na tela.
        final personagens = snapshot.data!;
        // Coloca os botões, as páginas do carrossel e o contador em coluna.
        return Column(
          children: [
            // Mantém uma seta de cada lado e o personagem no espaço central.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Toca para voltar ao personagem anterior.
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: _personagemAnterior,
                ),
                // Usa o espaço restante para mostrar o carrossel.
                Expanded(
                  child: SizedBox(
                    height: 280,
                    // PageView permite trocar de personagem também deslizando o dedo.
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: personagens.length,
                      onPageChanged: (index) {
                        // Atualiza o contador quando o usuário muda de página.
                        setState(() {
                          _indicePersonagemAtual = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        // Cria o conteúdo de cada página usando os dados do personagem.
                        final personagem = personagens[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mostra a foto ou a imagem padrão se a foto não abrir.
                            construirCardImagem(
                              imagemSpritePersonagem(personagem),
                            ),
                            const SizedBox(height: 12),
                            // Mostra o nome do personagem selecionado.
                            Text(
                              personagem.nome,
                              style: const TextStyle(
                                fontFamily: 'Redact',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                              ),
                              child: Text(
                                personagem.descricao,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.35,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // Toca para avançar ao próximo personagem.
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: _proximoPersonagem,
                ),
              ],
            ),
            // Informa a posição atual e o total de personagens, por exemplo, "2 de 8".
            Center(
              child: Text(
                '${_indicePersonagemAtual + 1} de ${personagens.length}',
                style: const TextStyle(fontSize: 12, color: Colors.white60),
              ),
            ),
          ],
        );
      },
    );
  }

  // Fecha os controllers ao sair da tela para liberar os recursos usados por eles.
  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura as cores, a navegação e a tela inicial do aplicativo.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: roxoElixir),
        scaffoldBackgroundColor: roxoClaro,
        fontFamily: 'MomoTrust',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Redact',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      // Define o conteúdo exibido quando o aplicativo é aberto.
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF20102B), Color(0xFFE9DCF2)],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 450,
            // Scaffold separa a barra superior do conteúdo que pode rolar.
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F5FB),
              // AppBar mostra o nome do aplicativo e os atalhos das outras páginas.
              appBar: AppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: roxoEscuro,
                centerTitle: false,
                titleSpacing: 18,
                title: const Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('img/logoelixir.png'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ELIXIR',
                          style: TextStyle(
                            fontFamily: 'Redact',
                            fontSize: 18,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'CORP',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 4,
                            color: Color(0xFFDCCAE7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(58),
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _construirItemNavegacao(
                          'História',
                          Icons.auto_stories_rounded,
                          const HistoriaPage(),
                        ),
                        _construirItemNavegacao(
                          'Personagens',
                          Icons.groups_rounded,
                          const PersonagensPage(),
                        ),
                        _construirItemNavegacao(
                          'Projeto',
                          Icons.science_rounded,
                          const ProjetoPage(),
                        ),
                        _construirItemNavegacao(
                          'Equipe',
                          Icons.handshake_rounded,
                          const EquipePage(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Permite rolar todo o conteúdo da página inicial para baixo.
              body: SingleChildScrollView(
                controller: _scrollController,
                // Empilha as seções da página inicial uma abaixo da outra.
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Reúne as seções dentro de um painel claro com sombra suave.
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: roxoElixir.withValues(alpha: 0.06),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: roxoEscuro.withValues(alpha: 0.12),
                            spreadRadius: 0,
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      // Organiza o logotipo e as seções na ordem em que aparecem.
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero visual com título sobreposto e acabamento moderno.
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Image.asset(
                                  'img/logoelixir.png',
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  height: 220,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x181B0B26),
                                        Color(0xE62B123A),
                                      ],
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  left: 18,
                                  right: 18,
                                  bottom: 18,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'UM UNIVERSO PARA EXPLORAR',
                                        style: TextStyle(
                                          color: Color(0xFFEADCF2),
                                          fontSize: 10,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Descubra o projeto Elixir',
                                        style: TextStyle(
                                          fontFamily: 'Redact',
                                          color: Colors.white,
                                          fontSize: 24,
                                          height: 1.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Seção de história em cartão visual.
                          Container(
                            key: _secaoHistoriaKey,
                            child: _construirCardImagemSecao(
                              'História',
                              'Conheça os acontecimentos do universo',
                              'img/logoelixir.png',
                              Icons.auto_stories_rounded,
                              const HistoriaPage(),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Seção de personagens em cartão claro.
                          Container(
                            key: _secaoElencoKey,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0E7F5),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: roxoElixir.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _construirTituloSecao(
                                  'Personagens',
                                  'Conheça quem dá vida à história',
                                  Icons.groups_rounded,
                                ),
                                const SizedBox(height: 12),
                                _construirCarrosselPersonagens(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Projeto e equipe em cartões visuais iguais.
                          Container(
                            key: _secaoCuriosidadesKey,
                            child: _construirCardImagemSecao(
                              'Projeto',
                              'Nossa proposta, mapa e desenvolvimento',
                              'img/Captura de tela 2026-11-07 092716.png',
                              Icons.science_rounded,
                              const ProjetoPage(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            key: _secaoRapazesKey,
                            child: _construirCardImagemSecao(
                              'Equipe',
                              'As pessoas por trás do projeto',
                              'img/grupoFormal.jpeg',
                              Icons.handshake_rounded,
                              const EquipePage(),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mostra uma imagem da internet ou dos arquivos do aplicativo.
/// Se o caminho estiver vazio ou a imagem não abrir, mostra o logotipo no lugar.
/// Este widget é usado em mais de uma tela para manter o mesmo tamanho e acabamento.
Widget construirCardImagem(
  String? path, {
  double width = double.infinity,
  double height = 200,
  BoxFit fit = BoxFit.contain,
}) {
  // Se o caminho começa com http, a imagem vem da internet.
  final imagemValida =
      path != null &&
      path.trim().isNotEmpty &&
      (path.startsWith('http://') || path.startsWith('https://'));
  // Um caminho preenchido que não é uma URL será tratado como imagem local do app.
  final assetValido = path != null && path.trim().isNotEmpty;

  // O Container cria sombra em volta da imagem para destacá-la do fundo.
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: roxoEscuro.withValues(alpha: 0.15),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    // ClipRRect corta a imagem para que ela respeite os cantos arredondados.
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: imagemValida
          // Image.network abre imagens que estão em um endereço da internet.
          ? Image.network(
              path,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                // Enquanto a imagem baixa, o logotipo evita deixar o espaço vazio.
                return Image.asset(
                  'img/logoelixir.png',
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                );
              },
              // Se o endereço remoto falhar, usa o logotipo como imagem alternativa.
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'img/logoelixir.png',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            )
          : assetValido
          // Image.asset abre uma imagem que foi incluída nos arquivos do aplicativo.
          ? Image.asset(
              path,
              width: width,
              height: height,
              fit: fit,
              // Se o caminho local não existir, mostra o logotipo no lugar.
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'img/logoelixir.png',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            )
          : Image.asset(
              // Quando não há caminho informado, o logotipo é a imagem padrão.
              'img/logoelixir.png',
              width: width,
              height: height,
              fit: BoxFit.contain,
            ),
    ),
  );
}

/// Carrega a história do JSON e mostra o texto no layout de detalhes.
class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Espera o conteúdo do JSON sem bloquear a tela inteira.
    return FutureBuilder<ConteudoApp>(
      future: carregarConteudo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Quando os dados chegam, usa apenas a seção de história.
          final historia = snapshot.data!.historia;
          return PaginaDetalhes(
            titulo: historia.titulo,
            imagem: historia.imagem,
            texto: historia.texto,
            paragrafos: historia.paragrafos,
            itens: historia.itens,
            figuras: historia.figuras,
            mostrarImagemPrincipal: false,
          );
        }

        // Enquanto carrega ou se houver erro, mostra uma tela simples com o estado.
        return Scaffold(
          backgroundColor: roxoClaro,
          appBar: AppBar(
            backgroundColor: roxoEscuro,
            centerTitle: true,
            title: const Text(
              'História',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: Center(
            // Mostra a mensagem de erro ou, enquanto isso, um indicador de espera.
            child: snapshot.hasError
                ? const Text('Não foi possível carregar a história.')
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

/// Carrega o elenco e apresenta cada personagem em um cartão rolável.
class PersonagensPage extends StatefulWidget {
  const PersonagensPage({super.key});

  @override
  State<PersonagensPage> createState() => _PersonagensPageState();
}

class _PersonagensPageState extends State<PersonagensPage> {
  // Inicia a leitura uma vez e reutiliza o resultado durante a vida desta tela.
  final Future<List<Personagem>> _personagensFuture = carregarPersonagens();

  @override
  Widget build(BuildContext context) {
    // Fundo claro e área central limitam a largura da página em telas grandes.
    return Container(
      color: roxoClaro,
      child: Center(
        child: SizedBox(
          width: 450,
          // Scaffold fornece a barra superior e o espaço para a lista.
          child: Scaffold(
            backgroundColor: roxoClaro,
            appBar: AppBar(
              backgroundColor: roxoEscuro,
              centerTitle: true,
              foregroundColor: Colors.white,
              title: const Text('Personagens'),
            ),
            // A lista só é criada depois que os dados do elenco forem carregados.
            body: FutureBuilder<List<Personagem>>(
              future: _personagensFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // Avisa se o arquivo do elenco não puder ser aberto.
                  return const Center(
                    child: Text('Não foi possível carregar os personagens.'),
                  );
                }
                if (!snapshot.hasData) {
                  // Mostra que o aplicativo ainda está lendo o arquivo.
                  return const Center(child: CircularProgressIndicator());
                }

                // ListView permite rolar pela lista quando há muitos personagens.
                final personagens = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: roxoClaro,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: roxoElixir,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Elenco',
                                  style: TextStyle(
                                    fontFamily: 'Redact',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: roxoEscuro,
                                  ),
                                ),
                                Text(
                                  '${personagens.length} personagens da história',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: roxoEscuro.withValues(alpha: 0.62),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Cria um cartão para cada personagem recebido do JSON.
                    for (final personagem in personagens)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: roxoElixir.withValues(alpha: 0.09),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: roxoEscuro.withValues(alpha: 0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                // Mantém o retrato dentro de uma área com tamanho fixo.
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 92,
                                    height: 104,
                                    child: construirCardImagem(
                                      imagemSpritePersonagem(personagem),
                                      width: 92,
                                      height: 104,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Expanded usa o espaço restante para os textos do cartão.
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        personagem.nome,
                                        style: const TextStyle(
                                          fontFamily: 'Redact',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: roxoEscuro,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        personagem.descricao,
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: roxoEscuro.withValues(
                                            alpha: 0.76,
                                          ),
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: const EdgeInsets.only(
                                top: 4,
                                bottom: 8,
                              ),
                              leading: const Icon(
                                Icons.person_search_rounded,
                                color: roxoElixir,
                              ),
                              title: const Text(
                                'Saber mais sobre o personagem',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: roxoEscuro,
                                ),
                              ),
                              subtitle: const Text(
                                'Descrição completa e imagem do personagem',
                              ),
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      personagem.descricaoDetalhada,
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: roxoEscuro.withValues(
                                          alpha: 0.82,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: construirCardImagem(
                                        imagemRenderPersonagem(personagem),
                                        height: 210,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Carrega os dados do projeto e mostra sua apresentação no layout de detalhes.
class ProjetoPage extends StatelessWidget {
  const ProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Espera o conteúdo do JSON e atualiza a tela quando ele estiver disponível.
    return FutureBuilder<ConteudoApp>(
      future: carregarConteudo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Usa apenas a seção de projeto, sem misturar os textos das outras páginas.
          final projeto = snapshot.data!.projeto;
          return PaginaDetalhes(
            titulo: projeto.titulo,
            imagem: projeto.imagem,
            texto: projeto.texto,
            paragrafos: projeto.paragrafos,
            itens: projeto.itens,
            figuras: projeto.figuras,
          );
        }

        // Enquanto espera, mantém o título da página visível e informa o estado.
        return Scaffold(
          backgroundColor: roxoClaro,
          appBar: AppBar(
            backgroundColor: roxoEscuro,
            centerTitle: true,
            title: const Text(
              'Projeto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: Center(
            // Exibe uma mensagem se falhar ou um indicador enquanto ainda carrega.
            child: snapshot.hasError
                ? const Text('Não foi possível carregar o conteúdo do projeto.')
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

/// Apresenta os integrantes da equipe, suas fotos e suas responsabilidades.
class EquipePage extends StatelessWidget {
  const EquipePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cada registro reúne o nome, a descrição e o caminho da foto de um integrante.
    const membros = [
      (
        nome: 'Rihan de Jesus',
        descricao: 'Líder do grupo de TCC, desenvolvedor da Unity e artista.',
        imagem: 'img/rihan.jpeg',
      ),
      (
        nome: 'Vinicius Abdala',
        descricao: 'Vice-líder, desenvolvedor Unity e back-end.',
        imagem: 'img/Abdala.jpeg',
      ),
      (
        nome: 'Gabriel Coutinho',
        descricao: 'Modelador 3D.',
        imagem: 'img/coutinho.jpeg',
      ),
      (
        nome: 'Maria Caetano Rizzo',
        descricao: 'Desenvolvedora mobile e desenvolvedora de personagem.',
        imagem: 'img/maria.jpeg',
      ),
      (
        nome: 'Arthur Paixão',
        descricao: 'Roteirista e desenvolvedor da parte da documentação.',
        imagem: 'img/arthur.jpeg',
      ),
    ];

    // Centraliza a página e mantém a mesma largura usada nas outras telas.
    return Container(
      color: roxoClaro,
      child: Center(
        child: SizedBox(
          width: 450,
          // Scaffold organiza o título da página e a lista de integrantes.
          child: Scaffold(
            backgroundColor: roxoClaro,
            appBar: AppBar(
              backgroundColor: roxoEscuro,
              centerTitle: true,
              title: const Text(
                'Equipe de desenvolvimento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              foregroundColor: Colors.white,
            ),
            // A lista inteira pode rolar, incluindo o botão de voltar no final.
            body: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'img/grupoFormal.jpeg',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: roxoElixir.withValues(alpha: 0.09),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: roxoClaro,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.handshake_rounded,
                          color: roxoElixir,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'As pessoas por trás do projeto',
                          style: TextStyle(
                            fontFamily: 'Redact',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: roxoEscuro,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Desenha um cartão para cada integrante da equipe.
                for (final membro in membros)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: roxoElixir.withValues(alpha: 0.09),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: roxoEscuro.withValues(alpha: 0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    // Coloca a foto de um lado e as informações do outro.
                    child: Row(
                      children: [
                        // Arredonda a foto e informa o nome para acessibilidade.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            membro.imagem,
                            width: 92,
                            height: 104,
                            fit: BoxFit.cover,
                            semanticLabel: membro.nome,
                            errorBuilder: (context, error, stackTrace) =>
                                construirCardImagem(
                                  '',
                                  width: 92,
                                  height: 104,
                                  fit: BoxFit.cover,
                                ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Usa o espaço restante para mostrar nome e responsabilidade.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                membro.nome,
                                style: const TextStyle(
                                  fontFamily: 'Redact',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: roxoEscuro,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                membro.descricao,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: roxoEscuro.withValues(alpha: 0.76),
                                ),
                                // Mantém os parágrafos alinhados nas telas estreitas.
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
                // Fecha a tela e retorna à página que estava aberta antes.
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar para a página inicial'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: roxoBotao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

/// Monta a estrutura visual compartilhada pelas páginas de conteúdo.
/// Recebe título, imagem, texto e destaques; a lista de destaques pode estar vazia.
class PaginaDetalhes extends StatelessWidget {
  final String titulo;
  final String imagem;
  final String texto;
  final List<String>? paragrafos;
  final List<String> itens;
  final List<FiguraConteudo> figuras;
  final bool mostrarImagemPrincipal;
  final String? imagemComplementar;
  final String? tituloImagemComplementar;
  final String? descricaoComplementar;

  const PaginaDetalhes({
    super.key,
    required this.titulo,
    required this.imagem,
    required this.texto,
    required this.itens,
    this.paragrafos,
    this.figuras = const [],
    this.mostrarImagemPrincipal = true,
    this.imagemComplementar,
    this.tituloImagemComplementar,
    this.descricaoComplementar,
  });

  bool _ehTituloDeSecao(String texto) {
    return RegExp(r'^\d+(\.\d+)*\.?\s+[A-ZÁÉÍÓÚÂÊÔÃÕÇ]').hasMatch(texto);
  }

  Widget _construirFigura(FiguraConteudo figura) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Text(
          figura.titulo,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            fontWeight: FontWeight.w700,
            color: roxoEscuro,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            figura.imagem,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          figura.fonte,
          style: TextStyle(
            fontSize: 12,
            color: roxoEscuro.withValues(alpha: 0.62),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Centraliza o conteúdo e limita a largura para facilitar a leitura.
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF20102B), Color(0xFFE9DCF2)],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 450,
          // Scaffold separa a barra com o título do conteúdo rolável.
          child: Scaffold(
            backgroundColor: const Color(0xFFF7F5F9),
            // A barra superior repete o nome da página que está sendo exibida.
            appBar: AppBar(
              backgroundColor: roxoEscuro,
              centerTitle: true,
              title: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              foregroundColor: Colors.white,
            ),
            // Permite rolar até o fim quando o texto da página é comprido.
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (mostrarImagemPrincipal)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: SizedBox(
                              height: 250,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    imagem,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(color: roxoEscuro),
                                  ),
                                  const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0x10000000),
                                          Color(0xD91B0D27),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 22,
                                    right: 22,
                                    bottom: 20,
                                    child: Text(
                                      titulo,
                                      style: const TextStyle(
                                        fontFamily: 'Redact',
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [roxoEscuro, roxoElixir],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    titulo,
                                    style: const TextStyle(
                                      fontFamily: 'Redact',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: roxoElixir.withValues(alpha: 0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: roxoEscuro.withValues(alpha: 0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (paragrafos == null)
                                Text(
                                  texto,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.65,
                                    color: roxoEscuro.withValues(alpha: 0.86),
                                  ),
                                  textAlign: TextAlign.justify,
                                )
                              else
                                for (
                                  var indice = 0;
                                  indice < paragrafos!.length;
                                  indice++
                                ) ...[
                                  Text(
                                    paragrafos![indice],
                                    style: TextStyle(
                                      fontFamily:
                                          _ehTituloDeSecao(paragrafos![indice])
                                          ? 'Redact'
                                          : null,
                                      fontSize:
                                          _ehTituloDeSecao(paragrafos![indice])
                                          ? 17
                                          : 15,
                                      fontWeight:
                                          _ehTituloDeSecao(paragrafos![indice])
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      height: 1.65,
                                      color: roxoEscuro.withValues(alpha: 0.86),
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  for (final figura in figuras.where(
                                    (figura) => figura.aposParagrafo == indice,
                                  ))
                                    _construirFigura(figura),
                                  if (indice < paragrafos!.length - 1)
                                    const SizedBox(height: 18),
                                ],
                              if (paragrafos == null)
                                for (final figura in figuras)
                                  _construirFigura(figura)
                              else
                                for (final figura in figuras.where(
                                  (figura) => figura.aposParagrafo < 0,
                                ))
                                  _construirFigura(figura),
                              if (imagemComplementar != null) ...[
                                const SizedBox(height: 22),
                                Text(
                                  tituloImagemComplementar ?? 'Logo da Elixir',
                                  style: TextStyle(
                                    fontFamily: 'Redact',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: roxoEscuro,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    color: roxoEscuro,
                                    width: double.infinity,
                                    height: 170,
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      imagemComplementar!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                if (descricaoComplementar != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    descricaoComplementar!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                      color: roxoEscuro,
                                    ),
                                  ),
                                ],
                              ],
                              const SizedBox(height: 22),
                              // Cria uma linha com estrela para cada destaque, se houver algum.
                              ...itens.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.4,
                                            color: roxoEscuro,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Volta para a página anterior quando o usuário toca no botão.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text(
                                    'Voltar para a página inicial',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: roxoElixir,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
