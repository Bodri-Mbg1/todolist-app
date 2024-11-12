class Utilisateur {
  String nom;
  String email;
  String passWord;

  Utilisateur({required this.email, required this.passWord, required this.nom});

  Map<String, dynamic> toMap() {
    return {'nom': nom, 'email': email, 'password': passWord};
  }

  static Utilisateur fromMap(Map<String, dynamic> map) {
    return Utilisateur(
        email: map['email'], passWord: map['password'], nom: map['nom']);
  }
}
