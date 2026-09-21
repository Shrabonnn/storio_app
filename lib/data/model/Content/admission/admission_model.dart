// ================================================================
// FORM CONFIG
// ================================================================
class AdmissionFormConfigModel {
  int? id;
  String? title;
  String? description;
  bool? isActive;
  String? deadline; // Form deadline (e.g., ISO date string)
  List<AdmissionFormFieldModel>? fields;

  AdmissionFormConfigModel({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.deadline,
    this.fields,
  });

  AdmissionFormConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isActive = json['is_active'];
    deadline = json['deadline'];

    if (json['fields'] != null) {
      fields = <AdmissionFormFieldModel>[];
      json['fields'].forEach((v) {
        fields!.add(AdmissionFormFieldModel.fromJson(v));
      });
      // Sort fields by order index if present
      fields!.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['is_active'] = isActive;
    data['deadline'] = deadline;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdmissionFormFieldModel {
  String? id; // Unique field key (e.g. "student_name")
  String? label;
  String? type; // text, email, tel, number, date, select, radio, checkbox, textarea, file, image
  bool? required;
  int? order;
  List<String>? options; // Options for select, radio, or checkbox types
  AdmissionFieldLogicModel? logic; // Conditional display logic

  AdmissionFormFieldModel({
    this.id,
    this.label,
    this.type,
    this.required,
    this.order,
    this.options,
    this.logic,
  });

  AdmissionFormFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    type = json['type'];
    required = json['required'];
    order = json['order'];

    if (json['options'] != null) {
      options = List<String>.from(json['options']);
    }

    logic = json['logic'] != null
        ? AdmissionFieldLogicModel.fromJson(json['logic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['type'] = type;
    data['required'] = required;
    data['order'] = order;
    if (options != null) {
      data['options'] = options;
    }
    if (logic != null) {
      data['logic'] = logic!.toJson();
    }
    return data;
  }
}

class AdmissionFieldLogicModel {
  String? sourceField;
  String? operator; // 'equals' | 'not_equals'
  String? value;

  AdmissionFieldLogicModel({
    this.sourceField,
    this.operator,
    this.value,
  });

  AdmissionFieldLogicModel.fromJson(Map<String, dynamic> json) {
    sourceField = json['sourceField'] ?? json['source_field'];
    operator = json['operator'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceField'] = sourceField;
    data['operator'] = operator;
    data['value'] = value;
    return data;
  }
}

// ================================================================
// APPLICATION
// ================================================================
class AdmissionApplicationModel {
  int? id;
  String? applicationNumber;
  Map<String, dynamic>? formData;
  String? status; // pending / approved / rejected
  DateTime? submittedAt;
  DateTime? reviewedAt;
  String? reviewerNotes;
  String? ipAddress;
  List<AdmissionApplicationFileModel>? files;

  AdmissionApplicationModel({
    this.id,
    this.applicationNumber,
    this.formData,
    this.status,
    this.submittedAt,
    this.reviewedAt,
    this.reviewerNotes,
    this.ipAddress,
    this.files,
  });

  AdmissionApplicationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    applicationNumber = json['application_number'];

    if (json['form_data'] != null) {
      formData = Map<String, dynamic>.from(json['form_data']);
    }

    status = json['status'];

    submittedAt = json['submitted_at'] != null
        ? DateTime.tryParse(json['submitted_at'])
        : null;

    reviewedAt = json['reviewed_at'] != null
        ? DateTime.tryParse(json['reviewed_at'])
        : null;

    reviewerNotes = json['reviewer_notes'];
    ipAddress = json['ip_address'];

    if (json['files'] != null) {
      files = <AdmissionApplicationFileModel>[];
      json['files'].forEach((v) {
        files!.add(AdmissionApplicationFileModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['application_number'] = applicationNumber;
    data['form_data'] = formData;
    data['status'] = status;
    data['submitted_at'] = submittedAt?.toIso8601String();
    data['reviewed_at'] = reviewedAt?.toIso8601String();
    data['reviewer_notes'] = reviewerNotes;
    data['ip_address'] = ipAddress;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdmissionApplicationFileModel {
  int? id;
  String? fieldId;
  String? file;
  DateTime? createdAt;

  AdmissionApplicationFileModel({
    this.id,
    this.fieldId,
    this.file,
    this.createdAt,
  });

  AdmissionApplicationFileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldId = json['field_id'];
    file = json['file'];
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['field_id'] = fieldId;
    data['file'] = file;
    data['created_at'] = createdAt?.toIso8601String();
    return data;
  }
}