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
    required this.principal,
    required this.imagem,
  });

  final int id; // Número que diferencia este personagem dos demais.
  final String nome; // Nome mostrado no carrossel e na lista do elenco.
  final String descricao; // Texto que explica quem é o personagem.
  final bool principal; // Informa se ele faz parte do grupo principal.
  final String imagem; // Caminho de uma imagem do app ou endereço da internet.

  /// Lê os campos de um personagem no JSON e cria um objeto Personagem.
  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
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

/// Reúne os textos e a imagem que uma página precisa para ser montada.
class ConteudoPagina {
  const ConteudoPagina({
    required this.titulo,
    required this.imagem,
    required this.paragrafos,
    required this.itens,
  });

  final String titulo; // Texto que aparece no topo e no conteúdo da página.
  final String imagem; // Imagem principal mostrada antes do texto.
  final List<String>
  paragrafos; // Partes do texto, separadas para facilitar a leitura.
  final List<String> itens; // Lista opcional de destaques abaixo do texto.

  // Junta os parágrafos com uma linha em branco entre eles.
  String get texto => paragrafos.join('\n\n');

  /// Lê a seção de uma página no JSON e cria os dados que a tela vai exibir.
  factory ConteudoPagina.fromJson(Map<String, dynamic> json) {
    return ConteudoPagina(
      titulo: json['titulo'] as String,
      imagem: json['imagem'] as String,
      paragrafos: List<String>.from(json['paragrafos'] as List<dynamic>),
      itens: List<String>.from(json['itens'] as List<dynamic>? ?? const []),
    );
  }
}

/// Agrupa os dados das três páginas que usam conteúdo do arquivo projeto.json.
class ConteudoApp {
  const ConteudoApp({
    required this.historia,
    required this.mascote,
    required this.projeto,
  });

  final ConteudoPagina historia;
  final ConteudoPagina mascote;
  final ConteudoPagina projeto;

  /// Cria cada página a partir da seção com o mesmo nome no JSON.
  factory ConteudoApp.fromJson(Map<String, dynamic> json) {
    return ConteudoApp(
      historia: ConteudoPagina.fromJson(
        json['historia'] as Map<String, dynamic>,
      ),
      mascote: ConteudoPagina.fromJson(json['mascote'] as Map<String, dynamic>),
      projeto: ConteudoPagina.fromJson(json['projeto'] as Map<String, dynamic>),
    );
  }
}

