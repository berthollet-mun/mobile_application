class TaskModel {
  int id;
  String titre;
  String description;
  String project_nom;
  String status;
  int assigned_to;
  String assigned_nom;
  String assigned_prenom;
  String assigned_email;
  String creator_nom;
  String creator_prenom;
  DateTime due_date;
  int comments_count;
  DateTime created_at;

  TaskModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.project_nom,
    required this.status,
    required this.assigned_to,
    required this.assigned_nom,
    required this.assigned_prenom,
    required this.assigned_email,
    required this.creator_nom,
    required this.creator_prenom,
    required this.due_date,
    required this.comments_count,
    required this.created_at,
  });

  //
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      project_nom: json['project_nom'],
      status: json['status'],
      assigned_to: json['assigned_to'],
      assigned_nom: json['assigned_nom'],
      assigned_prenom: json['assigned_prenom'],
      assigned_email: json['assigned_email'],
      creator_nom: json['creator_nom'],
      creator_prenom: json['creator_prenom'],
      due_date: DateTime.parse(json['due_date']),
      comments_count: json['comments_count'],
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'project_nom': project_nom,
      'status': status,
      'assigned_to': assigned_to,
      'assigned_nom': assigned_nom,
      'assigned_prenom': assigned_prenom,
      'assigned_email': assigned_email,
      'creator_nom': creator_nom,
      'creator_prenom': creator_prenom,
      'due_date': due_date.toIso8601String(),
      'comments_count': comments_count,
      'created_at': created_at.toIso8601String(),
    };
  }

  TaskModel copyWith({
    int? id,
    String? titre,
    String? description,
    String? project_nom,
    String? status,
    int? assigned_to,
    String? assigned_nom,
    String? assigned_prenom,
    String? assigned_email,
    String? creator_nom,
    String? creator_prenom,
    DateTime? due_date,
    int? comments_count,
    DateTime? created_at,
  }) {
    return TaskModel(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      project_nom: project_nom ?? this.project_nom,
      status: status ?? this.status,
      assigned_to: assigned_to ?? this.assigned_to,
      assigned_nom: assigned_nom ?? this.assigned_nom,
      assigned_prenom: assigned_prenom ?? this.assigned_prenom,
      assigned_email: assigned_email ?? this.assigned_email,
      creator_nom: creator_nom ?? this.creator_nom,
      creator_prenom: creator_prenom ?? this.creator_prenom,
      due_date: due_date ?? this.due_date,
      comments_count: comments_count ?? this.comments_count,
      created_at: created_at ?? this.created_at,
    );
  }
}
