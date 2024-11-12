import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<User> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final token = await _getToken();
    if (token == null) {
      // ignore: avoid_print
      print("Aucun token trouvé");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://todolist-api-production-1e59.up.railway.app/user/info'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userInfo = data;
        });
      } else {
        // ignore: avoid_print
        print("Erreur de chargement des infos : ${response.statusCode}");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur de requête : $e");
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Informations de l'utilisateur")),
      body: userInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nom: ${userInfo!['name']}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Email: ${userInfo!['email']}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
