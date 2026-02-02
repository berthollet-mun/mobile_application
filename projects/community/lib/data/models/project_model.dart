class ProjectModel {
  final int id;
  final String nom;
  final String description;
  final int created_by;
  final DateTime created_at;
  final DateTime? archived_at;
  final String? creator_nom;
  final String? creator_prenom;
  final int tasks_count;
  final int completed_tasks;
  final double completion_percentage;

  ProjectModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.created_by,
    required this.created_at,
    this.archived_at,
    this.creator_nom,
    this.creator_prenom,
    this.tasks_count = 0,
    this.completed_tasks = 0,
    this.completion_percentage = 0.0,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      created_by: json['created_by'] ?? 0,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      archived_at: json['archived_at'] != null
          ? DateTime.tryParse(json['archived_at'])
          : null,
      creator_nom: json['creator_nom'],
      creator_prenom: json['creator_prenom'],
      tasks_count: json['tasks_count'] ?? 0,
      completed_tasks: json['completed_tasks'] ?? 0,
      completion_percentage: (json['completion_percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'created_by': created_by,
      'created_at': created_at.toIso8601String(),
      'archived_at': archived_at?.toIso8601String(),
      'creator_nom': creator_nom,
      'creator_prenom': creator_prenom,
      'tasks_count': tasks_count,
      'completed_tasks': completed_tasks,
      'completion_percentage': completion_percentage,
    };
  }

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
    double? completion_percentage,
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
          completion_percentage ?? this.completion_percentage,
    );
  }

  // Getters utiles
  bool get isArchived => archived_at != null;

  String get creatorFullName {
    if (creator_prenom == null && creator_nom == null) return 'Inconnu';
    return '${creator_prenom ?? ''} ${creator_nom ?? ''}'.trim();
  }
}
