class ImportantLinksBoardSettingsModel {
  int? id;
  List<String>? selectedBoards;
  bool? isEnabled;
  String? boardUrl;

  ImportantLinksBoardSettingsModel({
    this.id,
    this.selectedBoards,
    this.isEnabled,
    this.boardUrl,
  });

  ImportantLinksBoardSettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selectedBoards = json['selected_boards'] != null
        ? List<String>.from(json['selected_boards'])
        : [];

    isEnabled = json['is_enabled'];
    boardUrl = json['board_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selected_boards': selectedBoards,
      'is_enabled': isEnabled,
      'board_url': boardUrl,
    };
  }
}

class EducationBoardNoticeModel {
  String? title;
  String? url;
  String? publishDate;

  EducationBoardNoticeModel({
    this.title,
    this.url,
    this.publishDate,
  });

  EducationBoardNoticeModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    publishDate = json['publish_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'publish_date': publishDate,
    };
  }
}

class EducationBoardNoticesResponseModel {
  List<String>? boards;
  int? count;
  List<EducationBoardNoticeModel>? notices;

  EducationBoardNoticesResponseModel({
    this.boards,
    this.count,
    this.notices,
  });

  EducationBoardNoticesResponseModel.fromJson(Map<String, dynamic> json) {
    boards = json['boards'] != null
        ? List<String>.from(json['boards'])
        : [];

    count = json['count'];

    notices = json['notices'] != null
        ? (json['notices'] as List)
        .map(
          (e) => EducationBoardNoticeModel.fromJson(e),
    )
        .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'boards': boards,
      'count': count,
      'notices': notices?.map((e) => e.toJson()).toList(),
    };
  }
}