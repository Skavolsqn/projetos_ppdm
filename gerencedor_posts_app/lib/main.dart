import 'package:flutter/material.dart';
import 'models/post.dart';
import 'services/post_service.dart';

void main() {
  runApp(const GerenciadorPostsApp());
}

class GerenciadorPostsApp extends StatelessWidget {
  const GerenciadorPostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Posts API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  List<Post> _postsFiltrados = [];

  bool _isLoading = true;
  bool _pesquisando = false;

  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await PostService.fetchPosts();

      setState(() {
        _posts = posts;
        _postsFiltrados = List.from(posts);
      });
    } catch (e) {
      _mostrarSnackBar(
        'Erro ao carregar posts: $e',
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filtrarPosts(String texto) {
    setState(() {
      if (texto.isEmpty) {
        _postsFiltrados = List.from(_posts);
      } else {
        _postsFiltrados = _posts.where((post) {
          return post.title
              .toLowerCase()
              .contains(texto.toLowerCase());
        }).toList();
      }
    });
  }

  void _mostrarSnackBar(
    String mensagem,
    Color cor,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
      ),
    );
  }

  void _abrirFormulario({Post? post}) {
    final titleController =
        TextEditingController(
      text: post?.title ?? '',
    );

    final bodyController =
        TextEditingController(
      text: post?.body ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          post == null
              ? 'Novo Post (POST)'
              : 'Editar Post (PUT)',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Conteúdo',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final novoTitle =
                  titleController.text.trim();

              final novoBody =
                  bodyController.text.trim();

              if (novoTitle.isEmpty ||
                  novoBody.isEmpty) {
                _mostrarSnackBar(
                  'Preencha todos os campos!',
                  Colors.red,
                );
                return;
              }

              if (post == null) {
                try {
                  final resultado =
                      await PostService.createPost(
                    Post(
                      title: novoTitle,
                      body: novoBody,
                    ),
                  );

                  final novoPost =
                      resultado['post'] as Post;

                  final statusCode =
                      resultado['statusCode'] as int;

                  setState(() {
                    _posts.insert(
                      0,
                      novoPost,
                    );

                    _postsFiltrados =
                        List.from(_posts);
                  });

                  _mostrarSnackBar(
                    'Post criado com sucesso! '
                    'Status Code: $statusCode',
                    Colors.green,
                  );
                } catch (e) {
                  _mostrarSnackBar(
                    e.toString(),
                    Colors.red,
                  );
                }
              } else {
                try {
                  final resultado =
                      await PostService.updatePost(
                    post.id!,
                    Post(
                      id: post.id,
                      title: novoTitle,
                      body: novoBody,
                    ),
                  );

                  final postAtualizado =
                      resultado['post'] as Post;

                  final statusCode =
                      resultado['statusCode'] as int;

                  setState(() {
                    final index =
                        _posts.indexWhere(
                      (p) =>
                          p.id ==
                          post.id,
                    );

                    if (index != -1) {
                      _posts[index] =
                          postAtualizado;
                    }

                    _postsFiltrados =
                        List.from(_posts);
                  });

                  _mostrarSnackBar(
                    'Post atualizado com sucesso! '
                    'Status Code: $statusCode',
                    Colors.blue,
                  );
                } catch (e) {
                  _mostrarSnackBar(
                    e.toString(),
                    Colors.red,
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletarPost(int id) async {
    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Confirmar exclusão',
        ),
        content: const Text(
          'Tem certeza que deseja '
          'excluir este post?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                ctx,
                false,
              );
            },
            child: const Text(
              'Cancelar',
            ),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red,
              foregroundColor:
                  Colors.white,
            ),
            onPressed: () {
              Navigator.pop(
                ctx,
                true,
              );
            },
            child: const Text(
              'Excluir',
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      return;
    }

    try {
      final statusCode =
          await PostService.deletePost(id);

      setState(() {
        _posts.removeWhere(
          (p) => p.id == id,
        );

        _postsFiltrados =
            List.from(_posts);
      });

      _mostrarSnackBar(
        'Post removido com sucesso! '
        'Status Code: $statusCode',
        Colors.orange,
      );
    } catch (e) {
      _mostrarSnackBar(
        e.toString(),
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.deepPurple,
        foregroundColor:
            Colors.white,
        centerTitle: true,
        title: _pesquisando
            ? TextField(
                controller:
                    _searchController,
                autofocus: true,
                style:
                    const TextStyle(
                  color: Colors.white,
                ),
                decoration:
                    const InputDecoration(
                  hintText:
                      'Pesquisar post...',
                  hintStyle:
                      TextStyle(
                    color:
                        Colors.white70,
                  ),
                  border:
                      InputBorder.none,
                ),
                onChanged:
                    _filtrarPosts,
              )
            : const Text(
                'Gerenciador de Posts '
                '(REST API)',
              ),
        actions: [
          IconButton(
            icon: Icon(
              _pesquisando
                  ? Icons.close
                  : Icons.search,
            ),
            onPressed: () {
              setState(() {
                _pesquisando =
                    !_pesquisando;

                if (!_pesquisando) {
                  _searchController.clear();

                  _postsFiltrados =
                      List.from(_posts);
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _carregarPosts,
              child:
                  _postsFiltrados.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(
                              height: 200,
                            ),
                            Center(
                              child: Text(
                                'Nenhum post '
                                'encontrado.',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount:
                              _postsFiltrados
                                  .length,
                          itemBuilder:
                              (ctx, index) {
                            final post =
                                _postsFiltrados[
                                    index];

                            return Card(
                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                title: Text(
                                  post.title,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                subtitle:
                                    Text(
                                  post.body,
                                ),
                                trailing: Row(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,
                                  children: [
                                    IconButton(
                                      icon:
                                          const Icon(
                                        Icons.edit,
                                        color:
                                            Colors
                                                .blue,
                                      ),
                                      onPressed:
                                          () {
                                        _abrirFormulario(
                                          post:
                                              post,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(
                                        Icons.delete,
                                        color:
                                            Colors
                                                .red,
                                      ),
                                      onPressed:
                                          () {
                                        _deletarPost(
                                          post.id!,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          _abrirFormulario();
        },
        backgroundColor:
            Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}