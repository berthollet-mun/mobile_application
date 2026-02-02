class ProjectModel {
  int id;
  String nom;
  String description;
  int created_by;
  DateTime created_at;
  DateTime archived_at;
  String creator_nom;
  String creator_prenom;
  int tasks_count;
  int completed_tasks;
  double completion_percentage;

  ProjectModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.created_by,
    required this.created_at,
    required this.archived_at,
    required this.creator_nom,
    required this.creator_prenom,
    required this.tasks_count,
    required this.completed_tasks,
    required this.completion_percentage,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      created_by: json['created_by'],
      created_at: DateTime.parse(json['created_at']),
      archived_at: DateTime.parse(json['archived_at']),
      creator_nom: json['creator_nom'],
      creator_prenom: json['creator_prenom'],
      tasks_count: json['tasks_count'],
      completed_tasks: json['completed_tasks'],
      completion_percentage: json['completion_percentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'created_by': created_by,
      'created_at': created_at.toIso8601String(),
      'archived_at': archived_at.toIso8601String(),
      'creator_nom': creator_nom,
      'creator_prenom': creator_prenom,
      'tasks_count': tasks_count,
      'completed_tasks': completed_tasks,
      'completion_percentage': completion_percentage,
    };
  }

  // CORRECTION ICI : changer int? en double?
  ProjectModel copyWith({
    int? id,
    String? nom,
    String? description,
    int? created_by,
    DateTime? created_at,
    DateTime? archived_at,
    String? creator_nom,
    String? creator_prenom,
    int? tasks_count,
    int? completed_tasks,
    double? completion_percentage, // Changer int? → double?
  }) {
    return ProjectModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      created_by: created_by ?? this.created_by,
      created_at: created_at ?? this.created_at,
      archived_at: archived_at ?? this.archived_at,
      creator_nom: creator_nom ?? this.creator_nom,
      creator_prenom: creator_prenom ?? this.creator_prenom,
      tasks_count: tasks_count ?? this.tasks_count,
      completed_tasks: completed_tasks ?? this.completed_tasks,
      completion_percentage:
          completion_percentage ?? this.completion_percentage, // ✅ Type correct
    );
  }

  bool get isArchived => archived_at != null;
}
