
import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../services/database_service.dart';

class ProdutoScreen extends StatefulWidget {
  final Produto? produto;

  const ProdutoScreen({
    super.key,
    this.produto,
  });

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _database = DatabaseService();

  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    if (widget.produto != null) {
      _nomeController.text = widget.produto!.nome;
      _quantidadeController.text =
          widget.produto!.quantidade.toString();
    }
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _salvando = true;
    });

    final produto = Produto(
      id: widget.produto?.id,
      nome: _nomeController.text.trim(),
      quantidade: int.parse(
        _quantidadeController.text.trim(),
      ),
    );

    try {
      if (widget.produto == null) {
        await _database.inserirProduto(produto);
      } else {
        await _database.atualizarProduto(produto);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar o produto.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.produto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar produto' : 'Novo produto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                  hintText: 'Ex: Arroz',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome do produto';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: 'Ex: 2',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  final quantidade = int.tryParse(
                    valor?.trim() ?? '',
                  );

                  if (quantidade == null || quantidade <= 0) {
                    return 'Informe uma quantidade maior que zero';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _salvando ? null : _salvarProduto,
                icon: const Icon(Icons.save),
                label: Text(
                  _salvando ? 'Salvando...' : 'Salvar produto',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
