import 'dart:convert'; // Ajoutez ceci pour jsonEncode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  TextEditingController titleController = TextEditingController();

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour envoyer les données à l'API avec authentification
  Future<void> soumettreData() async {
    final title = titleController.text;
    final url = 'https://todolist-api-production-1e59.up.railway.app/task';
    final uri = Uri.parse(url);

    // En-têtes pour l'authentification et le type de contenu
    final headers = {
      "Authorization":
          "Bearer votre_token", // Remplacez 'votre_token' par le vrai token
      "Content-Type": "application/json",
    };

    // Corps de la requête, encodé en JSON
    final body = jsonEncode({"contenu": title});

    try {
      // Envoi de la requête POST avec les en-têtes et le corps JSON
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Tâche ajoutée : $title");
      } else {
        print("Erreur lors de l'ajout de la tâche : ${response.statusCode}");
        print(
            "Message de l'erreur : ${response.body}"); // Affiche la réponse complète pour le débogage
      }
    } catch (e) {
      print("Une erreur est survenue : $e"); // Affiche toute autre erreur
    }
  }
}
