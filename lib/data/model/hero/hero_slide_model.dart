import '../../../../res/api_url/app_url.dart';

class HeroSlideModel {
  int? id;
  String? heading;
  String? subheading;
  String? buttonText;
  String? buttonLink;
  String? bgType;
  int? bgImage;
  BgImageData? bgImageData;
  String? bgImageUrl;
  String? bgColor;
  String? gradientFrom;
  String? gradientTo;
  int? gradientDir;
  String? status;
  String? textPosition;
  String? headingColor;
  String? subheadingColor;
  String? buttonColor;
  String? buttonTextColor;
  int? order;
  DateTime? createDate;
  DateTime? updateDate;

  HeroSlideModel(
      {this.id,
        this.heading,
        this.subheading,
        this.buttonText,
        this.buttonLink,
        this.bgType,
        this.bgImage,
        this.bgImageData,
        this.bgImageUrl,
        this.bgColor,
        this.gradientFrom,
        this.gradientTo,
        this.gradientDir,
        this.status,
        this.textPosition,
        this.headingColor,
        this.subheadingColor,
        this.buttonColor,
        this.buttonTextColor,
        this.order,
        this.createDate,
        this.updateDate});

  HeroSlideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    subheading = json['subheading'];
    buttonText = json['buttonText'];
    buttonLink = json['buttonLink'];
    bgType = json['bgType'];
    bgImage = json['bgImage'];

    bgImageData = json['bgImage_data'] != null
        ? BgImageData.fromJson(json['bgImage_data'])
        : null;

    bgImageUrl = json['bgImage_url'];
    bgColor = json['bgColor'];
    gradientFrom = json['gradientFrom'];
    gradientTo = json['gradientTo'];
    gradientDir = json['gradientDir'];
    status = json['status'];
    textPosition = json['textPosition'];
    headingColor = json['headingColor'];
    subheadingColor = json['subheadingColor'];
    buttonColor = json['buttonColor'];
    buttonTextColor = json['buttonTextColor'];
    order = json['order'];

    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;

    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['heading'] = this.heading;
    data['subheading'] = this.subheading;
    data['buttonText'] = this.buttonText;
    data['buttonLink'] = this.buttonLink;
    data['bgType'] = this.bgType;
    data['bgImage'] = this.bgImage;
    data['bgImage_data'] = this.bgImageData?.toJson();
    data['bgImage_url'] = this.bgImageUrl;
    data['bgColor'] = this.bgColor;
    data['gradientFrom'] = this.gradientFrom;
    data['gradientTo'] = this.gradientTo;
    data['gradientDir'] = this.gradientDir;
    data['status'] = this.status;
    data['textPosition'] = this.textPosition;
    data['headingColor'] = this.headingColor;
    data['subheadingColor'] = this.subheadingColor;
    data['buttonColor'] = this.buttonColor;
    data['buttonTextColor'] = this.buttonTextColor;
    data['order'] = this.order;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class BgImageData {
  int? id;
  String? file;
  String? fileName;
  String? title;
  String? altText;

  BgImageData(
      {this.id, this.file, this.fileName, this.title, this.altText});

  BgImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;

    fileName = json['file_name'];
    title = json['title'];
    altText = json['alt_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['file'] = this.file;
    data['file_name'] = this.fileName;
    data['title'] = this.title;
    data['alt_text'] = this.altText;
    return data;
  }
}