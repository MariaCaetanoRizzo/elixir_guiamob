// Decodificação do arquivo JSON que contém os dados do elenco.
import 'dart:convert';

// Widgets e componentes visuais usados nas telas do aplicativo.
import 'package:flutter/material.dart';
// Acesso aos assets empacotados, como o JSON e as imagens locais.
import 'package:flutter/services.dart';

/// Modelo imutável que representa um personagem carregado do arquivo JSON.
/// Cada instância desse objeto guarda os dados básicos do elenco usado em vários pontos da app.
/// A estrutura foi criada para separar o conteúdo bruto do JSON da interface visual do Flutter.
class Personagem {
  /// Cria um personagem com todos os dados fornecidos pelo arquivo.
  /// Os campos obrigatórios deixam o objeto consistente e evitam valores nulos inesperados.
  const Personagem({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.principal,
    required this.imagem,
  });

  final int id; // Identificador único do personagem no elenco.
  final String nome; // Nome exibido nas páginas e no carrossel.
  final String descricao; // Texto descritivo exibido junto ao nome.
  final bool principal; // Indica se o personagem pertence ao núcleo principal.
  final String imagem; // Caminho local ou endereço remoto da imagem.

  /// Converte um registro JSON em um objeto usado pela interface Flutter.
  /// Este factory atua como ponte entre os dados cru e o modelo tipado da aplicação.
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

// Cache da leitura para que a tela inicial e a página de elenco compartilhem
// a mesma operação assíncrona e os mesmos dados carregados.
// Isso evita realizar a leitura do JSON várias vezes durante a navegação do app.
Future<List<Personagem>>? _personagensEmCarregamento;

/// Lê o JSON do bundle, converte cada registro e limita o elenco a 16 itens.
/// A função usa uma variável global de cache para reaproveitar o mesmo carregamento.
Future<List<Personagem>> carregarPersonagens() {
  return _personagensEmCarregamento ??= rootBundle
      .loadString('json/arquivo.json')
      .then((conteudo) {
        // Decodifica a lista dinâmica e transforma cada mapa no modelo tipado.
        // O cast para List<dynamic> é necessário porque o JSON vem em formato genérico.
        final dados = jsonDecode(conteudo) as List<dynamic>;
        return dados
            .map((item) => Personagem.fromJson(item as Map<String, dynamic>))
            .take(16)
            .toList();
      });
}

/// Modelo tipado do conteúdo apresentado na página Projeto.
/// O projeto possui título, imagem de destaque, texto principal e lista de destaques.
class Projeto {
  const Projeto({
    required this.titulo,
    required this.imagem,
    required this.texto,
    required this.itens,
  });

  final String titulo; // Nome do projeto mostrado no cabeçalho da página.
  final String imagem; // Caminho da imagem ilustrativa da proposta.
  final String texto; // Texto explicativo principal do projeto.
  final List<String> itens; // Lista de pontos destacados na apresentação.

  /// Converte um mapa JSON em um objeto Projeto para uso na interface.
  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      titulo: json['titulo'] as String,
      imagem: json['imagem'] as String,
      texto: json['texto'] as String,
      itens: List<String>.from(json['itens'] as List<dynamic>),
    );
  }
}

// Cache do conteúdo do projeto para não ler o mesmo arquivo do bundle repetidamente.
Future<Projeto>? _projetoEmCarregamento;

/// Carrega do bundle o conteúdo que alimenta a página Projeto.
/// O JSON é convertido em um modelo Projeto e reaproveitado em toda a vida do app.
Future<Projeto> carregarProjeto() {
  return _projetoEmCarregamento ??= rootBundle
      .loadString('json/projeto.json')
      .then((conteudo) {
        final dados = jsonDecode(conteudo) as Map<String, dynamic>;
        return Projeto.fromJson(dados);
      });
}

// Cache do texto do mascote para evitar vários acessos ao arquivo de texto.
Future<String>? _textoMascoteEmCarregamento;

/// Carrega do bundle o texto que apresenta o mascote.
/// O resultado é uma String simples que pode ser exibida diretamente em um Text.
Future<String> carregarTextoMascote() {
  return _textoMascoteEmCarregamento ??= rootBundle.loadString(
    'json/mascote.txt',
  );
}

// Ponto de entrada: cria a árvore de widgets e inicia o aplicativo Flutter.
// Todo app Flutter precisa de uma função main que chama runApp com o widget raiz.
void main() {
  runApp(const MainApp());
}

// Cores compartilhadas para manter a identidade visual consistente nas telas.
// Essa paleta define a identidade visual roxa do projeto e é reutilizada em vários widgets.
const roxoElixir = Color(0xFF6A1B9A);
const roxoBotao = Color(0xFF9B59B6);
const roxoEscuro = Color(0xFF35104F);
const roxoClaro = Color(0xFFF3E8FA);

