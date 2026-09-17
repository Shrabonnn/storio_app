
class RoleModel {
  final int? id;
  final String? name;
  final List<int>? permissions;
  final List<PermissionModel>? permissionDetails;
  final int? userCount;

  RoleModel({
    this.id,
    this.name,
    this.permissions,
    this.permissionDetails,
    this.userCount,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      permissions: json['permissions'] != null
          ? List<int>.from(json['permissions'])
          : [],
      permissionDetails: json['permission_details'] != null
          ? (json['permission_details'] as List)
          .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
      userCount: json['user_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions': permissions,
      'permission_details':
      permissionDetails?.map((e) => e.toJson()).toList(),
      'user_count': userCount,
    };
  }
}



class PermissionModel {
  final int? id;
  final String? name;
  final String? codename;
  final String? appLabel;
  final String? model;

  PermissionModel({
    this.id,
    this.name,
    this.codename,
    this.appLabel,
    this.model,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      codename: json['codename'] as String?,
      appLabel: json['app_label'] as String?,
      model: json['model'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'codename': codename,
      'app_label': appLabel,
      'model': model,
    };
  }
}