class ActivityModel {
  int id;
  String activity_type;
  String description;
  String nom;
  String prenom;
  String email;
  DateTime created_at;

  ActivityModel({
    required this.id,
    required this.activity_type,
    required this.description,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.created_at,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      activity_type: json['activity_type'],
      description: json['description'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      created_at: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_type': activity_type,
      'description': description,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'created_at': created_at,
    };
  }

  ActivityModel copyWith({
    int? id,
    String? activity_type,
    String? description,
    String? nom,
    String? prenom,
    String? email,
    DateTime? created_at,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      activity_type: activity_type ?? this.activity_type,
      description: description ?? this.description,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      created_at: created_at ?? this.created_at,
    );
  }

  String get fullName => '$prenom $nom'.trim();
}
