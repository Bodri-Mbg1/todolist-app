import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:todolist_app/pages/page1.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Fonction d'inscription avec vérification des champs
  void regist(String user, String email, String password) async {
    // Vérifiez que tous les champs sont remplis
    if (user.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog("Veuillez remplir tous les champs");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://todolist-api-production-1e59.up.railway.app/auth/inscription'),
        headers: {'Content-Type': 'application/json'}, // En-tête JSON
        body: jsonEncode({
          "nom": user,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String accessToken = data['accessToken'];
        print('Inscription réussie. Token: $accessToken');

        // Rediriger vers la page de connexion après création de compte
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Page1()),
        );
      } else if (response.statusCode == 409) {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'];
        _showErrorDialog(errorMessage);
      } else {
        print('Erreur lors de l\'inscription: ${response.statusCode}');
        print('Message de l\'API: ${response.body}');
        _showErrorDialog("Erreur inconnue lors de l'inscription.");
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      _showErrorDialog("Une erreur s'est produite. Veuillez réessayer.");
    }
  }

  // Méthode pour afficher un dialogue d'erreur
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0095a3),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Todolist',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'FontsFree',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 170),
              child: Center(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nom utilisateur',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: userController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Email',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Mot de passe',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          regist(userController.text, emailController.text,
                              passwordController.text);
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "Créer le compte",
                              style: TextStyle(
                                color: Color(0xff0095a3),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
