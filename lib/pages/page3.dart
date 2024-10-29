import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/widgets/list.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  TextEditingController titleController = TextEditingController();
  // ignore: prefer_final_fields
  Completer<void> _primaryCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Text(
                'Todolist',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'FontsFree',
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2.0,
                  color: Color(0xff0095a3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nom de la tâche',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: soumettreData,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xff0095a3),
                      ),
                      child: const Center(
                        child: Text(
                          "Soumettre",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TodoList(),
                        ),
                      );
                    },
                    child: const Text(
                      "Créer un",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> soumettreData() async {
    final titre = titleController.text.trim();
    if (titre.isEmpty) {
      showErrorMessage('Veuillez entrer un titre.');
      return;
    }

    final body = {
      "contenu": titre,
    };
    // ignore: prefer_const_declarations
    final url = 'https://todolist-api-production-1e59.up.railway.app/task';
    final uri = Uri.parse(url);

    try {
      final reponse = await http.post(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      if (reponse.statusCode == 401) {
        titleController.text = '';

        final prefs = await SharedPreferences.getInstance();
        List<String> tasks = prefs.getStringList('tasks') ?? [];
        tasks.add(titre);
        await prefs.setStringList('tasks', tasks);

        showSuccessMessage('Tâche ajoutée');
      } else {
        showErrorMessage('Tâche refusée');
        // ignore: avoid_print
        print(reponse.body);
      }
    } finally {
      if (!_primaryCompleter.isCompleted) {
        _primaryCompleter.complete();
      }
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
