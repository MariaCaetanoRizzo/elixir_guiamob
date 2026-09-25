import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

const roxoElixir = Color(0xFF6A1B9A);
const roxoBotao = Color(0xFF9B59B6);
const roxoEscuro = Color(0xFF35104F);
const roxoClaro = Color(0xFFF3E8FA);

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _indicePersonagemAtual = 0;

  // As 4 chaves necessárias para a rolagem automática
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // Dados dos 8 personagens para o carrossel animado
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

  void _navegarParaPagina(Widget pagina) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: roxoElixir),
        scaffoldBackgroundColor: roxoClaro,
        useMaterial3: true,
      ),
      home: Container(
        color: Colors.grey,
        child: Center(
          child: SizedBox(
            width: 450,
            child: Scaffold(
              backgroundColor: roxoClaro,
              appBar: AppBar(
                backgroundColor: roxoEscuro,
                centerTitle: true,
                title: const Text(
                  'Elixir Corp',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(228, 222, 222, 1),
                  ),
                ),
                bottom: PreferredSize(
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
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'img/logoelixir.png',
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              Image.asset(
                                  'img/logoelixir.png',
                                height: 90,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Seção História
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

                              // --- SUBSTITUÍDO O CONTEÚDO PELA IMAGEM EXATA ---
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

                          // Seção Elenco
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

                          // Seção Curiosidades
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

                              // --- SUBSTITUÍDO O CONTEÚDO PELA IMAGEM EXATA ---
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
                                  onPressed: () => _navegarParaPagina(
                                    const MascotePage(),
                                  ),
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

                          // Seção Projeto
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
                                  onPressed: () => _navegarParaPagina(
                                    const ProjetoPage(),
                                  ),
                                  child: const Text('Ver Projeto'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Seção Rapazes
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

                              // --- SUBSTITUÍDO O CONTEÚDO PELA IMAGEM EXATA ---
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

class PersonagensPage extends StatefulWidget {
  const PersonagensPage({super.key});

  @override
  State<PersonagensPage> createState() => _PersonagensPageState();
}

class _PersonagensPageState extends State<PersonagensPage> {
  final PageController _controller = PageController();
  int _indiceAtual = 0;

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

class MascotePage extends StatelessWidget {
  const MascotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'Mascote',
      imagem: 'img/mascote.png',
      texto:
          'O mascote representa a energia, a curiosidade e a criatividade da Elixir Corp.',
      itens: [],
    );
  }
}

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

class EquipePage extends StatelessWidget {
  const EquipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaginaDetalhes(
      titulo: 'Equipe de desenvolvimento',
      imagem: 'img/logoelixir.png',
      texto: 'Conheça a equipe responsável pelo desenvolvimento da Elixir Corp.',
      itens: [
        'Membro 1 - posição no grupo - trabalho a definir.',
        'Membro 2 - posição no grupo - trabalho a definir.',
        'Membro 3 - posição no grupo - trabalho a definir.',
        'Membro 4 - posição no grupo - trabalho a definir.',
        'Membro 5 - posição no grupo - trabalho a definir.',
      ],
    );
  }
}

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
