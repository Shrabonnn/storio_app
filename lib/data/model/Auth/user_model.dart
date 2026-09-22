import '../../../res/api_url/app_url.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final bool? isActive;
  final bool? isSuperuser;
  final String? dateJoined;
  final RoleModel? role;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;
  final String? slug;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.isActive,
    this.isSuperuser,
    this.dateJoined,
    this.role,
    this.phoneNumber,
    this.address,
    this.profilePicture,
    this.slug,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawPicture = (json['profile_picture_url'] ?? json['profile_picture'])?.toString();

    final formattedProfilePicture = (rawPicture != null && rawPicture.isNotEmpty)
        ? (rawPicture.startsWith('http') ? rawPicture : '${AppUrl.baseUrl}$rawPicture')
        : null;

    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'],
      isSuperuser: json['is_superuser'],
      dateJoined: json['date_joined'],
      role: json['role'] != null && json['role'] is Map<String, dynamic>
          ? RoleModel.fromJson(json['role'])
          : null,
      phoneNumber: json['phone_number'],
      address: json['address'],
      profilePicture: formattedProfilePicture,
      slug: json['slug'],
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
      'date_joined': dateJoined,
      'role': role?.toJson(),
      'phone_number': phoneNumber,
      'address': address,
      'profile_picture': profilePicture,
      'slug': slug,
    };
  }
}

class RoleModel {
  final int id;
  final String name;

  RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// Request Models
class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class CreateUserRequestModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String? address;
  final int? roleId;

  CreateUserRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    this.address,
    this.roleId,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'confirm_password': confirmPassword,
    'phone_number': phoneNumber,
    if (address != null) 'address': address,
    if (roleId != null) 'role_id': roleId,
  };
}