class UserRoleModel {
  final int? id;
  final String? name;

  UserRoleModel({this.id, this.name});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ManageUserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  bool? isActive;
  final bool? isSuperuser;
  final DateTime? dateJoined;
  final DateTime? lastLogin;
  UserRoleModel? role;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;

  ManageUserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.isActive,
    this.isSuperuser,
    this.dateJoined,
    this.lastLogin,
    this.role,
    this.phoneNumber,
    this.address,
    this.profilePicture,
  });

  factory ManageUserModel.fromJson(Map<String, dynamic> json) {
    return ManageUserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      isActive: json['is_active'] as bool?,
      isSuperuser: json['is_superuser'] as bool?,
      dateJoined: json['date_joined'] != null
          ? DateTime.tryParse(json['date_joined'])
          : null,
      lastLogin: json['last_login'] != null
          ? DateTime.tryParse(json['last_login'])
          : null,
      role: json['role'] != null ? UserRoleModel.fromJson(json['role']) : null,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'is_superuser': isSuperuser,
      'date_joined': dateJoined?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'role': role?.toJson(),
      'phone_number': phoneNumber,
      'address': address,
      'profile_picture': profilePicture,
    };
  }
}