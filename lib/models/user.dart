enum UserRole { client, owner }

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String telephone;
  final String username;
  final String gender;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephone,
    required this.username,
    required this.gender,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'telephone': telephone,
      'username': username,
      'gender': gender,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create User from Firestore Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      telephone: map['telephone'] ?? '',
      username: map['username'] ?? '',
      gender: map['gender'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.client,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Copy with method for updates
  User copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? telephone,
    String? username,
    String? gender,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  bool get isClient => role == UserRole.client;
  bool get isOwner => role == UserRole.owner;
}
