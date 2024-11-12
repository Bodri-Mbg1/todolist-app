import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todolist_app/pages/user.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<dynamic> taches = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recupererTaches();
  }

  Future<void> _recupererTaches() async {
    final token = await recupererToken();
    if (token == null) {
      // ignore: avoid_print
      print("Aucun token trouvé");
      return;
    }
    try {
      final response = await http.get(
          Uri.parse('https://todolist-api-production-1e59.up.railway.app/task'),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        setState(() {
          taches = jsonDecode(response.body);
        });
      } else {
        // ignore: avoid_print
        print(
            'Erreur lors de la récupération des tâches : ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur de requête : $e");
    }
  }

  Future<void> ajouterTache(String contenu) async {
    final token = await recupererToken();
    if (token == null) {
      // ignore: avoid_print
      print("Aucun token trouvé");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://todolist-api-production-1e59.up.railway.app/task'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'contenu': contenu}),
      );

      if (response.statusCode == 201) {
        _recupererTaches();
      } else {
        // ignore: avoid_print
        print('Erreur lors de l\'ajout de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur lors de l'ajout de la tâche : $e");
    }
  }

  Future<void> modifierTache(String idTache, String nouveauNom) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task/$idTache');
    final corps = jsonEncode({'contenu': nouveauNom});
    final token = await recupererToken();
    if (token == null) {
      // ignore: avoid_print
      print("Aucun token trouvé");
      return;
    }

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: corps);
      if (response.statusCode == 200) {
        _recupererTaches();
      } else {
        // ignore: avoid_print
        print(
            'Erreur lors de la mise à jour de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur de requête : $e");
    }
  }

  Future<void> supprimerTache(String idTache) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task/$idTache');
    final token = await recupererToken();
    if (token == null) {
      // ignore: avoid_print
      print("Aucun token trouvé");
      return;
    }
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        _recupererTaches();
      } else {
        // ignore: avoid_print
        print(
            'Erreur lors de la suppression de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur de requête : $e");
    }
  }

  Future<String?> recupererToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  void afficherDialogueModification(String idTache) {
    TextEditingController nouveauNomController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier la tâche"),
          content: TextField(
            controller: nouveauNomController,
            decoration: const InputDecoration(hintText: "Nouveau nom de tâche"),
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Sauvegarder"),
              onPressed: () {
                modifierTache(idTache, nouveauNomController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Todolist",
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'FontsFree',
            fontWeight: FontWeight.bold,
            letterSpacing: -2.0,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff0095a3),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Infos Utilisateur'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const User()),
                );
              },
            ),
            // Ajoutez d’autres options ici si nécessaire
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(1.0)),
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0095a3)),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  ajouterTache(_controller.text);
                  _controller.clear();
                }
              },
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xff0095a3),
                ),
                child: const Center(
                  child: Text(
                    "Ajouter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: taches.length,
                itemBuilder: (context, index) {
                  final tache = taches[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.brightness_1,
                      size: 15,
                      color: Color(0xff0095a3),
                    ),
                    title: Text(tache['contenu'] ?? 'Tâche sans nom'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            final idTache = tache['id'];
                            afficherDialogueModification(idTache);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            final idTache = tache['id'];
                            supprimerTache(idTache);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
