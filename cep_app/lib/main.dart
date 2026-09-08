import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'models/endereco.dart';
import 'services/via_cep_service.dart';

void main() {
  runApp(const CepApp());
}

class CepApp extends StatelessWidget {
  const CepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cepController =
      TextEditingController();

  Endereco? _enderecoResult;

  bool _isLoading = false;

  String? _errorMessage;

  final List<String> _historico = [];

  String? _cotacaoDolar;

  bool _carregandoDolar = false;

  @override
  void initState() {
    super.initState();
    _buscarCotacaoDolar();
  }

  Future<void> _consultarCep() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _enderecoResult = null;
    });

    try {
      final resultado =
          await ViaCepService.buscarCep(
        _cepController.text,
      );

      setState(() {
        _enderecoResult = resultado;

        final cep =
            _cepController.text;

        if (!_historico.contains(cep)) {
          _historico.insert(
            0,
            cep,
          );
        }

        if (_historico.length > 5) {
          _historico.removeLast();
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e
            .toString()
            .replaceAll(
              'Exception: ',
              '',
            );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _buscarCotacaoDolar() async {
    setState(() {
      _carregandoDolar = true;
    });

    try {
      final url = Uri.parse(
        'https://economia.awesomeapi.com.br/json/last/USD-BRL',
      );

      final response =
          await http.get(url);

      if (response.statusCode == 200) {
        final dados =
            jsonDecode(response.body);

        final cotacao =
            dados['USDBRL']['bid'];

        setState(() {
          _cotacaoDolar = cotacao;
        });
      } else {
        throw Exception(
          'Erro ao buscar cotação.',
        );
      }
    } catch (e) {
      setState(() {
        _cotacaoDolar =
            'Não foi possível carregar';
      });
    } finally {
      setState(() {
        _carregandoDolar = false;
      });
    }
  }

  void _usarCepHistorico(
    String cep,
  ) {
    setState(() {
      _cepController.text = cep;
    });

    _consultarCep();
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Consulta CEP (ViaCEP API)',
        ),
        backgroundColor:
            Colors.indigo,
        foregroundColor:
            Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller:
                    _cepController,
                keyboardType:
                    TextInputType.number,
                maxLength: 9,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                  CepInputFormatter(),
                ],
                decoration:
                    const InputDecoration(
                  labelText:
                      'Informe o CEP',
                  hintText:
                      'Ex: 01001-000',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(
                    Icons.location_on,
                  ),
                  counterText: '',
                ),
                onSubmitted: (_) {
                  _consultarCep();
                },
              ),

              const SizedBox(
                height: 12,
              ),

              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _consultarCep,
                icon:
                    const Icon(
                  Icons.search,
                ),
                label:
                    const Text(
                  'Buscar Endereço',
                ),
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.indigo,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Card(
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color:
                                Colors.green,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Cotação do Dólar',
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      if (_carregandoDolar)
                        const CircularProgressIndicator(),

                      if (!_carregandoDolar)
                        Text(
                          _cotacaoDolar == null
                              ? 'Carregando...'
                              : 'US\$ 1,00 = R\$ $_cotacaoDolar',
                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                      const SizedBox(
                        height: 10,
                      ),

                      ElevatedButton(
                        onPressed:
                            _buscarCotacaoDolar,
                        child:
                            const Text(
                          'Atualizar Cotação',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              if (_isLoading)
                const Center(
                  child:
                      CircularProgressIndicator(),
                ),

              if (_errorMessage != null)
                Card(
                  color:
                      Colors.red.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16.0,
                    ),
                    child: Text(
                      _errorMessage!,
                      style:
                          const TextStyle(
                        color:
                            Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              if (_enderecoResult != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16.0,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          _enderecoResult!
                              .logradouro,
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Bairro: ${_enderecoResult!.bairro}',
                        ),

                        Text(
                          'Cidade/UF: ${_enderecoResult!.localidade} - ${_enderecoResult!.uf}',
                        ),

                        Text(
                          'CEP: ${_enderecoResult!.cep}',
                        ),

                        if (_enderecoResult!
                            .complemento
                            .isNotEmpty)
                          Text(
                            'Complemento: ${_enderecoResult!.complemento}',
                          ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(
                height: 20,
              ),

              if (_historico.isNotEmpty)
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'Histórico de Buscas',
                          style:
                              TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ..._historico.map(
                          (cep) {
                            return ListTile(
                              leading:
                                  const Icon(
                                Icons.history,
                              ),
                              title:
                                  Text(
                                cep,
                              ),
                              trailing:
                                  const Icon(
                                Icons.search,
                              ),
                              onTap: () {
                                _usarCepHistorico(
                                  cep,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CepInputFormatter
    extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String texto =
        newValue.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (texto.length > 8) {
      texto = texto.substring(
        0,
        8,
      );
    }

    if (texto.length > 5) {
      texto =
          '${texto.substring(0, 5)}-${texto.substring(5)}';
    }

    return TextEditingValue(
      text: texto,
      selection:
          TextSelection.collapsed(
        offset: texto.length,
      ),
    );
  }
}