/// Widget raiz com estado para controlar rolagem, navegação e carrossel.
/// Uma tela inicial com várias seções e acesso às páginas de conteúdo do projeto.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Estado principal do aplicativo: controla rolagem, navegação e posição do carrossel.
  // Esta classe gerencia o ciclo de vida da tela inicial e as interações entre as seções.
  // Controladores da rolagem da página inicial e do carrossel de personagens.
  // O ScrollController acompanha a navegação vertical da home e o PageController controla a troca de slides.
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  // Permite navegar para as páginas mantendo uma única pilha de rotas.
  // Com esse navigator global, a aplicação pode empilhar telas sem depender de um scaffold local.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // A mesma carga de personagens é usada no carrossel e em outras páginas.
  // Isso evita duplicar o carregamento do JSON em diferentes widgets.
  final Future<List<Personagem>> _personagensFuture = carregarPersonagens();
  // Índice atual usado para exibir a posição no carrossel.
  // Esse valor é atualizado sempre que o PageView muda de página.
  int _indicePersonagemAtual = 0;

  // Chaves que identificam as seções da página inicial para navegação/rolagem.
  // Elas permitem apontar diretamente para uma parte da home quando a lógica demanda rolagem ou foco.
  final GlobalKey _secaoHistoriaKey = GlobalKey();
  final GlobalKey _secaoElencoKey = GlobalKey();
  final GlobalKey _secaoCuriosidadesKey = GlobalKey();
  final GlobalKey _secaoRapazesKey = GlobalKey();

  // Avança uma posição ou volta ao primeiro personagem ao chegar ao fim.
  // Esse método é usado pelos botões de navegação do carrossel e mantém a rotação infinita.
  Future<void> _proximoPersonagem() async {
    // Aguarda o carregamento para conhecer o tamanho total do elenco.
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

  // Volta uma posição ou salta para o último personagem no início da lista.
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

  // Abre uma página como nova rota, preservando a tela anterior na pilha.
  void _navegarParaPagina(Widget pagina) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

  // Monta o carrossel e trata os estados de erro, carregamento e sucesso.
  // O widget usa FutureBuilder para renderizar a lista de personagens somente após o JSON ser lido.
  // Essa forma é a mais simples para lidar com dados assíncronos em Flutter.
  Widget _construirCarrosselPersonagens() {
    return FutureBuilder<List<Personagem>>(
      future: _personagensFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Não foi possível carregar os personagens.');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Com os dados disponíveis, cria controles e páginas do carrossel.
        final personagens = snapshot.data!;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      itemCount: personagens.length,
                      onPageChanged: (index) {
                        // Sincroniza o contador com a página selecionada.
                        setState(() {
                          _indicePersonagemAtual = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        // Cada página mostra a imagem e o nome do personagem.
                        final personagem = personagens[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            construirCardImagem(personagem.imagem),
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
                '${_indicePersonagemAtual + 1} de ${personagens.length}',
                style: const TextStyle(fontSize: 12, color: Colors.white60),
              ),
            ),
          ],
        );
      },
    );
  }

  // Libera recursos associados aos controladores quando a tela é removida.
  // Essa etapa evita vazamento de memória e garante que os objetos de rolagem sejam encerrados corretamente.
  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Configura o tema visual do aplicativo, a navegação global e a estrutura da tela principal.
    // É aqui que a interface de abertura do app é montada com o cabeçalho, menu e seções internas.
    // MaterialApp é o ponto de entrada para a árvore do Material Design e define o tema central do app.
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
                // Cabeçalho principal do app, com nome do projeto e menu de acesso rápido.
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
                  // Esse menu horizontal funciona como atalho para as páginas internas do app.
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
                // Permite a rolagem da home em dispositivos com pouca altura de tela.
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Agrupa o conteúdo da página inicial em um painel visual.
                    // Esse container centraliza as seções principais em um bloco roxo com sombra e bordas arredondadas.
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
                          // Imagem de marca com camada escura.
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
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Resumo da história com acesso à página completa.
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

                              // Imagem ilustrativa da seção de história.
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

                          // Carrossel resumido com acesso ao elenco completo.
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
                          const SizedBox(height: 30),

                          // Resumo do mascote com acesso à página de detalhes.
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

                              // Imagem ilustrativa do mascote na página inicial.
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

                          // Resumo visual do projeto com botão para mais detalhes.
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
                          const SizedBox(height: 30),

                          // Chamada visual para conhecer a equipe de desenvolvimento.
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

                              // Imagem de apresentação da equipe na página inicial.
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
}

/// Renderiza uma imagem local ou remota com dimensões e recorte configuráveis.
/// Usa o logotipo como alternativa quando o caminho está vazio ou falha.
/// Esse helper padroniza a exibição de fotos em telas diferentes, evitando repetição de lógica visual.
Widget construirCardImagem(
  String? path, {
  double width = double.infinity,
  double height = 200,
  BoxFit fit = BoxFit.contain,
}) {
  // Distingue endereços web de caminhos de assets incluídos no aplicativo.
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
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Image.asset(
                  'img/logoelixir.png',
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                );
              },
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'img/logoelixir.png',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            )
          : assetValido
          ? Image.asset(
              path,
              width: width,
              height: height,
              fit: fit,
              // serve para selecionar uma imagem alternativa caso o asset não seja encontrado.
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'img/logoelixir.png',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            )
          : Image.asset(
              'img/logoelixir.png',
              width: width,
              height: height,
              fit: BoxFit.contain,
            ),
    ),
  );
}

