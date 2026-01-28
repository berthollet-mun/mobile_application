class CommunityModel {
  int community_id;
  String nom;
  String description;
  int invite_code;
  String role;
  DateTime joined_at;
  DateTime created_at;
  String creator_nom;
  String creator_prenom;
  int members_count;
  int projects_count;

  CommunityModel({
    required this.community_id,
    required this.nom,
    required this.description,
    required this.invite_code,
    required this.role,
    required this.joined_at,
    required this.created_at,
    required this.creator_nom,
    required this.creator_prenom,
    required this.members_count,
    required this.projects_count,
  });

  // Convertir un Map json en communute
  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      community_id: json['community_id'],
      nom: json['nom'],
      description: json['description'],
      invite_code: json['invite_code'],
      role: json['role'],
      joined_at: DateTime.parse(json['joined_at']),
      created_at: DateTime.parse(json['created_at']),
      creator_nom: json['creator_nom'],
      creator_prenom: json['creator_prenom'],
      members_count: json['members_count'],
      projects_count: json['projects_count'],
    );
  }

  //conversion d'une communaute en json
  Map<String, dynamic> toJson() {
    return {
      'community_id': community_id,
      'nom': nom,
      'description': description,
      'invite_code': invite_code,
      'role': role,
      'joined_at': joined_at.toIso8601String(),
      'created_at': created_at.toIso8601String(),
      'creator_nom': creator_nom,
      'creator_prenom': creator_prenom,
      'members_count': members_count,
      'projects_count': projects_count,
    };
  }

  CommunityModel copyWith({
    int? community_id,
    String? nom,
    String? description,
    int? invite_code,
    String? role,
    DateTime? joined_at,
    DateTime? created_at,
    String? creator_nom,
    String? creator_prenom,
    int? members_count,
    int? projects_count,
  }) {
    return CommunityModel(
      community_id: community_id ?? this.community_id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      invite_code: invite_code ?? this.invite_code,
      role: role ?? this.role,
      joined_at: joined_at ?? this.joined_at,
      created_at: created_at ?? this.created_at,
      creator_nom: creator_nom ?? this.creator_nom,
      creator_prenom: creator_prenom ?? this.creator_prenom,
      members_count: members_count ?? this.members_count,
      projects_count: projects_count ?? this.projects_count,
    );
  }
}
