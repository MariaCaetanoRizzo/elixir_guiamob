// Widgets e componentes visuais usados nas telas do aplicativo.
import 'package:flutter/material.dart';

// Arquivo principal da aplicação mobile da Elixir Corp.
// Este widget inicializa o app, define o tema visual e controla a navegação entre
// as principais páginas de apresentação do projeto.
void main() {
  runApp(const MainApp());
}

// Paleta de cores utilizada para manter uma identidade visual consistente em todas
// as telas do aplicativo.
const roxoElixir = Color(0xFF6A1B9A);
const roxoBotao = Color(0xFF9B59B6);
const roxoEscuro = Color(0xFF35104F);
const roxoClaro = Color(0xFFF3E8FA);

// Widget raiz do aplicativo. Mantém o estado da navegação e das seções da página
// inicial, além de controlar o carrossel dos personagens.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Controla a rolagem da página inicial para permitir navegação suave entre as
  // seções principais da landing page.
  final ScrollController _scrollController = ScrollController();

  // Controla as páginas do carrossel de personagens.
  final PageController _pageController = PageController();

  // Chave global do navigator para abrir páginas de detalhe sem depender do
  // contexto imediato da árvore de widgets.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // Índice atual usado para exibir a posição no carrossel de personagens.
  int _indicePersonagemAtual = 0;

  // Chaves usadas para apontar seções específicas da home e facilitar rolagem/âncoras.
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // Dados dos personagens exibidos no carrossel principal. Cada item guarda nome,
  // imagem e papel dentro da história do filme.
  final List<Map<String, dynamic>> _elencoDados = [
    {
      'nome': 'Nick Szalinski',
      'imagem': 'img/logoelixir.png',
      'ator': 'Personagem principal',
    },
    {
      'nome': 'Amy Szalinski',
      'imagem': 'img/logoelixir.png',
      'ator': 'Líder do grupo',
    },
    {
      'nome': 'Ron Thompson',
      'imagem': 'img/logoelixir.png',
      'ator': 'Aventureiro',
    },
    {
      'nome': 'Russ Thompson',
      'imagem': 'img/logoelixir.png',
      'ator': 'Companheiro do grupo',
    },
    {
      'nome': 'Wayne Szalinski',
      'imagem': 'img/logoelixir.png',
      'ator': 'Inventor',
    },
    {
      'nome': 'Diane Szalinski',
      'imagem': 'img/logoelixir.png',
      'ator': 'Mãe da família',
    },
    {
      'nome': 'Quark',
      'imagem': 'img/logoelixir.png',
      'ator': 'Cachorro da família',
    },
    {
      'nome': 'Antie',
      'imagem': 'img/logoelixir.png',
      'ator': 'Aliada da aventura',
    },
    {
      'nome': 'O Escorpião',
      'imagem': 'img/logoelixir.png',
      'ator': 'Ameaça do quintal',
    },
    {
      'nome': 'A Abelha',
      'imagem': 'img/logoelixir.png',
      'ator': 'Perigo do quintal',
    },
  ];

  void _proximoPersonagem() {
    if (_indicePersonagemAtual < _elencoDados.length - 1) {
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

  void _personagemAnterior() {
    if (_indicePersonagemAtual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        _elencoDados.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // Abre uma nova rota de detalhe mantendo a navegação centralizada no navigator do
  // MaterialApp principal.
  void _navegarParaPagina(Widget pagina) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

  // Libera recursos associados aos controladores quando a tela é removida.
  @override
  void dispose() {
    // Libera os recursos dos controladores ao encerrar o estado do app para evitar
    // vazamentos de memória e comportamento inconsistentes.
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Estrutura principal da home do aplicativo. A tela é montada em um container
    // centralizado com largura fixa para manter uma experiência de apresentação e
    // leitura mais confortável em dispositivos móveis.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 133, 64, 175),
        ),
        scaffoldBackgroundColor: roxoClaro,
        useMaterial3: true,
      ),
      home: Container(
        // Fundo roxo translúcido que clareia a área externa ao conteúdo.
        color: const Color.fromARGB(255, 136, 73, 175).withValues(alpha: 0.14),
        child: Center(
          child: SizedBox(
            width: 450,
            child: Scaffold(
              backgroundColor: roxoClaro,
              // Cabeçalho fixo com título e atalhos para as páginas do aplicativo.
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
                  // Mantém os atalhos de navegação acessíveis em telas estreitas.
                  preferredSize: const Size.fromHeight(50.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Estrutura visual da página inicial: o conteúdo principal fica dentro
                    // de um contêiner roxo com borda arredondada e sombra, dando destaque
                    // ao painel principal da apresentação do app.
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Container principal da home, com espaçamento lateral e um bloco
                        // central para agrupar todas as seções de apresentação.
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Banner inicial da home com imagem de fundo, camada escura e
                              // texto de apresentação para reforçar a identidade da marca.
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Imagem de destaque da home, com borda arredondada e
                                  // preenchimento total para dar impacto visual.
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.asset(
                                      'img/fundobranco.jpg',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Camada escura sobre a imagem para melhorar legibilidade do texto.
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  // Texto principal posicionado sobre a imagem para manter uma
                                  // apresentação mais profissional sem alterar a navegação.
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    bottom: 18,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Elixir Corp',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.35,
                                                ),
                                                offset: Offset(1, 2),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Descubra a aventura em um mundo em miniatura.',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),

                          // Seção de história: apresenta um teaser visual com a imagem da
                          // narrativa principal e um botão para abrir a tela detalhada do filme.
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

                              // Banner ilustrativo da história, usando uma imagem temática para
                              // despertar interesse pelo conteúdo completo da página de detalhes.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/fundonovo.jpg',
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
                          const SizedBox(height: 30),

                          // Seção de elenco: o carrossel dos personagens permite navegar entre
                          // os integrantes principais da história com botões laterais e contador
                          // de posição atual.
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Botão para retroceder no carrossel dos personagens.
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      onPressed: _personagemAnterior,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 280,
                                        child: PageView.builder(
                                          controller: _pageController,
                                          itemCount: _elencoDados.length,
                                          onPageChanged: (index) {
                                            setState(() {
                                              _indicePersonagemAtual = index;
                                            });
                                          },
                                          itemBuilder: (context, index) {
                                            final personagem =
                                                _elencoDados[index];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                _construirCardImagem(
                                                  personagem['imagem']
                                                      as String?,
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  personagem['nome'] as String,
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
                                    // Botão para avançar no carrossel dos personagens.
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
                              Center(
                                child: Text(
                                  '${_indicePersonagemAtual + 1} de ${_elencoDados.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Seção do mascote: mantém o mesmo padrão visual das demais seções,
                          // com imagem ilustrativa e botão para abrir a página específica.
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

                              // Imagem de destaque da seção de mascote para reforçar a temporária
                              // identidade visual da categoria antes de abrir a tela detalhada.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/fundonovo.jpg',
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
                          const SizedBox(height: 30),

                          // Seção do projeto: apresenta a proposta geral do app e dá acesso à
                          // página detalhada da visão do desenvolvimento.
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
                              // Imagem ilustrativa da proposta do projeto, seguindo o mesmo padrão
                              // visual das demais seções da página inicial.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/fundonovo.jpg',
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
                          const SizedBox(height: 30),

                          // Seção da equipe: fecha a apresentação da home com a imagem e o acesso
                          // à página de desenvolvimento, onde os integrantes e suas funções são
                          // detalhados.
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

                              // Imagem de destaque da equipe, mantendo o mesmo padrão visual das
                              // demais seções para uma identidade uniforme.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'img/fundonovo.jpg',
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

  // Cria um card com suporte a imagens remotas ou assets locais. Caso a imagem não
  // exista ou falhe no carregamento, o app usa o logo da Elixir como fallback.
  Widget _construirCardImagem(String? path) {
    final imagemValida =
        path != null &&
        path.trim().isNotEmpty &&
        (path.startsWith('http://') || path.startsWith('https://'));
    final assetValido = path != null && path.trim().isNotEmpty;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: imagemValida
            ? Image.network(
                path,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Image.asset(
                    'img/logoelixir.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.contain,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'img/logoelixir.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              )
            : assetValido
            ? Image.asset(
                path,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                    'img/logoelixir.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              )
            : Image.asset(
                'img/logoelixir.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

/// Página de história, preenchida por um layout reutilizável de detalhes.
/// Essa tela apresenta o resumo principal da narrativa do filme e mantém a mesma
/// estrutura visual das páginas de apresentação do projeto.
class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'História',
              imagem: 'img/logoelixir.png',
      texto:
          'Wayne Szalinski é um inventor que trabalha em uma máquina capaz de encolher objetos. Durante uma experiência no sótão, uma bola de beisebol atravessa a janela e aciona acidentalmente o equipamento. O raio atinge Amy e Nick Szalinski e os vizinhos Russ Jr. e Ron Thompson, reduzindo as quatro crianças a poucos centímetros de altura. Como Wayne e Diane não percebem o acidente, as crianças acabam no lixo e são levadas para o quintal, que passa a parecer uma enorme selva. Perdidos entre folhas de grama, gotas de água e objetos gigantes, eles precisam encontrar o caminho de volta para casa. No percurso, enfrentam os aspersores, uma abelha e outros perigos, além de fazer amizade com uma formiga que chamam de Antie. Quando um escorpião ameaça o grupo, Antie tenta protegê-los e acaba morrendo. Enquanto isso, Wayne e Diane procuram pelos filhos e descobrem que a máquina foi ativada pela bola de beisebol. Com a ajuda do cachorro Quark, as crianças conseguem chamar a atenção dos pais. Wayne reconstrói o funcionamento da máquina e devolve todos ao tamanho normal.',
      itens: [],
    );
  }
}

// Tela dedicada a apresentar os personagens da história em um carrossel de páginas.
// Cada página concentra nome, resumo e papel do personagem no enredo.
class PersonagensPage extends StatefulWidget {
  const PersonagensPage({super.key});

  @override
  State<PersonagensPage> createState() => _PersonagensPageState();
}

class _PersonagensPageState extends State<PersonagensPage> {
  // Controla a navegação horizontal entre os personagens da página.
  final PageController _controller = PageController();

  // Índice atual do personagem visível no carrossel.
  int _indiceAtual = 0;

  // Lista centralizada dos personagens e de suas descrições curtas para manter o
  // conteúdo fácil de atualizar.
  static const personagens = [
    (
      'Nick Szalinski',
      'Nick e seus amigos são reduzidos a poucos centímetros durante um acidente no laboratório.',
      'Estrategista do grupo.',
    ),
    (
      'Amy Szalinski',
      'Amy enfrenta o quintal gigante e ajuda a manter o grupo unido.',
      'Líder cuidadosa do grupo.',
    ),
    (
      'Ron Thompson',
      'Ron é um dos vizinhos atingidos pelo raio da máquina de encolher.',
      'Aventureiro e prático.',
    ),
    (
      'Russ Thompson',
      'Russ precisa se adaptar rapidamente ao mundo enorme ao redor dele.',
      'Companheiro e força do grupo.',
    ),
    (
      'Wayne Szalinski',
      'Wayne tenta entender o acidente causado pela máquina de encolher.',
      'Inventor e pai da família.',
    ),
    (
      'Diane Szalinski',
      'Diane participa da busca pelos filhos desaparecidos.',
      'Mãe e apoio da família.',
    ),
    (
      'Quark',
      'Quark ajuda a família a perceber que as crianças estão em perigo.',
      'Cachorro e aliado da família.',
    ),
    (
      'Antie',
      'Antie se aproxima das crianças e se torna uma aliada inesperada.',
      'Aliada da aventura.',
    ),
    (
      'O Escorpião',
      'O escorpião representa um dos maiores perigos encontrados no quintal.',
      'Ameaça do quintal.',
    ),
    (
      'A Abelha',
      'A abelha transforma uma tarefa comum em um grande desafio para o grupo.',
      'Perigo do quintal.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cada cartão de personagem concentra o nome, a descrição curta e um avatar
    // neutro em um bloco visual consistente. Essa estrutura facilita a leitura dos
    // dados e deixa o layout padronizado para qualquer novo membro do elenco.
    return Container(
      color: roxoClaro,
      child: Center(
        child: SizedBox(
          width: 450,
          child: Scaffold(
            backgroundColor: roxoClaro,
            appBar: AppBar(title: const Text('Personagens')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 430,
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: personagens.length,
                        onPageChanged: (index) =>
                            setState(() => _indiceAtual = index),
                        itemBuilder: (context, index) {
                          final personagem = personagens[index];
                          return Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'img/logoelixir.png',
                                    height: 190,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    personagem.$1,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: roxoEscuro,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'História: ${personagem.$2}\n\nFunção: ${personagem.$3}',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('${_indiceAtual + 1} de ${personagens.length}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        IconButton(
                          onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
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

/// Página de detalhes do mascote usando o mesmo layout compartilhado das outras
/// páginas de apresentação.
class MascotePage extends StatelessWidget {
  const MascotePage({super.key});

  @override
  Widget build(BuildContext context) {
    // A página do mascote reutiliza o template de informações detalhadas para manter
    // a consistência visual com as demais páginas de apresentação do app.
    return const PaginaDetalhes(
      titulo: 'Mascote',
      imagem: 'img/mascote.png',
      texto:
          'O mascote representa a energia, a curiosidade e a criatividade da Elixir Corp.',
      itens: [],
    );
  }
}

/// Página de detalhes que resume a proposta e a evolução do projeto.
class ProjetoPage extends StatelessWidget {
  const ProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'Projeto',
      imagem: 'img/logoelixir.png',
      texto:
          'O projeto da Elixir Corp reúne a aplicação mobile, a documentação e a experiência interativa que estão sendo desenvolvidas pela equipe.',
      itens: [
        'Esta página apresenta a proposta e a evolução do projeto.',
        'Novas informações, imagens e etapas serão adicionadas posteriormente.',
      ],
    );
  }
}

// Página que lista os integrantes do projeto e suas contribuições.
class EquipePage extends StatelessWidget {
  const EquipePage({super.key});

  // A lista de integrantes fica isolada do widget de apresentação para facilitar a
  // manutenção dos dados da equipe. Dessa forma, qualquer atualização no nome,
  // função ou descrição de um membro pode ser feita em um único ponto.
  static const List<_Desenvolvedor> _desenvolvedores = [
    _Desenvolvedor(
      nome: 'Arthur Paixão Serafim',
      imagem: 'img/arthurpaixao.png',
      funcao: 'Documentação e desenvolvimento de cenas',
      descricao:
          'Fez toda a documentação do projeto, organizou os GitHub da equipe e participou do desenvolvimento das cenas.',
    ),
    _Desenvolvedor(
      nome: 'Gabriel Coutinho Baptista',
      imagem: 'img/gabrielcoutinh.png',
      funcao: 'Modelagem 3D',
      descricao:
          'Modelou em 3D, no Blender, os objetos e os personagens do jogo.',
    ),
    _Desenvolvedor(
      nome: 'Maria Eduarda Caetano Rizzo',
      imagem: 'img/mariacaetano.png',
      funcao: 'Desenvolvimento mobile e artes',
      descricao:
          'Desenvolveu o aplicativo mobile, criou as artes do jogo e escreveu as descrições dos personagens.',
    ),
    _Desenvolvedor(
      nome: 'Rihan de Jesus de Andrade',
      imagem: 'img/rihandejesus.png',
      funcao: 'Líder do grupo e desenvolvimento Unity',
      descricao:
          'Lidera o grupo de TCC, criou artes dos personagens e desenvolveu, junto com Vinicius, a programação do jogo na Unity.',
    ),
    _Desenvolvedor(
      nome: 'Vinicius de Almeida Abdala',
      funcao: 'Programação e desenvolvimento do jogo',
      descricao:
          'Programou e desenvolveu o jogo em conjunto com o grupo, incluindo a parte de Unity com Rihan.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PaginaDetalhes(
      titulo: 'Equipe de desenvolvimento',
      imagem: 'img/logoelixir.png',
      texto: 'Conheça a equipe responsável pelo desenvolvimento da Elixir Corp.',
      itens: _desenvolvedores
          .map((desenvolvedor) =>
              '${desenvolvedor.nome} - ${desenvolvedor.funcao}\n${desenvolvedor.descricao}')
          .toList(),
    );
  }
}

// Modelo auxiliar usado para representar um membro da equipe dentro da página de
// apresentação. A estrutura centraliza os dados do colaborador em um único objeto.
class _Desenvolvedor {
  final String nome;
  final String? imagem;
  final String funcao;
  final String descricao;

  const _Desenvolvedor({
    required this.nome,
    this.imagem,
    required this.funcao,
    required this.descricao,
  });
}

/// Layout comum às páginas de história, mascote, projeto e equipe.
/// Recebe título, imagem, texto principal e uma lista opcional de destaques para
/// manter o visual consistente entre as telas de detalhe.
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
    return Container(
      color: roxoClaro,
      child: Center(
        child: SizedBox(
          width: 450,
          child: Scaffold(
            backgroundColor: roxoClaro,
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Text(
                          texto,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ...itens.map(
                          // Apresenta cada destaque como uma linha com ícone.
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
