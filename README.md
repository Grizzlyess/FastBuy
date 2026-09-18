# 🚀 FastBuy

Um aplicativo mobile desenvolvido em Flutter focado em facilitar o cadastro e acesso de lojistas e usuários. O projeto possui um fluxo completo de Autenticação e Registro, utilizando persistência de dados local e seguindo boas práticas de separação de responsabilidades (Clean Architecture).

## ✨ Funcionalidades
- **Cadastro Completo:** Registro de novos usuários capturando Nome, Nome do Estabelecimento, Email e Senha (com validação de confirmação de senha).
- **Autenticação:** Tela de Login integrada ao banco de dados para validação de credenciais.
- **Design UI/UX:** Interface moderna e amigável com bordas arredondadas, sobreposição de elementos (Stack) e tipografia customizada.
- **Feedback Visual:** Tratamento de erros e sucesso utilizando `ScaffoldMessenger` (SnackBars).

## 🛠️ Tecnologias Utilizadas
- **[Flutter](https://flutter.dev/):** Framework principal para desenvolvimento da interface mobile.
- **[Dart](https://dart.dev/):** Linguagem de programação.
- **[SQLite (sqflite)](https://pub.dev/packages/sqflite):** Banco de dados embutido para persistência local do cadastro e login.
- **[Google Fonts](https://pub.dev/packages/google_fonts):** Pacote para uso das fontes *Pacifico* e *Poppins*.

## 🏗️ Arquitetura do Projeto
Para garantir escalabilidade e manutenção, o projeto evita o acúmulo de regras de negócio nas telas (UI) e divide as responsabilidades em camadas lógicas:
- `lib/models/`: Contém as Entidades puras do sistema (ex: `usuario_model.dart`), responsáveis por mapear os dados entre a aplicação e o banco.
- `lib/repositories/`: Gerencia as consultas e regras de persistência (ex: `usuario_repository.dart`), separando as queries SQL do resto do app.
- `lib/database/`: Contém as configurações de conexão, inicialização do SQLite e criação/atualização de tabelas (`database_helper.dart`).
- `lib/pages/`: Contém apenas o código visual (UI) e chamadas aos repositórios.

## 🚀 Como clonar e testar o projeto

**Pré-requisitos:** Ter o Flutter SDK e o Android Studio (com um emulador configurado) instalados na sua máquina.

1. Faça o clone deste repositório:
`git clone https://github.com/SEU_USUARIO/FastBuy.git`

2. Entre na pasta do projeto:
`cd FastBuy`

3. Instale as dependências (pacotes):
`flutter pub get`

4. Inicie o aplicativo no seu emulador ou dispositivo físico:
`flutter run`

5. Para limpar:
`flutter clean`

### ⚠️ Solução de Problemas (Troubleshooting)

**Tela preta ao abrir o app no Emulador do Android pelo Linux:**
Se você estiver utilizando o Ubuntu em conjunto com uma placa de vídeo dedicada, o motor gráfico padrão do Flutter (Impeller) pode entrar em conflito com a aceleração de hardware do emulador, causando uma tela completamente preta.

* Mude as configurações gráficas do seu emulador no Android Studio (Device Manager > Edit > Advanced Settings) de `Automatic` ou `Hardware` para `Software`.
* Dica: Use versões mais antigas do Android e dos emuladores.
