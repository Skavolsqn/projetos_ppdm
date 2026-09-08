import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com/posts';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl?_limit=10'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body =
          jsonDecode(response.body);

      return body
          .map((json) => Post.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Falha ao carregar postagens. Status: ${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> createPost(
    Post post,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return {
        'post': Post.fromJson(
          jsonDecode(response.body),
        ),
        'statusCode': response.statusCode,
      };
    } else {
      throw Exception(
        'Falha ao criar postagem. Status: ${response.statusCode}',
      );
    }
  }

  static Future<Map<String, dynamic>> updatePost(
    int id,
    Post post,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return {
        'post': Post.fromJson(
          jsonDecode(response.body),
        ),
        'statusCode': response.statusCode,
      };
    } else {
      throw Exception(
        'Falha ao atualizar postagem. Status: ${response.statusCode}',
      );
    }
  }

  static Future<int> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception(
        'Falha ao excluir postagem. Status: ${response.statusCode}',
      );
    }
  }
}