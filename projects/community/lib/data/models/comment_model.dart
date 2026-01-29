class CommentModel {
  int id;
  String content;
  String nom;
  String prenom;
  String email;
  DateTime created_at;
  DateTime updated_at;

  CommentModel({
    required this.id,
    required this.content,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.created_at,
    required this.updated_at,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
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
      'updated_at': updated_at.toIso8601String(),
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
}
