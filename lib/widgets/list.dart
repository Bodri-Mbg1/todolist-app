import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map;
          return ListTile(
            title: Text(item['titre'] ?? 'Pas de titre'),
          );
        },
      ),
    );
  }

  Future<void> fetchTodo() async {
    // ignore: prefer_const_declarations
    final url = 'https://todolist-api-production-1e59.up.railway.app/task';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 401) {
      final json = jsonDecode(response.body);
      // ignore: avoid_print
      print(json);

      if (json['items'] != null && json['items'] is List) {
        setState(() {
          items = json['items'];
        });
      } else {
        // ignore: avoid_print
        print("La clé 'items' n'existe pas ou est nulle.");
      }
    } else {
      // ignore: avoid_print
      print("Erreur : ${response.statusCode}");
      // ignore: avoid_print
      print("Contenu de la réponse : ${response.body}");
    }
  }
}
