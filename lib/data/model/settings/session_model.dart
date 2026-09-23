class SessionModel {
  int? id;
  String? device; // e.g. "Windows Desktop - Chrome"
  String? location; // e.g. "Dhaka, Bangladesh" (geo-resolved from IP)
  String? ipAddress;
  DateTime? lastActive;
  DateTime? createdAt;
  bool? isCurrent;

  SessionModel({
    this.id,
    this.device,
    this.location,
    this.ipAddress,
    this.lastActive,
    this.createdAt,
    this.isCurrent,
  });

  SessionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    device = json['device'];
    location = json['location'];
    ipAddress = json['ip_address'];

    lastActive = json['last_active'] != null
        ? DateTime.tryParse(json['last_active'])
        : null;

    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;

    isCurrent = json['is_current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['device'] = this.device;
    data['location'] = this.location;
    data['ip_address'] = this.ipAddress;
    data['last_active'] = this.lastActive?.toIso8601String();
    data['created_at'] = this.createdAt?.toIso8601String();
    data['is_current'] = this.isCurrent;
    return data;
  }
}