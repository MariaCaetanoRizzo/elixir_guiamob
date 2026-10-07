import 'package:flutter/material.dart';

// Ponto de entrada do aplicativo. É aqui que a árvore de widgets do Flutter é
// iniciada e a tela principal da aplicação é montada para o usuário.
void main() {
  runApp(const MainApp());
}

// Paleta de cores principal do projeto. Essas constantes padronizam a identidade
// visual da interface e ajudam a manter a consistência entre a home, os cards e
// as páginas auxiliares do app.
const roxoElixir = Color(0xFF6A1B9A);
const roxoBotao = Color(0xFF9B59B6);
const roxoEscuro = Color(0xFF35104F);
const roxoClaro = Color(0xFFF3E8FA);

// Lista centralizada com os personagens do projeto. Ela é reutilizada tanto no
// carrossel da página inicial quanto na tela de personagens, garantindo que nomes,
// descrições e a base de dados visual do elenco permaneçam sincronizados.
const _elencoDados = <_Personagem>[
  _Personagem('Carlos Dias', 'Personagem principal'),
  _Personagem('Rita Santana', 'Chefe do protagonista'),
  _Personagem('Olga Pires', 'Florista'),
  _Personagem('Rafael Souza', 'Adolescente rebelde'),
  _Personagem('Neuza Oliveira', 'Senhora eufórica'),
  _Personagem('Fortunato Gomes', 'Senhor louco'),
  _Personagem('Íris Junqueira', 'Bióloga da cidade'),
  _Personagem('Léticia Magalhães', 'Ativista ambiental'),
  _Personagem('Caio Duarte', 'Artista de rua'),
  _Personagem('Clarice Duarte', 'Muralista'),
  _Personagem('Enzo Ferreira', 'Jovem artista'),
  _Personagem('Silvia Toledo', 'Fotógrafa de rua'),
  _Personagem('João', 'Fã da Charlotte'),
  _Personagem('Michael Neves', 'Segurança da Idol'),
  _Personagem('Charlotte', 'Idol do evento'),
];

// A raiz do app usa state porque a home page precisa acompanhar a posição atual
// do carrossel, a rolagem da tela e o índice do personagem exibido em destaque.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // ScrollController controla a rolagem vertical da página inicial, enquanto o
  // PageController organiza a troca dos itens do carrossel de personagens.
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  // Chave de navegação global usada para empilhar páginas secundárias e manter
  // uma navegação consistente em qualquer ponto da árvore do app.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _indicePersonagemAtual = 0;

  // Chaves de seção permitem localizar blocos específicos da home para
  // navegação/rolagem e qualquer ação futura que precise focar uma parte.
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // Avança para o próximo personagem do carrossel. Quando o usuário chega ao
  // último item, a lógica retorna ao início para manter a navegação circular.
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

  // Retrocede no carrossel de personagens. No primeiro item, a transição pula para
  // o último registro, criando um comportamento cíclico semelhante ao da navegação.
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

  // Empilha uma nova página sobre a navegação atual, permitindo avançar para
  // "História", "Personagens", "Mascote" e outras telas sem perder o contexto.
  void _navegarParaPagina(Widget pagina) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

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
    // A estrutura do app define o tema global, a chave de navegação e a página
    // inicial que será exibida. Isso centraliza os ajustes visuais e a arquitetura
    // de navegação do app em um único ponto.
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
                    // Container principal da home, que reúne todas as seções em um
                    // único bloco visual, preservando o layout de cartão e a
                    // organização dos textos, imagens e botões de navegação.
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
                          // Imagem de destaque com camada escura e logotipo sobreposto.
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'img/fundobranco.jpg',
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

                          // Resumo da história; o botão abre a versão completa.
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

                              // Imagem ilustrativa do resumo da história.
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

                          // Carrossel de personagens, usando os dados compartilhados
                          // com a página Personagens e atualizando o contador ao deslizar.
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
                                                personagem.imagem,
                                              ),
                                              const SizedBox(height: 12),
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

                          // Destaque do mascote com atalho para sua página de detalhes.
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

                          // Resumo do projeto com botão para abrir os detalhes.
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

                          // Resumo da equipe de desenvolvimento com atalho para a lista.
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

                              // Imagem ilustrativa da equipe.
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

  // Monta a imagem do carrossel verificando primeiro se o caminho aponta para uma
  // URL externa ou para um asset local do projeto. Se os dados vierem vazios ou
  // falharem ao carregar, o widget substitui automaticamente pelo logo padrão do app.
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
                    'img/fundonovo.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.contain,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'img/fundonovo.jpg',
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
                  'img/fundonovo.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              )
            : Image.asset(
                'img/fundonovo.jpg',
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
    // Essa página reaproveita o layout genérico de detalhes, que já concentra a
    // estrutura visual da narrativa e evita duplicação de código para textos e
    // botões de retorno.
    return const PaginaDetalhes(
      titulo: 'História',
      imagem: 'img/fundonovo.jpg',
      texto:
          'Wayne Szalinski é um inventor que trabalha em uma máquina capaz de encolher objetos. Durante uma experiência no sótão, uma bola de beisebol atravessa a janela e aciona acidentalmente o equipamento. O raio atinge Amy e Nick Szalinski e os vizinhos Russ Jr. e Ron Thompson, reduzindo as quatro crianças a poucos centímetros de altura. Como Wayne e Diane não percebem o acidente, as crianças acabam no lixo e são levadas para o quintal, que passa a parecer uma enorme selva. Perdidos entre folhas de grama, gotas de água e objetos gigantes, eles precisam encontrar o caminho de volta para casa. No percurso, enfrentam os aspersores, uma abelha e outros perigos, além de fazer amizade com uma formiga que chamam de Antie. Quando um escorpião ameaça o grupo, Antie tenta protegê-los e acaba morrendo. Enquanto isso, Wayne e Diane procuram pelos filhos e descobrem que a máquina foi ativada pela bola de beisebol. Com a ajuda do cachorro Quark, as crianças conseguem chamar a atenção dos pais. Wayne reconstrói o funcionamento da máquina e devolve todos ao tamanho normal.',
      itens: [],
    );
  }
}