// Mantém uma única leitura de projeto.json para História, Mascote e Projeto.
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
                            construirCardImagem(personagem.imagem),
                            const SizedBox(height: 12),
                            // Mostra o nome do personagem selecionado.
                            Text(
                              personagem.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
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
        useMaterial3: true,
      ),
      // Define o conteúdo exibido quando o aplicativo é aberto.
      home: Container(
        color: Colors.grey,
        // Centraliza a tela principal no espaço disponível.
        child: Center(
          child: SizedBox(
            width: 450,
            // Scaffold separa a barra superior do conteúdo que pode rolar.
            child: Scaffold(
              backgroundColor: roxoClaro,
              // AppBar mostra o nome do aplicativo e os atalhos das outras páginas.
              appBar: AppBar(
                backgroundColor: roxoEscuro,
                centerTitle: true,
                title: const Text(
                  'Elixir Corp',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(228, 222, 222, 1),
                  ),
                ),
                bottom: PreferredSize(
                  // Reserva espaço para o menu que fica logo abaixo do nome do app.
                  preferredSize: const Size.fromHeight(50.0),
                  // Permite deslizar o menu para o lado em telas estreitas.
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // Coloca os botões de navegação em uma única linha.
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Cada botão abre uma página e mantém a tela atual para voltar.
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const HistoriaPage()),
                          child: const Text(
                            'História',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const PersonagensPage()),
                          child: const Text(
                            'Personagens',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const MascotePage()),
                          child: const Text(
                            'Mascote',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const ProjetoPage()),
                          child: const Text(
                            'Projeto',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _navegarParaPagina(const EquipePage()),
                          child: const Text(
                            'Equipe',
                            style: TextStyle(color: Colors.white),
                          ),
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
                    // Reúne as seções dentro de um painel com fundo roxo e sombra.
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: roxoElixir,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: roxoEscuro.withValues(alpha: 0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      // Organiza o logotipo e as seções na ordem em que aparecem.
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stack coloca uma camada escura sobre o logotipo.
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Mostra o logotipo com bordas arredondadas.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'img/logoelixir.png',
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Camada transparente que escurece a imagem de fundo.
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Seção de história: título, imagem e botão para abrir a página.
                          Column(
                            key: _secaoHistoriaKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'História',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Imagem ilustrativa da história.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                // Exibe a imagem ilustrativa ocupando a largura da seção.
                                child: Image.asset(
                                  'img/logoelixir.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: roxoBotao,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navegarParaPagina(const HistoriaPage()),
                                  child: const Text(
                                    'Ver Mais História',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Mantém distância visual entre a história e o elenco.
                          const SizedBox(height: 30),

                          // Seção de personagens: mostra o carrossel carregado do JSON.
                          Column(
                            key: _secaoElencoKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personagens',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _construirCarrosselPersonagens(),
                            ],
                          ),
                          // Separa o elenco da apresentação do mascote.
                          const SizedBox(height: 30),

                          // Seção do mascote: imagem e botão para ler sua descrição completa.
                          Column(
                            key: _secaoCuriosidadesKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mascote',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Imagem ilustrativa do mascote.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                // Exibe a imagem do mascote na largura da seção.
                                child: Image.asset(
                                  'img/logoelixir.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: roxoBotao,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navegarParaPagina(const MascotePage()),
                                  child: const Text(
                                    'Ver Mais Mascote',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Separa a seção do mascote da apresentação do projeto.
                          const SizedBox(height: 30),

                          // Seção do projeto: imagem e botão para abrir a apresentação completa.
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Projeto',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/logoelixir.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: roxoBotao,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navegarParaPagina(const ProjetoPage()),
                                  child: const Text('Ver Projeto'),
                                ),
                              ),
                            ],
                          ),
                          // Separa o projeto da apresentação da equipe.
                          const SizedBox(height: 30),

                          // Seção da equipe: imagem e botão para ver os integrantes.
                          Column(
                            key: _secaoRapazesKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Equipe de desenvolvimento',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Imagem de apresentação da equipe.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/logoelixir.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: roxoBotao,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navegarParaPagina(const EquipePage()),
                                  child: const Text(
                                    'Ver Mais Equipe',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Cria espaço ao final do painel da página inicial.
                          const SizedBox(height: 20),
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
            itens: historia.itens,
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
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Cria um cartão para cada personagem recebido do JSON.
                    for (final personagem in personagens)
                      Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: roxoElixir,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: roxoEscuro.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        // A linha coloca o retrato ao lado do nome e da descrição.
                        child: Row(
                          children: [
                            // Mantém o retrato dentro de uma área com tamanho fixo.
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 100,
                                height: 110,
                                child: construirCardImagem(
                                  personagem.imagem,
                                  width: 100,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Expanded usa o espaço restante para os textos do cartão.
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    personagem.nome,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    personagem.descricao,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
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

/// Carrega os dados do mascote e mostra o texto no layout de detalhes.
class MascotePage extends StatelessWidget {
  const MascotePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa os mesmos dados carregados para as outras páginas de conteúdo.
    return FutureBuilder<ConteudoApp>(
      future: carregarConteudo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Seleciona título, imagem e texto próprios da página do mascote.
          final mascote = snapshot.data!.mascote;
          return PaginaDetalhes(
            titulo: mascote.titulo,
            imagem: mascote.imagem,
            texto: mascote.texto,
            itens: mascote.itens,
          );
        }

        // Mostra a barra superior enquanto o conteúdo é carregado ou se ocorrer erro.
        return Scaffold(
          backgroundColor: roxoClaro,
          appBar: AppBar(
            backgroundColor: roxoEscuro,
            centerTitle: true,
            title: const Text(
              'Mascote',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: Center(
            // Troca o indicador pela mensagem caso a leitura do JSON falhe.
            child: snapshot.hasError
                ? const Text('Não foi possível carregar o texto do mascote.')
                : const CircularProgressIndicator(),
          ),
        );
      },
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
            itens: projeto.itens,
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
              padding: const EdgeInsets.all(16),
              children: [
                // Desenha um cartão para cada integrante da equipe.
                for (final membro in membros)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: roxoElixir,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: roxoEscuro.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    // Coloca a foto de um lado e as informações do outro.
                    child: Row(
                      children: [
                        // Arredonda a foto e informa o nome para acessibilidade.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            membro.imagem,
                            width: 100,
                            height: 110,
                            fit: BoxFit.cover,
                            semanticLabel: membro.nome,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                membro.descricao,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                  color: Colors.white,
                                ),
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
  final List<String> itens;

  const PaginaDetalhes({
    super.key,
    required this.titulo,
    required this.imagem,
    required this.texto,
    required this.itens,
  });

  @override
  Widget build(BuildContext context) {
    // Centraliza o conteúdo e limita a largura para facilitar a leitura.
    return Container(
      color: roxoClaro,
      child: Center(
        child: SizedBox(
          width: 450,
          // Scaffold separa a barra com o título do conteúdo rolável.
          child: Scaffold(
            backgroundColor: roxoClaro,
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
              // Organiza imagem, título, texto, destaques e botão em coluna.
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Painel roxo reúne o conteúdo principal da página.
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: roxoElixir,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: roxoEscuro.withValues(alpha: 0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    // Alinha a imagem e os textos pela margem esquerda do painel.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mostra a imagem principal recebida pela página.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            imagem,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Mostra o texto recebido; os parágrafos vêm separados por linhas.
                        Text(
                          texto,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Cria uma linha com estrela para cada destaque, se houver algum.
                        ...itens.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                      color: Colors.white,
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
                            label: const Text('Voltar para a página inicial'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: roxoBotao,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
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
    );
  }
}
