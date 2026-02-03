class CommentModel {
  final int id;
  final String content;
  final String nom;
  final String prenom;
  final String email;
  final DateTime created_at;
  final DateTime? updated_at; // ✅ Nullable

  CommentModel({
    required this.id,
    required this.content,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.created_at,
    this.updated_at, // ✅ Optionnel
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content']?.toString() ?? json['contenu']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updated_at: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'created_at': created_at.toIso8601String(),
      if (updated_at != null) 'updated_at': updated_at!.toIso8601String(),
    };
  }

  CommentModel copyWith({
    int? id,
    String? content,
    String? nom,
    String? prenom,
    String? email,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  String get fullName => '$prenom $nom'.trim();
}
