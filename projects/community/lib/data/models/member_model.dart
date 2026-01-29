class MemberModel {
  final int id;
  final String email;
  final String nom;
  final String prenom;
  final String role;
  final DateTime joinedAt;

  MemberModel({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.joinedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      role: json['role'],
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  String get fullName => '$prenom $nom';
}
