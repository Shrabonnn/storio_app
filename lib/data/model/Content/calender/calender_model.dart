class CalendarEventModel {
  int? id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? category; // academic / holiday / examination / festival / admin
  String? categoryDisplay;
  String? level; // school-wide / primary / secondary / college
  String? levelDisplay;
  bool? isAllDay;
  DateTime? createdAt;
  DateTime? updatedAt;

  CalendarEventModel({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.category,
    this.categoryDisplay,
    this.level,
    this.levelDisplay,
    this.isAllDay,
    this.createdAt,
    this.updatedAt,
  });

  CalendarEventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];

    startDate = json['start_date'] != null
        ? DateTime.tryParse(json['start_date'])
        : null;

    endDate = json['end_date'] != null
        ? DateTime.tryParse(json['end_date'])
        : null;

    category = json['category'];
    categoryDisplay = json['category_display'];
    level = json['level'];
    levelDisplay = json['level_display'];
    isAllDay = json['is_all_day'];

    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;

    updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate?.toIso8601String();
    data['end_date'] = this.endDate?.toIso8601String();
    data['category'] = this.category;
    data['category_display'] = this.categoryDisplay;
    data['level'] = this.level;
    data['level_display'] = this.levelDisplay;
    data['is_all_day'] = this.isAllDay;
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();
    return data;
  }
}

class CalendarSettingsModel {
  // Raw comma-separated string as the API sends/expects it,
  // e.g. "5,6" (0=Sunday ... 6=Saturday).
  String? weekendDays;

  CalendarSettingsModel({this.weekendDays});

  CalendarSettingsModel.fromJson(Map<String, dynamic> json) {
    weekendDays = json['weekend_days'];
  }

  Map<String, dynamic> toJson() {
    return {'weekend_days': weekendDays};
  }

  // Convenience getter for UI (e.g. checkbox list of weekdays).
  List<int> get weekendDayIndexes {
    if (weekendDays == null || weekendDays!.trim().isEmpty) return [];
    return weekendDays!
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList();
  }
}