class PersonagensPage extends StatelessWidget {
  const PersonagensPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A página de personagens percorre a fonte central de dados do elenco e exibe
    // cada integrante em um cartão individual, mantendo a mesma referência usada no
    // carrossel da home e evitando inconsistências de nome ou descrição.
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
              foregroundColor: Colors.white,
              title: const Text(
                'Personagens',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 24),
              children: [
                const Text(
                  'Conheça os personagens da Elixir Corp.',
                  style: TextStyle(
                    color: roxoEscuro,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // A mesma lista do carrossel evita manter nomes duplicados.
                ..._elencoDados.map(
                  (personagem) => _CartaoPersonagem(personagem: personagem),
                ),
                const SizedBox(height: 4),
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

class _Personagem {
  // Modelo de dados usado para representar cada personagem do elenco. O campo de
  // imagem foi deixado configurável para futuras personalizações, mas a aplicação
  // ainda usa uma imagem padrão enquanto os assets específicos não são adicionados.
  final String nome;
  final String descricao;
  final String imagem;

  const _Personagem(
    this.nome,
    this.descricao, {
    this.imagem = 'img/fundonovo.jpg',
  });
}

class _CartaoPersonagem extends StatelessWidget {
  final _Personagem personagem;

  const _CartaoPersonagem({required this.personagem});

  @override
  Widget build(BuildContext context) {
    // Cada cartão de personagem concentra o nome, a descrição curta e um avatar
    // neutro em um bloco visual consistente. Essa estrutura facilita a leitura dos
    // dados e deixa o layout padronizado para qualquer novo membro do elenco.
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: roxoElixir,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: roxoEscuro.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 58,
            backgroundColor: roxoClaro,
            child: const Icon(Icons.person, size: 64, color: roxoElixir),
          ),
          const SizedBox(height: 14),
          Text(
            personagem.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            personagem.descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

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

class ProjetoPage extends StatelessWidget {
  const ProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A página de projeto reúne a descrição geral da iniciativa e lista tópicos
    // complementares em um formato reutilizável, mantendo a apresentação uniforme
    // com as outras telas informativas do aplicativo.
    return const PaginaDetalhes(
      titulo: 'Projeto',
      imagem: 'img/fundonovo.jpg',
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
    // A página da equipe mostra todos os membros em cartões padronizados e inclui
    // um botão de retorno para a navegação principal, preservando a estrutura das
    // telas internas do app e a experiência de uso consistente.
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
              foregroundColor: Colors.white,
              title: const Text(
                'Equipe de desenvolvimento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 24),
              children: [
                const Text(
                  'Conheça quem desenvolveu a Elixir Corp.',
                  style: TextStyle(
                    color: roxoEscuro,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ..._desenvolvedores.map(
                  (desenvolvedor) =>
                      _CartaoDesenvolvedor(desenvolvedor: desenvolvedor),
                ),
                const SizedBox(height: 4),
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

class _Desenvolvedor {
  // Modelo de dados usado para exibir cada membro da equipe. A estrutura separa
  // as informações de apresentação do layout, deixando simples a inclusão de novos
  // perfis com nome, cargo, descrição e imagem opcional.
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

class _CartaoDesenvolvedor extends StatelessWidget {
  final _Desenvolvedor desenvolvedor;

  const _CartaoDesenvolvedor({required this.desenvolvedor});

  @override
  Widget build(BuildContext context) {
    // Cada cartão da equipe reúne foto, nome, função e descrição em um layout
    // uniforme. Quando a imagem do integrante não estiver disponível, o widget usa
    // um avatar genérico para manter o visual consistente e evitar quebra visual.
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: roxoElixir,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: roxoEscuro.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 58,
            backgroundColor: roxoClaro,
            foregroundImage: desenvolvedor.imagem == null
                ? null
                : AssetImage(desenvolvedor.imagem!),
            child: desenvolvedor.imagem == null
                ? const Icon(Icons.person, size: 64, color: roxoElixir)
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            desenvolvedor.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desenvolvedor.funcao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desenvolvedor.descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class PaginaDetalhes extends StatelessWidget {
  // Componente reutilizável para páginas informativas como História, Mascote e
  // Projeto. Ele centraliza imagem, texto principal, lista de itens e botão de
  // retorno, reduzindo duplicação e mantendo a aparência visual consistente.
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
    // Esse layout genericamente renderiza o conteúdo de páginas de detalhes com uma
    // estrutura visual padronizada: imagem destacada, texto contextual, lista de
    // destaques opcionais e um controle de navegação para voltar à tela anterior.
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