/// Página de história, preenchida no layout reutilizável de detalhes.
class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mantém o texto e a imagem da história centralizados em um único layout.
    return const PaginaDetalhes(
      titulo: 'História',
      imagem: 'img/logoelixir.png',
      texto:
          'Wayne Szalinski é um inventor que trabalha em uma máquina capaz de encolher objetos. Durante uma experiência no sótão, uma bola de beisebol atravessa a janela e aciona acidentalmente o equipamento. O raio atinge Amy e Nick Szalinski e os vizinhos Russ Jr. e Ron Thompson, reduzindo as quatro crianças a poucos centímetros de altura. Como Wayne e Diane não percebem o acidente, as crianças acabam no lixo e são levadas para o quintal, que passa a parecer uma enorme selva. Perdidos entre folhas de grama, gotas de água e objetos gigantes, eles precisam encontrar o caminho de volta para casa. No percurso, enfrentam os aspersores, uma abelha e outros perigos, além de fazer amizade com uma formiga que chamam de Antie. Quando um escorpião ameaça o grupo, Antie tenta protegê-los e acaba morrendo. Enquanto isso, Wayne e Diane procuram pelos filhos e descobrem que a máquina foi ativada pela bola de beisebol. Com a ajuda do cachorro Quark, as crianças conseguem chamar a atenção dos pais. Wayne reconstrói o funcionamento da máquina e devolve todos ao tamanho normal.',
      itens: [],
    );
  }
}

/// Página dedicada que apresenta o elenco completo em uma lista rolável.
/// Esta tela é uma versão ampliada do carrossel, exibindo cada personagem em um cartão próprio.
class PersonagensPage extends StatefulWidget {
  const PersonagensPage({super.key});

  @override
  State<PersonagensPage> createState() => _PersonagensPageState();
}

class _PersonagensPageState extends State<PersonagensPage> {
  // Inicia a leitura compartilhada do JSON ao criar o estado da página.
  final Future<List<Personagem>> _personagensFuture = carregarPersonagens();

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
              foregroundColor: Colors.white,
              title: const Text('Personagens'),
            ),
            body: FutureBuilder<List<Personagem>>(
              future: _personagensFuture,
              builder: (context, snapshot) {
                // Informa ao usuário quando não foi possível ler o elenco.
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Não foi possível carregar os personagens.'),
                  );
                }
                // Exibe indicador enquanto o asset JSON ainda está sendo lido.
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Exibe um cartão por personagem assim que os dados chegam.
                final personagens = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final personagem in personagens)
                      // Cartão com foto à esquerda e dados textuais à direita.
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
                        child: Row(
                          children: [
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

/// Página de detalhes do mascote usando o layout compartilhado.
/// Esse widget lê o texto do mascote do arquivo .txt e reutiliza a estrutura visual da página de detalhes.
/// A ideia é manter o conteúdo textual e a formatação da interface em um único padrão.
class MascotePage extends StatelessWidget {
  const MascotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: carregarTextoMascote(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PaginaDetalhes(
            titulo: 'Mascote',
            imagem: 'img/mascote.png',
            texto: snapshot.data!,
            itens: const [],
          );
        }

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
            child: snapshot.hasError
                ? const Text('Não foi possível carregar o texto do mascote.')
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

/// Página de detalhes que resume a proposta do projeto.
/// O conteúdo desse widget é carregado de um JSON específico e exibido em um layout padrão.
/// O FutureBuilder faz a ponte entre o conteúdo dinâmico e a renderização da tela.
class ProjetoPage extends StatelessWidget {
  const ProjetoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Projeto>(
      future: carregarProjeto(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final projeto = snapshot.data!;
          return PaginaDetalhes(
            titulo: projeto.titulo,
            imagem: projeto.imagem,
            texto: projeto.texto,
            itens: projeto.itens,
          );
        }

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
            child: snapshot.hasError
                ? const Text('Não foi possível carregar o conteúdo do projeto.')
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

/// Página que apresenta os integrantes e suas responsabilidades no projeto.
/// A tela usa uma lista fixa de membros com foto, nome e descrição, montando um painel de equipe visual.
/// É um exemplo de tela sem carregamento assíncrono: todos os dados estão embutidos nessa própria classe.
class EquipePage extends StatelessWidget {
  const EquipePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados locais dos integrantes: nome, função e caminho da respectiva foto.
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
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cada integrante recebe um cartão com retrato e descrição.
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
                    child: Row(
                      children: [
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

/// Layout comum às páginas de história, mascote e projeto.
/// Recebe título, imagem, texto principal e uma lista opcional de destaques.
/// Esse widget centraliza a apresentação visual das páginas de conteúdo, reduzindo duplicação de código.
/// Ele funciona como um template reutilizável para qualquer página de conteúdo textual do projeto.
class PaginaDetalhes extends StatelessWidget {
  // Conteúdo variável que cada página injeta no layout compartilhado.
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
    // Organiza o conteúdo em uma página rolável para acomodar textos longos.
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
