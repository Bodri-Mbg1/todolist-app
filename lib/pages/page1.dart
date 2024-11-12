import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todolist_app/pages/page2.dart';
import 'package:todolist_app/pages/page3.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passToggle = true;

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Veuillez remplir tous les champs.");
      return;
    }

    try {
      // ignore: avoid_print
      print('Email: $email');
      // ignore: avoid_print
      print('Mot de passe: $password');

      final response = await http.post(
        Uri.parse(
            'https://todolist-api-production-1e59.up.railway.app/auth/connexion'),
        body: {
          "email": email,
          "password": password,
        },
      );

      // ignore: avoid_print
      print('Statut de la réponse: ${response.statusCode}');
      // ignore: avoid_print
      print('Corps de la réponse: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String accessToken = data['accessToken'];
        // ignore: avoid_print
        print('Connexion réussie. Token: $accessToken');

        await _storeToken(accessToken); // Enregistrer le token
        await _verifyStoredToken(); // Vérifier le token stocké

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Page3()),
        );
      } else if (response.statusCode == 401) {
        _showErrorDialog("Identifiants invalides. Veuillez réessayer.");
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['message'] != null && errorData['message'].isNotEmpty
                ? errorData['message'].join(', ')
                : "Erreur inconnue. Veuillez réessayer.";

        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur de connexion: $e");
      _showErrorDialog("Une erreur s'est produite. Veuillez réessayer.");
    }
  }

  // Méthode pour stocker le token
  Future<void> _storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);

    // ignore: avoid_print
    print("Token sauvegardé avec succès : $token");
  }

  // Méthode pour vérifier que le token est stocké correctement
  Future<void> _verifyStoredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    // ignore: avoid_print
    print("Token vérifié après stockage : $token");
  }

  // Méthode pour afficher un dialogue d'erreur
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur de connexion'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                      const SizedBox(height: 14),
                      const Text(
                        'Mot de passe',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: passwordController,
                        obscureText: passToggle,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            child: Icon(passToggle
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          login(emailController.text, passwordController.text);
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "Connexion",
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 550),
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Vous n'avez pas de compte ?",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Page2(),
                              ),
                            );
                          },
                          child: const Text(
                            "Créer un",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
}
