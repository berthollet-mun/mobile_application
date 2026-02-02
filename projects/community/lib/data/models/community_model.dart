class CommunityModel {
  final int community_id;
  final String nom;
  final String description;
  final int invite_code;
  final String role;
  final DateTime? joined_at;
  final DateTime? created_at;
  final String? creator_nom;
  final String? creator_prenom;
  final int members_count;
  final int projects_count;

  CommunityModel({
    required this.community_id,
    required this.nom,
    required this.description,
    required this.invite_code,
    required this.role,
    this.joined_at,
    this.created_at,
    this.creator_nom,
    this.creator_prenom,
    this.members_count = 1,
    this.projects_count = 0,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    // 🔍 DEBUG
    print('=== PARSING COMMUNITY ===');
    print('JSON reçu: $json');
    print('=========================');
    
    return CommunityModel(
      community_id: _parseInt(json['community_id']),
      nom: json['nom']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      invite_code: _parseInt(json['invite_code']),
      role: json['role']?.toString() ?? 'MEMBRE',
      joined_at: _parseDate(json['joined_at']),
      created_at: _parseDate(json['created_at']),
      creator_nom: json['creator_nom']?.toString(),
      creator_prenom: json['creator_prenom']?.toString(),
      members_count: _parseInt(json['members_count'], defaultValue: 1),
      projects_count: _parseInt(json['projects_count'], defaultValue: 0),
    );
  }

  // Helper pour parser les int de manière sécurisée
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // Helper pour parser les dates de manière sécurisée
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'community_id': community_id,
      'nom': nom,
      'description': description,
      'invite_code': invite_code,
      'role': role,
      if (joined_at != null) 'joined_at': joined_at!.toIso8601String(),
      if (created_at != null) 'created_at': created_at!.toIso8601String(),
      if (creator_nom != null) 'creator_nom': creator_nom,
      if (creator_prenom != null) 'creator_prenom': creator_prenom,
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

  // Getters utiles
  String get inviteCodeString => invite_code.toString();
  String get fullCreatorName => '${creator_prenom ?? ''} ${creator_nom ?? ''}'.trim();
}