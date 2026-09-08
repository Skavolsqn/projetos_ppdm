import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/tarefa.dart';

void main() {
  runApp(const TarefasDbApp());
}

class TarefasDbApp extends StatelessWidget {
  const TarefasDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TarefasScreen(),
    );
  }
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Tarefa> _tarefas = [];

  bool _carregando = true;

  final TextEditingController _buscaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  // Carregar todas as tarefas
  Future<void> _atualizarLista() async {
    setState(() => _carregando = true);

    final dados =
        await DatabaseHelper.instance.queryAll();

    setState(() {
      _tarefas = dados;
      _carregando = false;
    });
  }

  // EXERCÍCIO 03 - Buscar tarefas
  Future<void> _buscarTarefas(String texto) async {
    if (texto.trim().isEmpty) {
      _atualizarLista();
      return;
    }

    setState(() => _carregando = true);

    final dados =
        await DatabaseHelper.instance.search(texto.trim());

    setState(() {
      _tarefas = dados;
      _carregando = false;
    });
  }

  // Adicionar tarefa
  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) return;

    await DatabaseHelper.instance.insert(
      Tarefa(titulo: titulo.trim()),
    );

    _atualizarLista();
  }

  // Alterar status
  Future<void> _alternarStatus(Tarefa tarefa) async {
    final atualizada =
        tarefa.copyWith(concluida: !tarefa.concluida);

    await DatabaseHelper.instance.update(atualizada);

    _atualizarLista();
  }

  // Remover uma tarefa
  Future<void> _removerTarefa(int id) async {
    await DatabaseHelper.instance.delete(id);

    _atualizarLista();
  }

  // EXERCÍCIO 02 - Remover todas as tarefas
  Future<void> _limparTodasTarefas() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar tarefas'),
        content: const Text(
          'Deseja realmente apagar todas as tarefas?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, false);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            child: const Text('Apagar tudo'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await DatabaseHelper.instance.deleteAll();

      _buscaController.clear();

      _atualizarLista();
    }
  }

  // Dialog para adicionar tarefa
  void _exibirDialogCadastro() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Tarefa (SQLite)'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Descrição da tarefa',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _adicionarTarefa(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Persistência Relacional (SQLite)',
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,

        // EXERCÍCIO 02
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Limpar todas as tarefas',
            onPressed: _tarefas.isEmpty
                ? null
                : _limparTodasTarefas,
          ),
        ],
      ),

      body: Column(
        children: [

          // EXERCÍCIO 03 - Campo de busca
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar tarefa',
                hintText: 'Digite o nome da tarefa',
                prefixIcon: const Icon(Icons.search),

                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaController.clear();
                          _atualizarLista();
                        },
                      )
                    : null,

                border: const OutlineInputBorder(),
              ),

              onChanged: _buscarTarefas,
            ),
          ),

          // Lista de tarefas
          Expanded(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _tarefas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa encontrada.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tarefas.length,
                        itemBuilder: (ctx, i) {
                          final t = _tarefas[i];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: t.concluida,
                                onChanged: (_) =>
                                    _alternarStatus(t),
                              ),
                              title: Text(
                                t.titulo,
                                style: TextStyle(
                                  decoration: t.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: t.concluida
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _removerTarefa(t.id!),
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // EXERCÍCIO 01 - Contador de tarefas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Text(
              'Total de tarefas registradas: ${_tarefas.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogCadastro,
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}