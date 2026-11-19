
import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../services/database_service.dart';
import 'produto_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _database = DatabaseService();

  List<Produto> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      final lista = await _database.listarProdutos();

      if (!mounted) return;

      setState(() {
        _produtos = lista;
        _carregando = false;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar os produtos.'),
        ),
      );
    }
  }

  Future<void> _abrirFormulario([Produto? produto]) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProdutoScreen(
          produto: produto,
        ),
      ),
    );

    if (resultado == true) {
      await _carregarProdutos();
    }
  }

  Future<void> _excluirProduto(Produto produto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text(
            'Deseja excluir "${produto.nome}" da lista?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      await _database.excluirProduto(produto.id!);
      await _carregarProdutos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto excluído com sucesso!'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir o produto.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Compras'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _produtos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Sua lista está vazia!',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Adicione seu primeiro produto.',
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.shopping_basket,
                          color: Colors.green,
                        ),
                        title: Text(produto.nome),
                        subtitle: Text(
                          'Quantidade: ${produto.quantidade}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar',
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                _abrirFormulario(produto);
                              },
                            ),
                            IconButton(
                              tooltip: 'Excluir',
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _excluirProduto(produto);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }
}
