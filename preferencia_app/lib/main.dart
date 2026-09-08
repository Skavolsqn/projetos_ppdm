import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PreferenciaApp());
}

class PreferenciaApp extends StatefulWidget {
  const PreferenciaApp({super.key});

  @override
  State<PreferenciaApp> createState() => _PreferenciaAppState();
}

class _PreferenciaAppState extends State<PreferenciaApp> {
  bool _temaEscuro = false;
  double _tamanhoFonte = 16.0;
  bool _receberNotificacoes = false;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  // Carrega todas as preferências salvas
  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _temaEscuro = prefs.getBool('isDark') ?? false;
      _tamanhoFonte = prefs.getDouble('tamanhoFonte') ?? 16.0;
      _receberNotificacoes =
          prefs.getBool('receberNotificacoes') ?? false;
    });
  }

  // Altera e salva o tema
  Future<void> _alternarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDark', valor);

    setState(() {
      _temaEscuro = valor;
    });
  }

  // Salva o tamanho da fonte
  Future<void> _alterarTamanhoFonte(double valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('tamanhoFonte', valor);

    setState(() {
      _tamanhoFonte = valor;
    });
  }

  // Salva a preferência de notificações
  Future<void> _alternarNotificacoes(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('receberNotificacoes', valor);

    setState(() {
      _receberNotificacoes = valor;
    });
  }

  // Limpa todas as configurações
  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      _temaEscuro = false;
      _tamanhoFonte = 16.0;
      _receberNotificacoes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferências do Usuário',
      debugShowCheckedModeBanner: false,
      theme: _temaEscuro
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: ConfigScreen(
        temaEscuro: _temaEscuro,
        tamanhoFonte: _tamanhoFonte,
        receberNotificacoes: _receberNotificacoes,
        onTemaAlterado: _alternarTema,
        onTamanhoFonteAlterado: _alterarTamanhoFonte,
        onNotificacoesAlterado: _alternarNotificacoes,
        onLimparConfiguracoes: _limparConfiguracoes,
      ),
    );
  }
}

class ConfigScreen extends StatefulWidget {
  final bool temaEscuro;
  final double tamanhoFonte;
  final bool receberNotificacoes;

  final ValueChanged<bool> onTemaAlterado;
  final ValueChanged<double> onTamanhoFonteAlterado;
  final ValueChanged<bool> onNotificacoesAlterado;
  final Future<void> Function() onLimparConfiguracoes;

  const ConfigScreen({
    super.key,
    required this.temaEscuro,
    required this.tamanhoFonte,
    required this.receberNotificacoes,
    required this.onTemaAlterado,
    required this.onTamanhoFonteAlterado,
    required this.onNotificacoesAlterado,
    required this.onLimparConfiguracoes,
  });

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _nomeController = TextEditingController();
  String _nomeSalvo = '';

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nomeSalvo =
          prefs.getString('usuario_nome') ?? 'Não informado';

      _nomeController.text =
          prefs.getString('usuario_nome') ?? '';
    });
  }

  Future<void> _salvarNome() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'usuario_nome',
      _nomeController.text.trim(),
    );

    setState(() {
      _nomeSalvo = _nomeController.text.trim();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nome salvo localmente com sucesso!',
          ),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  // Retorna o nome do tamanho da fonte
  String _nomeTamanhoFonte() {
    if (widget.tamanhoFonte == 14.0) {
      return 'Pequeno';
    } else if (widget.tamanhoFonte == 16.0) {
      return 'Médio';
    } else {
      return 'Grande';
    }
  }

  // Limpa as configurações
  Future<void> _limparTudo() async {
    await widget.onLimparConfiguracoes();

    setState(() {
      _nomeSalvo = 'Não informado';
      _nomeController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações apagadas com sucesso!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações Locais',
          style: TextStyle(
            fontSize: widget.tamanhoFonte + 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            // MODO ESCURO
            Card(
              child: SwitchListTile(
                title: Text(
                  'Modo Escuro',
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte,
                  ),
                ),
                subtitle: Text(
                  'Ativar visual escuro na aplicação',
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte - 2,
                  ),
                ),
                secondary: Icon(_temaEscuroIcone()),
                value: widget.temaEscuro,
                onChanged: widget.onTemaAlterado,
              ),
            ),

            const SizedBox(height: 10),

            // EXERCÍCIO 03 - NOTIFICAÇÕES
            Card(
              child: SwitchListTile(
                title: Text(
                  'Receber Notificações',
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte,
                  ),
                ),
                subtitle: Text(
                  'Permitir notificações da aplicação',
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte - 2,
                  ),
                ),
                secondary: const Icon(Icons.notifications),
                value: widget.receberNotificacoes,
                onChanged: widget.onNotificacoesAlterado,
              ),
            ),

            const SizedBox(height: 20),

            // EXERCÍCIO 02 - TAMANHO DA FONTE
            Text(
              'Tamanho da Fonte',
              style: TextStyle(
                fontSize: widget.tamanhoFonte + 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: DropdownButton<double>(
                  isExpanded: true,
                  value: widget.tamanhoFonte,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 14.0,
                      child: Text('Pequeno'),
                    ),
                    DropdownMenuItem(
                      value: 16.0,
                      child: Text('Médio'),
                    ),
                    DropdownMenuItem(
                      value: 20.0,
                      child: Text('Grande'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      widget.onTamanhoFonteAlterado(valor);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Perfil do Usuário',
              style: TextStyle(
                fontSize: widget.tamanhoFonte + 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _nomeController,
              style: TextStyle(
                fontSize: widget.tamanhoFonte,
              ),
              decoration: const InputDecoration(
                labelText: 'Nome do Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarNome,
                icon: const Icon(Icons.save),
                label: Text(
                  'Salvar Nome',
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte,
                  ),
                ),
              ),
            ),

            const Divider(height: 40),

            Text(
              'Valor atual salvo no disco: $_nomeSalvo',
              style: TextStyle(
                fontSize: widget.tamanhoFonte,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 30),

            // EXERCÍCIO 01 - LIMPAR CONFIGURAÇÕES
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _limparTudo,
                icon: const Icon(Icons.delete_forever),
                label: Text(
                  'Limpar Configurações',
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                'Fonte selecionada: ${_nomeTamanhoFonte()}',
                style: TextStyle(
                  fontSize: widget.tamanhoFonte,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _temaEscuroIcone() {
    return widget.temaEscuro
        ? Icons.dark_mode
        : Icons.light_mode;
  }
}