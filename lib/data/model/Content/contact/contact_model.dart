class ContactMessageModel {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? subject;
  String? message;
  String? status;
  DateTime? submittedAt;
  DateTime? readAt;
  String? ipAddress;

  ContactMessageModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.subject,
    this.message,
    this.status,
    this.submittedAt,
    this.readAt,
    this.ipAddress,
  });

  ContactMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];

    submittedAt = json['submitted_at'] != null
        ? DateTime.tryParse(json['submitted_at'])
        : null;

    readAt = json['read_at'] != null
        ? DateTime.tryParse(json['read_at'])
        : null;

    ipAddress = json['ip_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['status'] = this.status;
    data['submitted_at'] = this.submittedAt?.toIso8601String();
    data['read_at'] = this.readAt?.toIso8601String();
    data['ip_address'] = this.ipAddress;
    return data;
  }
}