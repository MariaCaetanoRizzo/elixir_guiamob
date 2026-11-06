# Elixir Corp

Aplicativo desenvolvido em **Flutter e Dart** para apresentar as informações do projeto Elixir Corp de maneira interativa, organizada e visualmente agradável.

## Sobre o projeto

O Elixir Corp é um aplicativo que reúne diferentes conteúdos relacionados ao projeto, permitindo que o usuário navegue entre páginas informativas sobre a história, os personagens, o mascote, a proposta do projeto e sua equipe de desenvolvimento.

A interface utiliza uma identidade visual baseada em tons de roxo, com cartões, imagens e elementos interativos.

## Tecnologias utilizadas

- **Flutter:** framework utilizado para o desenvolvimento da interface.
- **Dart:** linguagem de programação.
- **JSON:** armazenamento e organização dos dados.
- **Material Design:** base dos componentes visuais do aplicativo.

## Funcionalidades

- **Página inicial:** apresentação e navegação pelo aplicativo.
- **História:** apresentação da história do projeto.
- **Personagens:** exibição dos personagens cadastrados em arquivos JSON.
- **Carrossel interativo:** navegação entre personagens por gestos e botões.
- **Mascote:** apresentação do mascote do projeto.
- **Projeto:** informações sobre a proposta e o desenvolvimento.
- **Equipe:** apresentação dos integrantes e suas respectivas funções.

## Recursos de desenvolvimento

- Navegação com `Navigator` e `MaterialPageRoute`.
- Organização de telas com widgets reutilizáveis.
- Carregamento de informações por arquivos JSON.
- Conversão de dados utilizando `dart:convert`.
- Leitura de arquivos com `rootBundle.loadString()`.
- Exibição de imagens locais e imagens da internet.
- Carrossel de personagens com `PageView.builder`.
- Tratamento de falhas no carregamento de imagens.

## Organização do projeto

```text
assets/
├── json/
│   ├── arquivo.json
│   └── projeto.json
│
└── img/
    ├── logoelixir.png
    └── imagens dos personagens e integrantes

lib/
└── main.dart
```

*Essa estrutura representa a organização lógica dos arquivos utilizados no projeto.*

## Identidade visual

A interface utiliza uma paleta de cores baseada em tons de roxo:

| Elemento | Cor |
|---|---|
| Roxo principal | `#6A1B9A` |
| Roxo dos botões | `#9B59B6` |
| Roxo escuro | `#35104F` |
| Roxo claro | `#F3E8FA` |

## Equipe de desenvolvimento

| Integrante | Responsabilidade |
|---|---|
| Rihan de Jesus | Líder do grupo de TCC, desenvolvedor da Unity e artista. |
| Vinicius Abdala | Vice-líder, desenvolvedor Unity e back-end. |
| Gabriel Coutinho | Modelador 3D. |
| Maria Caetano Rizzo | Desenvolvedora mobile e desenvolvedora de personagem. |
| Arthur Paixão | Roteirista e desenvolvedor da documentação. |

## Referência de desenvolvimento

A estrutura inicial do aplicativo teve como referência um projeto Flutter desenvolvido anteriormente para *Querida, Encolhi as Crianças*.

O código e a organização estrutural foram utilizados como ponto de partida, passando por adaptações para atender às funcionalidades, ao conteúdo e à identidade visual do Elixir Corp.

**Projeto de referência:**  
[Querida, Encolhi as Crianças — GitHub](https://github.com/MariaCaetanoRizzo/flutter_filme_1.git)

## Considerações finais

O Elixir Corp foi desenvolvido com Flutter e Dart, utilizando arquivos JSON para organizar os dados e widgets reutilizáveis para estruturar sua interface.

O projeto busca apresentar suas informações de forma intuitiva, facilitando a navegação e a experiência do usuário.
