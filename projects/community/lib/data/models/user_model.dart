class UserModel {
  final int user_id;
  final String email;
  final String? password; // ✅ Nullable car pas toujours retourné
  final String nom;
  final String prenom;
  final DateTime? created_at; // ✅ Nullable car pas toujours retourné
  final String? token; // ✅ Ajouté pour stocker le token

  UserModel({
    required this.user_id,
    required this.email,
    this.password,
    required this.nom,
    required this.prenom,
    this.created_at,
    this.token,
  });

  // Convertir un Map json en User
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // ✅ Gérer le cas où user_id est un String ou un int
      user_id: json['user_id'] is String
          ? int.parse(json['user_id'])
          : json['user_id'],
      email: json['email'] ?? '',
      password: json['password'], // ✅ Peut être null
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      // ✅ Gérer le cas où created_at n'existe pas
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      token: json['token'], // ✅ Stocker le token
    );
  }

  // Conversion d'un User en Json
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'email': email,
      if (password != null) 'password': password,
      'nom': nom,
      'prenom': prenom,
      if (created_at != null) 'created_at': created_at!.toIso8601String(),
      if (token != null) 'token': token,
    };
  }

  UserModel copyWith({
    int? user_id,
    String? email,
    String? password,
    String? nom,
    String? prenom,
    DateTime? created_at,
    String? token,
  }) {
    return UserModel(
      user_id: user_id ?? this.user_id,
      email: email ?? this.email,
      password: password ?? this.password,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      created_at: created_at ?? this.created_at,
      token: token ?? this.token,
    );
  }

  // Méthode utilitaire pour obtenir le nom complet
  String get nomComplet => '$prenom $nom';

  @override
  String toString() {
    return 'UserModel(user_id: $user_id, email: $email, nom: $nom, prenom: $prenom)';
  }
}
