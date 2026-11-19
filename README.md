# Lista de Compras

Aplicativo de lista de compras desenvolvido em Flutter e Dart, com armazenamento local utilizando SQLite.

## Objetivo

Permitir que o usuário organize sua lista de compras de maneira simples e prática, cadastrando produtos e suas respectivas quantidades.

## Funcionalidades

- Visualizar todos os produtos cadastrados.
- Adicionar novos produtos.
- Editar o nome e a quantidade dos produtos.
- Excluir produtos da lista.
- Armazenar os dados localmente.
- Validar os campos de cadastro e edição.

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite
- Pacotes sqflite e path
- Visual Studio Code
- Git e GitHub

## Estrutura do projeto

- `lib/main.dart`: inicialização do aplicativo.
- `lib/models/produto.dart`: modelo de dados dos produtos.
- `lib/screens/home_screen.dart`: tela inicial da lista.
- `lib/screens/produto_screen.dart`: tela de cadastro e edição.
- `lib/services/database_service.dart`: operações do banco SQLite.

## Como executar

1. Instale o Flutter SDK e configure o Android SDK.
2. Clone o repositório.
3. Abra a pasta do projeto no Visual Studio Code.
4. Execute `flutter pub get` no terminal.
5. Inicie um emulador Android.
6. Execute `flutter run`.

## Banco de dados

O aplicativo utiliza SQLite para armazenar os produtos diretamente no dispositivo.

Cada produto possui um identificador, um nome e uma quantidade.

O banco de dados é criado automaticamente na primeira utilização do aplicativo.

## Autenticação

O aplicativo não possui autenticação de usuários. Essa funcionalidade foi deixada de fora para manter a proposta simples, considerando que a autenticação é apresentada como recurso opcional no enunciado.

## CRUD

- Create: adicionar produtos.
- Read: visualizar produtos.
- Update: editar produtos.
- Delete: excluir produtos.

## Persistência

Os produtos permanecem cadastrados após o fechamento do aplicativo, enquanto os dados da aplicação forem preservados no dispositivo.